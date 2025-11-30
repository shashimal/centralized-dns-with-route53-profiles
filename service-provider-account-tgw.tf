#######################################################
# Central TGW for cross-account VPC connectivity
######################################################
resource "aws_ec2_transit_gateway" "service_provider_tgw" {
  description = "Central TGW for cross-account VPC connectivity"

  default_route_table_association = "enable"
  default_route_table_propagation = "enable"

  tags = {
    Name = "main-cross-account-tgw"
  }
}

#######################################################
# TGW attachment with central account VPC
######################################################
resource "aws_ec2_transit_gateway_vpc_attachment" "service_provider_vpc_attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.service_provider_tgw.id
  vpc_id             = module.service_provider_account_vpc.vpc_id
  subnet_ids         = module.service_provider_account_vpc.private_subnets

  tags = {
    Name = "service-provider-vpc-attachment-request"
  }
}

#######################################################
# Accept TGW attachment with consumer account VPC
######################################################
resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "consumer_account_vpc_attachment_accepter" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.consumer_account_vpc_attachment.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.consumer_account_vpc_attachment
  ]
}