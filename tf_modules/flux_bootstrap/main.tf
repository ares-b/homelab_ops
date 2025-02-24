
resource "flux_bootstrap_git" "flux" {
  embedded_manifests  = true
  path                = var.flux_bootstrap.git_repo_path
  interval            = var.flux_bootstrap.flux_interval
  namespace           = var.flux_bootstrap.flux_namespace
  components          = var.flux_bootstrap.flux_components
  components_extra    = var.flux_bootstrap.flux_extra_components
}