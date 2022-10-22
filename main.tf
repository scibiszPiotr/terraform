
module "subnets" {
  source = "./modules/subnets"

  vpc_cidr = "10.0.0.0/16"
  OWNER = var.OWNER
  AWS_REGION = var.AWS_REGION
}

module "iam" {
  source = "./modules/iam"
}

module "security-group" {
  source = "./modules/security-groups"

  vpc_id = module.subnets.vpc_id
}


module "rds" {
  source = "./modules/rds"

  vpc_id = module.subnets.vpc_id
  sg_mysql = module.security-group.SG-allow-MySQL-id
  networks = module.subnets.private_subnets
}

module "alb" {
  source = "./modules/alb"

  public_subnets = module.subnets.public_subnets
  private_subnets = module.subnets.private_subnets
  vpc_id = module.subnets.vpc_id
  sg_http_id = module.security-group.SG-allow-HTTP-id
}

module "ecs" {
  source = "./modules/ecs"

  vpc_id = module.subnets.vpc_id
  public_subnets = module.subnets.public_subnets
  private_subnets = module.subnets.private_subnets
  sg_http_id = module.security-group.SG-allow-HTTP-id
  sg_mysql_id = module.security-group.SG-allow-MySQL-id
  tg = module.alb.tg

  rds_address = module.rds.address
  rds_password = module.rds.password
  alb_dns_name = module.alb.alb_dns_name

  pscibiszEcsTaskExecutionRole-arn = module.iam.pscibiszEcsTaskExecutionRole-arn
  pscibiszRoleNameTaskDb-arn = module.iam.pscibiszRoleNameTaskDb-arn
  pscibiszRoleNameTaskS3-arn = module.iam.pscibiszRoleNameTaskS3-arn

  APP_DB_TAG = var.APP_DB_TAG
  APP_S3_TAG = var.APP_S3_TAG
}
