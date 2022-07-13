locals {
  # COMMON
  project        = var.project
  env            = terraform.workspace == "default" ? var.environment : terraform.workspace
  short_region   = var.short_region[var.region]
  name           = "${var.project}-${local.env}-${local.short_region}"
  name_wo_region = "${var.project}-${local.env}"

  # domain_name = var.domain_name

  /*
  account_id = data.aws_caller_identity.current.account_id
  */

  tags = {
    Project     = local.project
    Environment = local.env
    ManagedBy   = "terraform"
  }

  /*
  ssl_certificate_arn = var.create_acm_certificate ? module.acm.acm_certificate_arn : data.aws_acm_certificate.main[0].arn
  zone_id = var.create_r53_zone ? keys(module.r53_zone.route53_zone_zone_id)[0] : (var.zone_id != null ? var.zone_id : data.aws_route53_zone.main[0].zone_id)
  */

  ## Type for AWS
  type_alb                 = "alb"
  type_cloudwatch_logs     = "clw_log"
  type_codebuild           = "codebuild"
  type_codecommit          = "codecommit"
  type_codepipeline        = "codepipeline"
  type_config              = "config"
  type_config_managed_rule = "config_managed_rule"
  type_cfn                 = "cfn"
  type_cloudtrail          = "cloudtrail"
  type_db_subnet_group     = "db_subnet_group"
  type_dynamodb            = "dynamodb"
  type_ecr                 = "ecr"
  type_ec2                 = "ec2"
  type_efs                 = "efs"
  type_eip                 = "eip"
  type_eks                 = "eks"
  type_elasticache         = "elasticache"
  type_eventbridge         = "eventbridge"
  # Only alphanumeric characters and hyphens are allowed for name of Global Accelerator.
  type_global_accelerator = "global-accelerator"
  type_iam_policy         = "iam_policy"
  type_iam_role           = "iam_role"
  type_iam_user           = "iam_user"
  type_igw                = "igw"
  type_inspector          = "inspector"
  type_kms                = "kms"
  type_launch_template    = "launch_template"
  type_lambda             = "lambda"
  type_ngw                = "ngw"
  type_rds                = "rds"
  type_rtb                = "rtb"
  type_s3                 = "s3"
  type_sbn                = "sbn"
  type_secretmanager      = "secretmanager"
  type_sg                 = "sg"
  type_ssm                = "ssm"
  type_sns                = "sns"
  type_waf                = "waf"
  type_redshift           = "redshift"
  type_r53                = "r53"
  type_vpc                = "vpc"
  type_vpce               = "vpce"
  type_tgw                = "tgw"

  ## Type for k8s
  type_ingress = "ingress"

  ## Name/Prefix for CodeBuild
  codebuild_project_prefix = "${local.project}-${local.env}-${local.type_codebuild}"

  ## Name/Prefix for CodeCommit
  codecommit_repository_rpefix = "${local.project}-${local.env}-${local.type_codecommit}"

  ## Name/Prefix for CodePipeline
  codepipeline_prefix = "${local.project}-${local.env}-${local.type_codepipeline}"


  ## Name/Prefix for CloudFormation
  cloudformation_prefix = "${local.project}-${local.env}-${local.type_cfn}"

  ## Name/Prefix for CloudWatch
  clw_logs_group_prefix = "${local.project}-${local.env}-${local.type_cloudwatch_logs}"

  ## Name/Prefix for CloudTrail
  cloudtrail_name_prefix = "${local.project}-${local.env}-${local.type_cloudtrail}"

  ## Name/Prefix for DB Subnet
  db_subnet_group_prefix = "${local.project}-${local.env}-${local.type_db_subnet_group}"

  ## Name/Prefix for DynamoDB
  dynamodb_name_prefix = "${local.project}-${local.env}-${local.type_dynamodb}"

  ## Name/Prefix for ECR
  ecr_repositry_prefix = "${local.project}-${local.env}-${local.type_ecr}"

  ## Name/Prefix for EC2
  ec2_name_prefix = "${local.project}-${local.env}-${local.type_ec2}"

  ## Name/Prefix for EFS
  efs_name_prefix = "${local.project}-${local.env}-${local.type_efs}"

  ## Name/Prefix for eventbridge
  eventbridge_name_prefix = "${local.project}-${local.env}-${local.type_eventbridge}"

  ## Name/Prefix for Global Accelerator
  # only alphanumeric characters and hyphens are allowed
  global_accelerator_name_prefix = "${local.project}-${local.env}-${local.type_global_accelerator}"

  ## Name/Prefix for S3
  config_bucket_prefix = "${local.project}-${local.env}-${local.type_s3}"

  ## Name/Prefix for Secret Manager
  secretmanager_name_prefix = "${local.project}-${local.env}-${local.type_secretmanager}"

  ## Name/Prefix for Inspector
  inspector_name_prefix = "${local.project}-${local.env}-${local.type_inspector}"

  ## Name/Prefix for IAM User/Role/Policy
  iam_policy_prefix = "${local.project}-${local.env}-${local.type_iam_policy}"
  iam_role_prefix   = "${local.project}-${local.env}-${local.type_iam_role}"
  iam_role_user     = "${local.project}-${local.env}-${local.type_iam_user}"

  ## Name/Prefix for EC2 Launch Template
  launch_template_name_prefix = "${local.project}_${local.env}_${local.type_launch_template}"

  ## Name/Prefix for Lambda
  lambda_name_prefix = "${local.project}-${local.env}-${local.type_lambda}"

  ## Name/Prefix for ELB
  alb_ingress_name = "${local.project}-${local.env}-${local.type_alb}-ingress"

  ## Name/Prefix for AWS Config
  config_name = "${local.project}-${local.env}-${local.type_config}-main"
  ##  config_role_name = "${local.project}-${local.env}-${local.type_iam_role}-config"
  delivery_name              = "${local.project}-${local.env}-${local.type_config}-delivery"
  config_policy_name         = "${local.project}-${local.env}-${local.type_iam_policy}-config"
  config_managed_rule_prefix = "${local.project}-${local.env}-${local.type_config_managed_rule}"

  ## Name/Prefix for EIP
  eip_name_prefix = "${local.project}-${local.env}-${local.type_eip}"

  ## Name/Prefix for EKS
  # main_cluster_prefixはPoc用クラスタを取り潰した後に削除してください。 
  main_cluster_prefix      = "${local.project}-${local.env}-${local.type_eks}"
  main_cluster_name_prefix = "${local.project}_${local.env}_${local.type_eks}"

  ## Name/Prefix for elasticache 
  elasticache_name_prefix = "${local.project}-${local.env}-${local.type_elasticache}"

  ## Name/Prefix for KMS
  key_name_prefix = "${local.project}-${local.env}-${local.type_kms}"

  ## Name/Prefix for NAT Gateway
  ngw_name_prefix = "${local.project}-${local.env}-${local.type_ngw}"

  ## Name/Prefix for Route Table
  rtb_name_prefix = "${local.project}-${local.env}-${local.type_rtb}"

  ## Name/Prefix for Security Group
  sg_name_prefix = "${local.project}-${local.env}-${local.type_sg}"

  ## Name/Prefix for Subnet
  subnet_name_prefix = "${local.project}-${local.env}-${local.type_sbn}"

  ## Name/Prefix for Systems Manager
  ssm_name_prefix = "${local.project}-${local.env}-${local.type_ssm}"

  ## Name/Prefix for SNS
  sns_name_prefix = "${local.project}-${local.env}-${local.type_sns}"

  ## Name/Prefix for RDS
  rds_name_prefix = "${local.project}-${local.env}-${local.type_rds}"

  ## Name/Prefix for WAF
  waf_prefix            = "${local.project}-${local.env}-${local.type_waf}"
  bucket_prefix_for_log = "aws-waf-logs-"

  ## Name/Prefix for Redshift
  redshift_name_prefix = "${local.project}-${local.env}-${local.type_redshift}"

  ## Name/Prefix for Route53
  r53_name_prefix = "${local.project}-${local.env}-${local.type_r53}"

  ## Name/Prefix for VPC
  vpc_name_prefix = "${local.project}-${local.env}-${local.type_vpc}"

  ## Name/Prefix for VPC Endpoint
  vpce_name_prefix = "${local.project}-${local.env}-${local.type_vpce}"

  ## Name/Prefix for TGW
  tgw_name_prefix = "${local.project}-${local.env}-${local.type_tgw}"

  ## AWS Config Setting
  aws_config_iam_password_policy = templatefile("${path.module}/config-policies/iam_password_policy.tpl",
    {
      password_require_uppercase = var.password_require_uppercase ? "true" : "false"
      password_require_lowercase = var.password_require_lowercase ? "true" : "false"
      password_require_symbols   = var.password_require_symbols ? "true" : "false"
      password_require_numbers   = var.password_require_numbers ? "true" : "false"
      password_min_length        = var.password_min_length
      password_reuse_prevention  = var.password_reuse_prevention
      password_max_age           = var.password_max_age
    }
  )

  ## Name/Prefix for k8s Ingress
  ingress_name_prefix = "${local.project}-${local.env}-${local.type_ingress}"
}
