locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    replicas             = var.replicas
    enable_service_links = false

    containers = [
      {
        name    = "worker-usage"
        image   = var.image
        command = ["worker-usage"]

        env = concat([
          { name = "_APP_ENV", value = var._APP_ENV },
          { name = "_APP_REDIS_HOST", value = var._APP_REDIS_HOST },
          { name = "_APP_REDIS_PORT", value = var._APP_REDIS_PORT },
          { name = "_APP_STATSD_HOST", value = var._APP_STATSD_HOST },
          { name = "_APP_STATSD_PORT", value = var._APP_STATSD_PORT },
        ], var.env)
      }
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
