variable "aws_region" {
  description = "Région AWS de déploiement (Paris, cohérent avec les impératifs RGPD/HDS)"
  type        = string
  default     = "eu-west-3"
}

variable "aws_profile" {
  description = "Profil AWS CLI dédié au projet MediTrack (créé en Q1)"
  type        = string
  default     = "meditrack"
}

variable "project_name" {
  description = "Nom du projet, utilisé comme préfixe pour nommer les ressources"
  type        = string
  default     = "meditrack"
}

variable "environment" {
  description = "Environnement de déploiement (ex: prod, preprod)"
  type        = string
  default     = "prod"
}

variable "vpc_cidr" {
  description = "Plage d'adresses IP du VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Plage d'adresses IP du sous-réseau public (où sera placée l'instance EC2)"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Zone de disponibilité utilisée pour le sous-réseau"
  type        = string
  default     = "eu-west-3a"
}

variable "admin_ip_cidr" {
  description = "Adresse IP publique de l'administrateur autorisée en SSH sur l'instance EC2 (format CIDR, ex: 82.65.12.34/32). À adapter à ton IP publique réelle."
  type        = string
}

variable "ssh_public_key_path" {
  description = "Chemin vers la clé publique SSH dédiée au projet (générée avec ssh-keygen, jamais la clé privée)"
  type        = string
  default     = "~/.ssh/meditrack_devops.pub"
}

# =============================================================================
# Bloc 2 — réseau privé (RDS, ECS créés à la main dans la console ensuite)
# =============================================================================

variable "availability_zone_b" {
  description = "2e zone de disponibilité, requise par l'ALB (2 AZ minimum) et le subnet group RDS"
  type        = string
  default     = "eu-west-3b"
}

variable "public_subnet_b_cidr" {
  description = "Plage d'adresses IP du 2e sous-réseau public (pour l'ALB)"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_a_cidr" {
  description = "Plage d'adresses IP du sous-réseau privé en AZ a (RDS, tâches ECS)"
  type        = string
  default     = "10.0.11.0/24"
}

variable "private_subnet_b_cidr" {
  description = "Plage d'adresses IP du sous-réseau privé en AZ b (RDS, tâches ECS)"
  type        = string
  default     = "10.0.12.0/24"
}

# =============================================================================
# Bloc 3 — ECR, RDS, ECS, ALB (géré en Terraform cette fois : infra jetable,
# recréée/détruite plusieurs fois pendant le Bloc 3)
# =============================================================================

variable "db_name" {
  description = "Nom de la base de données PostgreSQL de l'API"
  type        = string
  default     = "meditrack"
}

variable "db_username" {
  description = "Utilisateur applicatif de la base de données PostgreSQL"
  type        = string
  default     = "meditrack_admin"
}

variable "db_password" {
  description = "Mot de passe de la base de données PostgreSQL (à définir dans terraform.tfvars, jamais commité)"
  type        = string
  sensitive   = true
}

variable "api_image_tag" {
  description = "Tag de l'image Docker de l'API à déployer"
  type        = string
  default     = "latest"
}
