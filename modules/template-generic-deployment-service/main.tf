module "deployment-service" {
  source               = "../generic-deployment-service"
  name                 = var.name
  namespace            = var.namespace
  image                = var.image
  replicas             = var.replicas
  ports                = var.ports
  command              = var.command
  args                 = var.args
  env                  = var.env
  env_map              = var.env_map
  env_file             = var.env_file
  env_from             = var.env_from
  annotations          = var.annotations
  image_pull_secrets   = var.image_pull_secrets
  node_selector        = var.node_selector
  resources            = var.resources
  overrides            = var.overrides
  configmap            = var.configmap
  configmap_mount_path = var.configmap_mount_path
  post_start_command   = var.post_start_command
  pvc                  = var.pvc
  mount_path           = var.mount_path
  {% if not use_rbac -%}
  service_account_name = var.service_account_name
  {%- endif %}
}