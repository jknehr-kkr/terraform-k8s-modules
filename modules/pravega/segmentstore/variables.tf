variable "name" {}

variable "namespace" {}

variable "image" {
  default = "pravega/pravega:0.11.0"
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "tcp"
      port = 12345
    },
    {
      name = "rpc"
      port = 9090
    },
  ]
}

variable "env" {
  default = []
}
variable "env_map" {
  default = {}
}
variable "env_file" {
  default = null
}

variable "annotations" {
  default = {}
}

variable "node_selector" {
  default = {}
}

variable "resources" {
  default = {
    requests = {
      cpu    = "125m"
      memory = "64Mi"
    }
  }
}

variable "service_account_name" {
  default = null
}

variable "overrides" {
  default = {}
}

variable "ZK_URL" {}
variable "CONTROLLER_URL" {}
variable "JAVA_OPTS" {
  default = ""
}
