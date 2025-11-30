resource "aws_route53profiles_profile" "service_provider_route53_profile" {
  name = "service-provider-route53-profile"
}

resource "aws_route53profiles_resource_association" "shared_interface_association" {
  name         = "shared-endpoint-association"
  profile_id   = aws_route53profiles_profile.service_provider_route53_profile.id
  resource_arn = aws_vpc_endpoint.shared_interface_endpoint.arn
}

resource "aws_route53_record" "endpoint_service_verification" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = aws_vpc_endpoint_service.shared_endpoint_service.private_dns_name_configuration[0].name
  type    = aws_vpc_endpoint_service.shared_endpoint_service.private_dns_name_configuration[0].type
  records = [aws_vpc_endpoint_service.shared_endpoint_service.private_dns_name_configuration[0].value]
  ttl     = 60
}
