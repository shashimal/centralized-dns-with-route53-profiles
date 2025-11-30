locals {
  service_provider_vpc_private_route_tables = module.service_provider_account_vpc.private_route_table_ids
}

#######################################################
# Central or service provider account VPC
#######################################################
module "service_provider_account_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~>6.4"

  name = "${local.service_provider_app_name}-vpc"
  cidr = local.service_provider_vpc_cidr

  azs             = ["${local.aws_region}a", "${local.aws_region}b"]
  public_subnets  = local.service_provider_vpc_public_subnets
  private_subnets = local.service_provider_vpc_private_subnets

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_dns_hostnames = true
  enable_dns_support   = true


  tags = {
    Name = "${local.service_provider_app_name}-vpc"
  }

  private_subnet_tags = {
    Name = "private-subnet"
  }

  public_subnet_tags = {
    Name = "public-subnet"
  }
}

#######################################################
# Route traffic to consumer account via TGW
#######################################################
resource "aws_route" "service_provider_to_consumer_account_vpc_route" {
  for_each = {
    for idx, rt_id in local.service_provider_vpc_private_route_tables : idx => rt_id
  }

  route_table_id         = each.value
  destination_cidr_block = module.consumer_account_vpc.vpc_cidr_block
  transit_gateway_id     = aws_ec2_transit_gateway.service_provider_tgw.id

  depends_on = [module.service_provider_account_vpc]
}

#######################################################
# Create a VPC endpoint service with private DNS enabled
#######################################################
resource "aws_vpc_endpoint_service" "shared_endpoint_service" {
  network_load_balancer_arns = [module.nlb.arn]
  acceptance_required        = false
  private_dns_name           = local.app_domain
  supported_regions          = ["ap-southeast-1"]

  tags = {
    Name = "enpoint-service-${local.service_provider_app_name}"
  }
}


#######################################################
#We will share this endpoint with all the consumer accounts
#######################################################
resource "aws_vpc_endpoint" "shared_interface_endpoint" {
  vpc_id              = module.service_provider_account_vpc.vpc_id
  service_name        = aws_vpc_endpoint_service.shared_endpoint_service.service_name
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [module.app_sg.security_group_id]
  subnet_ids          = module.service_provider_account_vpc.private_subnets

  tags = {
    Name = "Shared interface endpoint"
  }

  depends_on = [aws_vpc_endpoint_service.shared_endpoint_service]
}
