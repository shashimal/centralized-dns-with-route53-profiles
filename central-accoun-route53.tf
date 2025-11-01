resource "aws_route53profiles_profile" "central_route53_profile" {
  name = "central-route53-profile"
}

resource "aws_route53profiles_resource_association" "sqs_zone_association" {
  name         = "shared-endpoint-association"
  profile_id   = aws_route53profiles_profile.central_route53_profile.id
  resource_arn = aws_vpc_endpoint.shared_interface_endpoint.arn
}