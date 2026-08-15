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
