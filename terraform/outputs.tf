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
