locals {
    config = yamldecode(
        sops_decrypt_file("${get_terragrunt_dir()}/config.yaml")
    )
    kubeconfig_filename = "kubeconfig"
}

include "common" {
  path = "${get_repo_root()}/terragrunt/common.hcl"
}

dependency "talos_cluster" {
    config_path = "${get_repo_root()}/terragrunt/talos_cluster"
}

generate "kubeconfig" {
    path        = local.kubeconfig_filename
    if_exists   = "overwrite"
    contents    = dependency.talos_cluster.outputs.kubeconfig
    disable_signature = true
}

generate "provider" {
    path        = "provider.tf"
    if_exists   = "overwrite"
    contents    = templatefile("${get_repo_root()}/terragrunt/templates/flux.tpl", {
        kubernetes_config_path              = local.kubeconfig_filename
        git_url                             = local.config.git_repo
        git_username                        = local.config.git_username
        git_password                        = local.config.git_token
    })
}

inputs = local.config.flux_bootstrap

terraform {
  source = "${get_repo_root()}/tf_modules/flux_bootstrap"
  after_hook "clean_kubeconfig" {
    commands = ["init", "plan", "apply"]
    execute = [
      "rm", "${get_working_dir()}/kubeconfig"
    ]
  }
}
