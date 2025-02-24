locals {
    tf_backend    = jsondecode(
        get_env("TF_BACKEND")
    )
    config = yamldecode(
        sops_decrypt_file("${get_terragrunt_dir()}/config.yaml")
    )
    client_side_encryption_passphrase = get_env("CLIENT_SIDE_ENCRYPTION_PASSPHRASE")
}
generate "backend" {
    path        = "backend.tf"
    if_exists   = "overwrite_terragrunt"
    contents    = templatefile("templates/s3_backend.tpl", {
        bucket      = local.tf_backend.bucket
        region      = local.tf_backend.region
        key         = "${basename(get_terragrunt_dir())}/terraform.tfstate"
        access_key  = local.tf_backend.access_key
        secret_key  = local.tf_backend.secret_key
        client_side_encryption_passphrase = local.client_side_encryption_passphrase
    })
}

inputs = local.config