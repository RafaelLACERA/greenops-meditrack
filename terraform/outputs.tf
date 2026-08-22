output "vpc_id" {
  description = "ID du VPC créé pour le projet MediTrack"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID du sous-réseau public (où sera placée l'instance EC2)"
  value       = aws_subnet.public.id
}

output "web_security_group_id" {
  description = "ID du security group web (HTTP/HTTPS ouverts, SSH restreint)"
  value       = aws_security_group.web.id
}
