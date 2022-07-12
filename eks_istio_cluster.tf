
#---------------------------------------------------------------
# local variables
#---------------------------------------------------------------
locals {
  main_cluster_name                    = "${local.main_cluster_name_prefix}_main"
  launch_template_name_for_main_worker = "${local.launch_template_name_prefix}_main_worker"
}


#---------------------------------------------------------------
# modules 
#---------------------------------------------------------------
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
  /*
  node_role_arn        = aws_iam_role.eks_nodes_roles.arn
*/
  encryption_key_arn   = module.eks.kms_key_arn
  encryption_resources = ["secrets"]
  enabled_cluster_log_types = [
    "api", "audit", "authenticator", "controllerManager", "scheduler"
  ]

  /*
  instance_types   = var.node_group_ondemand.instance_types.main_cluster
  desired_capacity = var.node_group_ondemand.desired_capacity
  max_capacity     = var.node_group_ondemand.max_capacity
  min_capacity     = var.node_group_ondemand.min_capacity
*/
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

/*
  ### --- Node --- ###
  launch_template = {
    createflag = true
    name       = "${local.launch_template_name_for_main_worker}"
    userdata   = base64encode(file("./data/eks_nodes_userdata.tpl"))
    tags = merge(local.tags, {
      Name = "${local.launch_template_name_prefix}_worker"
      Type = "${local.type_launch_template}"
    })
  }

  ### --- Istio --- ###
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
    },
  ]

  ### --- AWS LB Controller ---- ###
  helm_aws-lb-controller_namespace    = "kube-system"
  helm_aws-lb-controller_release_name = "aws-alb-ingress-controller"
  helm_aws-lb-controller_chart        = "aws-load-balancer-controller"
  helm_aws-lb-controller_repository   = "https://aws.github.io/eks-charts"

  aws-lb-controller_set = [
    {
      name  = "clusterName"
      value = module.main_cluster.cluster_name
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

#---------------------------------------------------------------
# kubernetes_ingress
#---------------------------------------------------------------
data "kubernetes_service" "example" {
  provider = kubernetes.main_cluster

  metadata {
    name = "terraform-example"
  }
}

output "test" {
  value = [data.kubernetes_service.example]
}
/*
/*
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
