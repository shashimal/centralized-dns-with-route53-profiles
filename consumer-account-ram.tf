#Accepting the RAM TGW resource share in consumer account
resource "aws_ram_resource_share_accepter" "tgw_accepter_consumer_account" {
  provider  = "aws.consumer-account"
  share_arn = aws_ram_resource_share.central_tgw_share.arn
  depends_on = [
    aws_ram_principal_association.consumer_account_association
  ]
}

resource "aws_ram_resource_share_accepter" "route53_profile_accepter_consumer_account" {
  provider  = "aws.consumer-account"
  share_arn = aws_ram_resource_share.route53_profile_share.arn
  depends_on = [
    aws_ram_principal_association.route53_profile__association
  ]
}


resource "aws_route53profiles_association" "ass" {
  provider    = "aws.consumer-account"
  name        = "consumer-vpc"
  profile_id  = aws_route53profiles_profile.central_route53_profile.id
  resource_id = module.consumer_account_vpc.vpc_id
}