variable talos_cluster {
    type = object({
        name            = string
        endpoint        = string
        control_planes  = list(object({
            install_disk    = string
            ip              = string
            cp_scheduling   = optional(bool, true)
        }))
        workers         = optional(list(object({
            install_disk    = string
            ip              = string
        })), [])
    })
}