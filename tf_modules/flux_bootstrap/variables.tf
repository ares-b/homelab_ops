variable flux_bootstrap {
    type        = object({
        git_repo_path            = string
        flux_interval           = optional(string, "1m0s")
        flux_namespace          = optional(string, "flux")
        flux_components         = optional(set(string), [
            "source-controller",
            "kustomize-controller",
            "helm-controller",
            "notification-controller",
        ])
        flux_extra_components   = optional(set(string), [
            "image-reflector-controller",
            "image-automation-controller"
        ])
    })
    sensitive = true
}