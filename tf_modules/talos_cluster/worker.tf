locals {
    worker_hostnames = {
      for idx, worker in var.talos_cluster.workers : worker.ip => format("%s-worker-%s", var.talos_cluster.name, idx)
    }
}

data "talos_machine_configuration" "worker" {
  cluster_name     = var.talos_cluster.name
  cluster_endpoint = var.talos_cluster.endpoint
  machine_type     = "worker"
  machine_secrets  = talos_machine_secrets.cluster_secrets.machine_secrets
}

resource "talos_machine_configuration_apply" "worker" {
  client_configuration        = talos_machine_secrets.cluster_secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  for_each                    = { for worker in var.talos_cluster.workers : worker.ip => worker }
  node                        = each.key
  config_patches = [
    templatefile("${path.module}/templates/install-disk-and-hostname.yaml.tmpl", {
      hostname     = local.worker_hostnames[each.key]
      install_disk = each.value.install_disk
    })
  ]
}
