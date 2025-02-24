
resource "talos_machine_secrets" "cluster_secrets" {}

data "talos_client_configuration" "this" {
  cluster_name         = var.talos_cluster.name
  client_configuration = talos_machine_secrets.cluster_secrets.client_configuration
  endpoints            = [for cp in var.talos_cluster.control_planes : cp.ip]
}

resource "talos_machine_bootstrap" "this" {
  depends_on = [talos_machine_configuration_apply.controlplane]

  client_configuration = talos_machine_secrets.cluster_secrets.client_configuration
  node                 = var.talos_cluster.control_planes[0].ip
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on           = [talos_machine_bootstrap.this]
  client_configuration = talos_machine_secrets.cluster_secrets.client_configuration
  node                 = var.talos_cluster.control_planes[0].ip
}