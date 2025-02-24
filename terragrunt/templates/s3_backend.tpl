
terraform {
  backend "s3" {
    access_key  = "${access_key}"
    secret_key  = "${secret_key}"
    bucket         = "${bucket}"
    key            = "${key}"
    region         = "${region}"
    encrypt        = true
  }
  encryption {
    key_provider "pbkdf2" "state_plan_encryption_kp" {
      passphrase = "${client_side_encryption_passphrase}"
      key_length = 32
      iterations = 600000
      salt_length = 32
      hash_function = "sha512"
    }

    method "aes_gcm" "state_plan_encryption_method" {
      keys = key_provider.pbkdf2.state_plan_encryption_kp
    }

    state {
      method = method.aes_gcm.state_plan_encryption_method
    }

    plan {
      method = method.aes_gcm.state_plan_encryption_method
    }
  }
}
