include "common" {
  path = "${get_repo_root()}/terragrunt/common.hcl"
}

terraform {
  source = "${get_repo_root()}/tf_modules/talos_cluster"
}