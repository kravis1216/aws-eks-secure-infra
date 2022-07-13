
#---------------------------------------------------------------
# local variables
#---------------------------------------------------------------
locals {
  main_cluster_name            = "${local.main_cluster_name_prefix}_main"
  inhouse_nodegroup_name       = "${local.main_cluster_name_prefix}_inhouse_worker"
  inhouse_worker_template_name = "${local.launch_template_name_prefix}_inhouse_worker"
  leonet_nodegroup_name        = "${local.main_cluster_name_prefix}_leonet_worker"
  leonet_worker_template_name  = "${local.launch_template_name_prefix}_leonet_worker"
  main_global_accelerator_name = "${local.global_accelerator_name_prefix}-main"
}


#---------------------------------------------------------------
# modules 
#---------------------------------------------------------------
### ========== EKS Cluster ========== ####

module "main_cluster" {
  /*
  providers = {
    helm = helm.main_cluster
  }
*/

  source = "./modules/eks_cluster"

  cluster_name     = local.main_cluster_name
  k8s_version      = var.k8s_version
  cluster_role_arn = aws_iam_role.eks_cluster_role.arn

  encryption_key_arn   = module.eks.kms_key_arn
  encryption_resources = ["secrets"]
  enabled_cluster_log_types = [
    "api", "audit", "authenticator", "controllerManager", "scheduler"
  ]

  cluster_security_group_ids = [
    aws_security_group.eks_master.id,
    aws_security_group.eks_nodes.id
  ]

  subnet_ids = [
    aws_subnet.private_eks_apn1a.id,
    aws_subnet.private_eks_apn1c.id,
    aws_subnet.private_eks_apn1d.id
  ]
  /*
  node_labels = {
    "ingress/ready" = "true"
  }
*/
  tags = merge(local.tags, {
    Name                                                      = "${local.main_cluster_name}"
    Type                                                      = "${local.type_eks}"
    "kubernetes.io/cluster/${local.main_cluster_prefix}-main" = "shared"
    "k8s.io/cluster-autoscaler/${local.main_cluster_name}"    = "owned",
    "k8s.io/cluster-autoscaler/enabled"                       = true
  })
}

### ========== EKS NodeGroup(INHOUSE) ========== ####

module "inhouse_nodegroup" {
  source = "./modules/eks_nodegroup"

  name_of_node_group = local.inhouse_nodegroup_name

  name_of_cluster = module.main_cluster.eks_cluster_id
  node_role_arn   = aws_iam_role.eks_nodes_roles.arn
  subnet_ids = [
    aws_subnet.private_eks_apn1a.id,
    aws_subnet.private_eks_apn1c.id,
    aws_subnet.private_eks_apn1d.id
  ]
  instance_types = var.inhouse_node_group.instance_types
  scaling_config = {
    desirec_size = var.inhouse_node_group.desired_capacity
    max_size     = var.inhouse_node_group.max_capacity
    min_size     = var.inhouse_node_group.min_capacity
  }

  node_tags = merge(local.tags, {
    Name = "${local.inhouse_nodegroup_name}"
    Type = "${local.type_eks}"
  })

  launch_template_name      = local.inhouse_worker_template_name
  launch_template_user_data = base64encode(file("./data/eks_inhouse_nodes_userdata.tpl"))
  launch_template_tags = merge(local.tags, {
    Name = "${local.inhouse_worker_template_name}"
    Type = "${local.type_launch_template}"
  })
}

### ========== EKS NodeGroup(LEONET) ========== ####

module "leonet_nodegroup" {
  source = "./modules/eks_nodegroup"

  name_of_node_group = local.leonet_nodegroup_name

  name_of_cluster = module.main_cluster.eks_cluster_id
  node_role_arn   = aws_iam_role.eks_nodes_roles.arn
  subnet_ids = [
    aws_subnet.private_eks_apn1a.id,
    aws_subnet.private_eks_apn1c.id,
    aws_subnet.private_eks_apn1d.id
  ]
  instance_types = var.leonet_node_group.instance_types
  scaling_config = {
    desirec_size = var.leonet_node_group.desired_capacity
    max_size     = var.leonet_node_group.max_capacity
    min_size     = var.leonet_node_group.min_capacity
  }

  node_tags = merge(local.tags, {
    Name = "${local.leonet_nodegroup_name}"
    Type = "${local.type_eks}"
  })

  launch_template_name      = local.leonet_worker_template_name
  launch_template_user_data = base64encode(file("./data/eks_leonet_userdata.tpl"))
  launch_template_tags = merge(local.tags, {
    Name = "${local.leonet_worker_template_name}"
    Type = "${local.type_launch_template}"
  })
}

