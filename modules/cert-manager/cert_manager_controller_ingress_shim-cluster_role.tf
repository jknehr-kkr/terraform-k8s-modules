resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "cert_manager_controller_ingress_shim" {
  metadata {
    labels = {
      "app"                         = "cert-manager"
      "app.kubernetes.io/component" = "controller"
      "app.kubernetes.io/instance"  = "cert-manager"
      "app.kubernetes.io/name"      = "cert-manager"
    }
    name = "cert-manager-controller-ingress-shim"
  }

  rules {
    api_groups = [
      "cert-manager.io",
    ]
    resources = [
      "certificates",
      "certificaterequests",
    ]
    verbs = [
      "create",
      "update",
      "delete",
    ]
  }
  rules {
    api_groups = [
      "cert-manager.io",
    ]
    resources = [
      "certificates",
      "certificaterequests",
      "issuers",
      "clusterissuers",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "extensions",
    ]
    resources = [
      "ingresses",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "extensions",
    ]
    resources = [
      "ingresses/finalizers",
    ]
    verbs = [
      "update",
    ]
  }
  rules {
    api_groups = [
      "",
    ]
    resources = [
      "events",
    ]
    verbs = [
      "create",
      "patch",
    ]
  }
}