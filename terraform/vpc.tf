# =============================================================================
# VPC — réseau isolé dédié au projet MediTrack
# =============================================================================

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "${var.project_name}-vpc"
    Project = var.project_name
    Env     = var.environment
  }
}

# Sous-réseau public : c'est ici que sera placée l'instance EC2 (serveur web).
# "Public" car elle a besoin d'être joignable depuis Internet (accès HTTP/HTTPS,
# et SSH restreint pour l'administration Ansible).
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block               = var.public_subnet_cidr
  availability_zone        = var.availability_zone
  map_public_ip_on_launch  = true

  tags = {
    Name    = "${var.project_name}-subnet-public"
    Project = var.project_name
    Env     = var.environment
  }
}

# Passerelle Internet : indispensable pour que les ressources du sous-réseau
# public puissent communiquer avec l'extérieur.
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "${var.project_name}-igw"
    Project = var.project_name
  }
}

# Table de routage associée au sous-réseau public : tout le trafic sortant
# (0.0.0.0/0) est routé vers la passerelle internet.
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name    = "${var.project_name}-rt-public"
    Project = var.project_name
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security group pour l'instance EC2 : accès HTTP/HTTPS ouverts (serveur web
# public), SSH restreint à l'IP de l'administrateur (à définir via variable),
# tout le trafic sortant autorisé.
resource "aws_security_group" "web" {
  name        = "${var.project_name}-sg-web"
  description = "Autorise HTTP/HTTPS depuis Internet et SSH restreint pour l'administration"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH (administration Ansible) — restreint à l'IP admin"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_ip_cidr]
  }

  egress {
    description = "Tout le trafic sortant autorisé"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-sg-web"
    Project = var.project_name
  }
}