module "main_cluster_istio" {
  source = "./modules/helm_istio"

  providers = {
    helm = helm.main_cluster
  }

  istio_namespace = "istio-system"

  helm_istio_base_release_name = "base"
  helm_istio_base_chart        = "./helm/istio/base"

  helm_istio_discovery_release_name = "istio-discovery"
  helm_istio_discovery_chart        = "./helm/istio/istio-control/istio-discovery"
  istio_discovery_set = [
    {
      name  = "global.hub"
      value = "gcr.io/istio-release"
    },
    {
      name  = "global.tag"
      value = var.istio_version
    },
    {
      name  = "global.proxy.tracer"
      value = "datadog"
    },
    {
      name  = "pilot.traceSampling"
      value = 100.0
    }
  ]

  helm_istio_operator_release_name = "istio-operator"
  helm_istio_operator_chart        = "./helm/istio/istio-operator"

  helm_istio_ingress_release_name = "istio-ingress"
  helm_istio_ingress_chart        = "./helm/istio/gateways/istio-ingress"
  istio_ingress_set = [
    {
      name  = "global.hub"
      value = "gcr.io/istio-release"
    },
    {
      name  = "global.tag"
      value = var.istio_version
    },
    {
      name  = "gateways.istio-ingressgateway.autoscaleMin"
      value = 3
    },
    {
      name  = "gateways.istio-ingressgateway.autoscaleMax"
      value = 10
    },
    {
      name  = "gateways.istio-ingressgateway.type"
      value = "NodePort"
    },
    {
      name  = "meshConfig.enablePrometheusMerge"
      value = true
    },
    {
      name  = "gateways.istio-ingressgateway.targetgroupbinding.enabled"
      value = true
    },
    {
      name  = "release"
      value = timestamp()
    }
  ]

  helm_istio_egress_release_name = "istio-egress"
  helm_istio_egress_chart        = "./helm/istio/gateways/istio-egress"
  istio_egress_set = [
    {
      name  = "global.hub"
      value = "gcr.io/istio-release"
    },
    {
      name  = "global.tag"
      value = var.istio_version
    },
    {
      name  = "gateways.istio-egressgateway.autoscaleMin"
      value = 3
    },
    {
      name  = "gateways.istio-egressgateway.autoscaleMax"
      value = 6
    },
    {
      name  = "release"
      value = timestamp()
    }
  ]
}

module "internet_facing" {
  source = "./modules/internet_facing_ingress"

  globalaccelerator_name = local.main_global_accelerator_name
  ip_address_type        = "IPV4"

  flow_logs_enabled = false
  # flow_logs_s3_bucket
  # flow_logs_s3_prefix

  globalaccelerator_tags = merge(local.tags, {
    Name = "${local.main_global_accelerator_name}"
    Type = "${local.type_global_accelerator}"
  })

  listeners = [
    {
      client_affinity = "NONE"
      protocol        = "TCP"
      port_ranges = [
        {
          from_port = 443
          to_port   = 443
        }
      ]
    }
  ]
}

module "aws_lb_controller" {
  source = "./modules/helm_release"

  providers = {
    helm = helm.main_cluster
  }

  enable_release     = true
  release_name       = "main"
  release_chart      = "aws-load-balancer-controller"
  release_repository = "https://aws.github.io/eks-charts"
  release_namespace  = "kube-system"

  release_set = [
    {
      name  = "clusterName"
      value = module.main_cluster.eks_cluster_name
    },
    {
      name  = "serviceAccount.create"
      value = true
    },
    {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = aws_iam_role.alb_controller.arn
    },
    {
      name  = "region"
      value = var.region
    },
    {
      name  = "vpcId"
      value = aws_vpc.main_vpc.id
    }
  ]
}

/*
#---------------------------------------------------------------
# kubernetes_ingress
#---------------------------------------------------------------
resource "kubernetes_ingress" "default" {
  provicer = kubernetes.in-house

  metadata {
    name = "${local.ingress_name_prefix}-in-house"
    namespace = "istio-system"
      annotations = {
        "kubernetes.io/ingress.class"        = "alb"
        "alb.ingress.kubernetes.io/scheme"        = "internet-facing"
        "alb.ingress.kubernetes.io/tags"         = "Project=${var.project},Environment=${var.environment},Type=${local.type_alb},ManagedBy=Terraform,Name=${local.alb_ingress_name}"
        "alb.ingress.kubernetes.io/listen-ports"  = "[{\"HTTP\": 80}, {\"HTTPS\": 443}]"
      }
    }
  spec {
    backend = 
       
  }
  }
}
*/
