#---------------------------------------------------------------                             
# helm(istio)                            
#---------------------------------------------------------------
resource "helm_release" "istio_base" {
  name             = var.helm_istio_base_release_name
  chart            = var.helm_istio_base_chart
  namespace        = var.istio_namespace
  create_namespace = true

  dynamic "set" {
    iterator = item
    for_each = var.istio_base_set == null ? [] : var.istio_base_set

    content {
      name  = item.value.name
      value = item.value.value
    }
  }
}

resource "helm_release" "istio_discovery" {
  name             = var.helm_istio_discovery_release_name
  chart            = var.helm_istio_discovery_chart
  namespace        = var.istio_namespace
  create_namespace = true

  dynamic "set" {
    iterator = item
    for_each = var.istio_discovery_set == null ? [] : var.istio_discovery_set

    content {
      name  = item.value.name
      value = item.value.value
    }
  }
}

resource "helm_release" "istio_operator" {
  name             = var.helm_istio_operator_release_name
  chart            = var.helm_istio_operator_chart
  namespace        = var.istio_namespace
  create_namespace = true

  dynamic "set" {
    iterator = item
    for_each = var.istio_operator_set == null ? [] : var.istio_operator_set

    content {
      name  = item.value.name
      value = item.value.value
    }
  }
}

resource "helm_release" "istio_ingress" {
  name             = var.helm_istio_ingress_release_name
  chart            = var.helm_istio_ingress_chart
  namespace        = var.istio_namespace
  create_namespace = true

  dynamic "set" {
    iterator = item
    for_each = var.istio_ingress_set == null ? [] : var.istio_ingress_set

    content {
      name  = item.value.name
      value = item.value.value
    }
  }
}

resource "helm_release" "istio_egress" {
  name             = var.helm_istio_egress_release_name
  chart            = var.helm_istio_egress_chart
  namespace        = var.istio_namespace
  create_namespace = true

  dynamic "set" {
    iterator = item
    for_each = var.istio_egress_set == null ? [] : var.istio_egress_set

    content {
      name  = item.value.name
      value = item.value.value
    }
  }
}
