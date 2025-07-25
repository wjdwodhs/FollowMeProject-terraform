provider "aws" {
  region = "ap-northeast-2"
}

module "network" {
  source = "./modules/network"

  vpc_name             = "followme-vpc"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_a_cidr = "10.0.1.0/24"
  public_subnet_b_cidr = "10.0.2.0/24"
  az_a                 = "ap-northeast-2a"
  az_b                 = "ap-northeast-2c"
}

module "security" {
  source = "./modules/security"
  vpc_id = module.network.vpc_id
}

module "iam" {
  source         = "./modules/iam"
  rds_secret_arn = ""
}


module "compute" {
  source               = "./modules/compute"
  ami_id               = "ami-0daee08993156ca1a"
  instance_type        = "t2.micro"
  key_name             = "followme-key"
  ec2_sg_id            = module.security.ec2_sg_id
  iam_instance_profile = module.iam.ec2_instance_profile_name
  subnet_ids           = module.network.public_subnet_ids
  target_group_arn     = module.alb.target_group_arn
}

module "alb" {
  source              = "./modules/alb"
  vpc_id              = module.network.vpc_id
  subnet_ids          = module.network.public_subnet_ids
  alb_sg_id           = module.security.alb_sg_id
  acm_certificate_arn = var.acm_certificate_arn
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = "followme-deploy-bucket-jjo"
  environment = "dev"
}

module "codebuild" {
  source             = "./modules/codebuild"
  codebuild_role_arn = module.iam.codebuild_role_arn
  artifact_bucket    = module.s3.bucket_name
  github_repo_url    = "https://github.com/wjdwodhs/FollowMeProject.git"
}

module "codepipeline" {
  source = "./modules/codepipeline"

  pipeline_name          = "followme-pipeline"
  pipeline_role_arn      = module.iam.codepipeline_role_arn
  artifact_bucket        = module.s3.bucket_name
  connection_arn         = module.codebuild.connection_arn
  repository_id          = "wjdwodhs/FollowMeProject"
  branch                 = "main"
  codebuild_project_name = module.codebuild.project_name
  codedeploy_app_name    = module.codedeploy.app_name
  codedeploy_group_name  = module.codedeploy.deployment_group_name
}

module "codedeploy" {
  source                 = "./modules/codedeploy"
  app_name               = "followme-app"
  deployment_group_name  = "followme-deployment-group"
  service_role_arn       = module.iam.codedeploy_role_arn
  target_group_name      = module.alb.target_group_name
  autoscaling_group_name = module.autoscaling.asg_name
}

module "autoscaling" {
  source                  = "./modules/autoscaling"
  name                    = "followme-asg"
  max_size                = 2
  min_size                = 1
  desired_capacity        = 1
  subnet_ids              = module.network.public_subnet_ids
  target_group_arn        = module.alb.target_group_arn
  launch_template_id      = module.compute.launch_template_id
  launch_template_version = module.compute.launch_template_version
  instance_name_tag       = "followme-instance"
}

module "rds" {
  source               = "./modules/rds"
  identifier           = "followme-db"
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "wjdwodhs123"
  db_name              = "followme"
  port                 = 3306
  security_group_ids   = [module.security.rds_sg_id]
  subnet_ids           = module.network.public_subnet_ids
  subnet_group_name    = "followme-db-subnet-group"
  multi_az             = false
  publicly_accessible  = false
  deletion_protection  = false
  skip_final_snapshot  = true
}

module "route53" {
  source        = "./modules/route53"
  domain_name   = "followmegroupware.xyz."
  alb_dns_name  = module.alb.dns_name
  alb_zone_id   = module.alb.zone_id
}

module "monitoring" {
  source               = "./modules/monitoring"
  subnet_id            = module.network.public_subnet_a_id
  key_name             = "followme-key"
  security_group_id    = module.security.grafana_sg_id
  iam_instance_profile = module.iam.ec2_instance_profile_name
}

module "automation" {
  source           = "./modules/automation"
  lambda_role_arn  = module.iam.lambda_role_arn
  email_address    = "wjdwodhs@naver.com"
}
