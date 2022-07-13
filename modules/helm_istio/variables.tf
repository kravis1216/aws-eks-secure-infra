variable "istio_namespace" {
  type        = string
  default     = "kube-system"
  description = "Namespace of Istio"
}

variable "helm_istio_base_release_name" {
  type        = string
  description = "Release name of Istio Base."
}

variable "helm_istio_base_chart" {
  type        = string
  description = "Chart for Istio Base."
}

variable "istio_base_set" {
  type        = list(any)
  default     = []
  description = "Set for Istio Base."
}

variable "helm_istio_discovery_release_name" {
  type        = string
  description = "Release name of Istio Discovery."
}

variable "helm_istio_discovery_chart" {
  type        = string
  description = "Chart for Istio Discovery."
}

variable "istio_discovery_set" {
  type        = list(any)
  default     = []
  description = "Set for Istio Discovery."
}

variable "helm_istio_operator_release_name" {
  type        = string
  description = "Release name of Istio Operator."
}

variable "helm_istio_operator_chart" {
  type        = string
  description = "Chart for Istio Operator."
}

variable "istio_operator_set" {
  type        = list(any)
  default     = []
  description = "Set for Istio Operator."
}

variable "helm_istio_ingress_release_name" {
  type        = string
  description = "Release name of Istio Ingress."
}

variable "helm_istio_ingress_chart" {
  type        = string
  description = "Chart for Istio Ingress."
}

variable "istio_ingress_set" {
  type        = list(any)
  default     = []
  description = "Set for Istio Ingress."
}

variable "helm_istio_egress_release_name" {
  type        = string
  description = "Release name of Istio Egress."
}

variable "helm_istio_egress_chart" {
  type        = string
  description = "Chart for Istio Egress."
}

variable "istio_egress_set" {
  type        = list(any)
  default     = []
  description = "Set for Istio Egress."
}

