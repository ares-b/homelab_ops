terraform {
  required_version = ">= 1.7.0"

  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = ">= 1.2"
    }
  }
}

provider "flux" {
  kubernetes = {
    config_path = "${kubernetes_config_path}"
  }
  git = {
    url = "${git_url}"
    http = {
      username = "${git_username}"
      password = "${git_password}"
    }
  }
}