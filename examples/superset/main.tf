resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "postgres" {
  source        = "../../modules/postgres"
  name          = "postgres"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  storage_class = var.storage_class_name
  storage       = "1Gi"
  replicas      = 1

  POSTGRES_USER     = "superset"
  POSTGRES_PASSWORD = "superset"
  POSTGRES_DB       = "superset"
}

module "redis" {
  source    = "../../modules/redis"
  name      = "redis"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "config" {
  source    = "../../modules/kubernetes/config-map"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-file = "${path.module}/superset_config.py"
}

resource "random_password" "secret_key" {
  length  = 256
  special = false
}

module "env" {
  source = "../../modules/kubernetes/env"
  from-map = {
    DATABASE_DIALECT  = "postgresql"
    DATABASE_HOST     = module.postgres.name
    DATABASE_PORT     = module.postgres.ports[0].port
    DATABASE_DB       = "superset"
    DATABASE_USER     = "superset"
    DATABASE_PASSWORD = "superset"
    REDIS_HOST        = module.redis.name

    FLASK_ENV      = "production"
    SUPERSET_ENV   = "production",
    SECRET_KEY     = random_password.secret_key.result
    CYPRESS_CONFIG = false
    SUPERSET_PORT  = 8088
    ADMIN_USERNAME = "admin",
    ADMIN_PASSWORD = "admin",

    SUPERSET_LOAD_EXAMPLES = "yes"
  }
}

module "superset" {
  source    = "../../modules/superset"
  name      = "superset"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  annotations = {
    "config_checksum" = module.config.checksum
  }

  config_configmap = module.config.config_map
  env              = module.env.kubernetes_env
}

module "superset-beat" {
  source    = "../../modules/superset/celery"
  name      = "superset-beat"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  annotations = {
    "config_checksum" = module.config.checksum
  }

  config_configmap = module.config.config_map
  env              = module.env.kubernetes_env
  type             = "beat"
}

module "superset-worker" {
  source    = "../../modules/superset/celery"
  name      = "superset-worker"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  annotations = {
    "config_checksum" = module.config.checksum
  }

  config_configmap = module.config.config_map
  env              = module.env.kubernetes_env
  type             = "worker"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "superset" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
    }
    name      = module.superset.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service_name = module.superset.name
            service_port = module.superset.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
