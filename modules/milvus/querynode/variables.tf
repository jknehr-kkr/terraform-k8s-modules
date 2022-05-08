variable "name" {}

variable "namespace" {}

variable "image" {
  default = "milvusdb/milvus:v2.0.2"
}

variable "replicas" {
  default = 1
}

variable "env" {
  default = []
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
      cpu    = "250m"
      memory = "64Mi"
    }
  }
}

variable "overrides" {
  default = {}
}

variable "ETCD_ENDPOINTS" {}

variable "MINIO_ADDRESS" {}

variable "MINIO_ACCESS_KEY" {}

variable "MINIO_SECRET_KEY" {}

variable "PULSAR_ADDRESS" {}