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

output "s3_bucket_name" {
  description = "Nom du bucket S3 hébergeant le site statique"
  value       = aws_s3_bucket.site.bucket
}

output "s3_bucket_arn" {
  description = "ARN du bucket S3 (utilisé dans la policy d'accès CloudFront)"
  value       = aws_s3_bucket.site.arn
}

output "s3_bucket_regional_domain_name" {
  description = "Nom de domaine régional du bucket (utilisé comme origine CloudFront)"
  value       = aws_s3_bucket.site.bucket_regional_domain_name
}

output "cloudfront_oac_id" {
  description = "ID de l'Origin Access Control, à utiliser dans la distribution CloudFront"
  value       = aws_cloudfront_origin_access_control.site.id
}

output "cloudfront_url" {
  description = "URL publique du site statique MediTrack Online (livrable principal)"
  value       = "https://${aws_cloudfront_distribution.site.domain_name}"
}

output "cloudfront_distribution_id" {
  description = "ID de la distribution CloudFront (utile pour invalider le cache après un déploiement)"
  value       = aws_cloudfront_distribution.site.id
}

output "ec2_public_ip" {
  description = "Adresse IP publique fixe de l'instance EC2 (à utiliser dans l'inventaire Ansible)"
  value       = aws_eip.web.public_ip
}

output "ec2_instance_id" {
  description = "ID de l'instance EC2"
  value       = aws_instance.web.id
}

# --- Bloc 2 : réseau (pour retrouver rapidement les IDs dans la console) ---

output "public_subnet_b_id" {
  description = "ID du 2e sous-réseau public (pour l'ALB)"
  value       = aws_subnet.public_b.id
}

output "private_subnet_a_id" {
  description = "ID du sous-réseau privé AZ a (RDS, ECS)"
  value       = aws_subnet.private_a.id
}

output "private_subnet_b_id" {
  description = "ID du sous-réseau privé AZ b (RDS, ECS)"
  value       = aws_subnet.private_b.id
}

output "nat_gateway_id" {
  description = "ID du NAT Gateway"
  value       = aws_nat_gateway.main.id
}

# --- Bloc 3 : ECR / RDS / ECS / ALB ---

output "ecr_repository_url" {
  description = "URL du dépôt ECR"
  value       = aws_ecr_repository.api.repository_url
}

output "rds_address" {
  description = "Adresse (hôte seul) de l'instance RDS"
  value       = aws_db_instance.main.address
}

output "alb_dns_name" {
  description = "Nom DNS public de l'ALB"
  value       = aws_lb.api.dns_name
}

output "ecs_cluster_name" {
  description = "Nom du cluster ECS"
  value       = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  description = "Nom du service ECS"
  value       = aws_ecs_service.api.name
}

# --- Bloc 3 : Observabilité ---

output "sns_topic_arn" {
  description = "ARN du Topic SNS des alertes critiques"
  value       = aws_sns_topic.alerts.arn
}

output "cloudwatch_dashboard_url" {
  description = "URL directe du tableau de bord CloudWatch"
  value       = "https://${var.aws_region}.console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#dashboards:name=${aws_cloudwatch_dashboard.main.dashboard_name}"
}
