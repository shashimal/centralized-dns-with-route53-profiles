#######################################################
# Sharing the TGW with other AWS accounts using RAM
#####################################################
resource "aws_ram_resource_share" "central_tgw_share" {
  name                      = "central-tgw-share"
  allow_external_principals = true
  tags                      = { Name = "central-tgw-share" }
}

resource "aws_ram_resource_association" "tgw_resource_association" {
  resource_share_arn = aws_ram_resource_share.central_tgw_share.arn
  resource_arn       = aws_ec2_transit_gateway.central_tgw.arn
}

resource "aws_ram_principal_association" "consumer_account_association" {
  resource_share_arn = aws_ram_resource_share.central_tgw_share.arn
  principal          = local.counsumer_account_id
}


#######################################################
# Sharing Route53 profile with other AWS accounts using RAM
#####################################################
resource "aws_ram_resource_share" "route53_profile_share" {
  name                      = "central-route53-profile-share"
  allow_external_principals = true
  tags                      = { Name = "central-route53-profile-share" }
}

resource "aws_ram_resource_association" "route53_profile_resource_association" {
  resource_share_arn = aws_ram_resource_share.route53_profile_share.arn
  resource_arn       = aws_route53profiles_profile.central_route53_profile.arn
}

resource "aws_ram_principal_association" "route53_profile__association" {
  resource_share_arn = aws_ram_resource_share.route53_profile_share.arn
  principal          = local.counsumer_account_id
}
