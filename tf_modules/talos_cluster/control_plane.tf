locals {
  controlplane_hostnames = {
    for idx, cp in var.talos_cluster.control_planes : cp.ip => format("%s-cp-%s", var.talos_cluster.name, idx)
  }
}

data "talos_machine_configuration" "controlplane" {
  cluster_name     = var.talos_cluster.name
  cluster_endpoint = var.talos_cluster.endpoint
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.cluster_secrets.machine_secrets
}

resource "talos_machine_configuration_apply" "controlplane" {
  client_configuration        = talos_machine_secrets.cluster_secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
  for_each                    = { for cp in var.talos_cluster.control_planes : cp.ip => cp }
  node                        = each.value.ip
  config_patches = [
    templatefile("${path.module}/templates/install-disk-and-hostname.yaml.tmpl", {
      hostname     = local.controlplane_hostnames[each.key]
      install_disk = each.value.install_disk
    }),
    templatefile("${path.module}/templates/cp-scheduling.yaml.tmpl", {
      cp_scheduling = each.value.cp_scheduling
    }),
  ]
}
