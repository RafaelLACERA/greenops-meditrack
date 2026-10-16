
# =============================================================================
# Réseau additionnel pour le Bloc 2 : un 2e sous-réseau public (l'ALB exige
# 2 AZ minimum) et deux sous-réseaux privés (le subnet group RDS exige aussi
# 2 AZ, même en déploiement single-AZ ; les tâches ECS y tournent aussi).
#
# Ce réseau reste géré par Terraform car le VPC du Bloc 1 l'est déjà (évite
# toute divergence entre l'état Terraform et la console). En revanche ECR,
# RDS, ECS et l'ALB eux-mêmes sont créés à la main dans la console AWS,
# comme demandé par l'énoncé du Bloc 2.
#
# Un seul NAT Gateway (pas un par AZ) : choix FinOps assumé, c'est un
# environnement de test détruit après usage, pas de la HA de production.
# =============================================================================

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_b_cidr
  availability_zone       = var.availability_zone_b
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project_name}-subnet-public-b"
    Project = var.project_name
    Env     = var.environment
  }
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_a_cidr
  availability_zone = var.availability_zone

  tags = {
    Name    = "${var.project_name}-subnet-private-a"
    Project = var.project_name
    Env     = var.environment
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_b_cidr
  availability_zone = var.availability_zone_b

  tags = {
    Name    = "${var.project_name}-subnet-private-b"
    Project = var.project_name
    Env     = var.environment
  }
}

# Adresse IP fixe du NAT Gateway.
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name    = "${var.project_name}-nat-eip"
    Project = var.project_name
  }
}

# NAT Gateway : placé dans le sous-réseau public du Bloc 1. C'est ce qui
# permet aux tâches ECS (sous-réseaux privés) de tirer l'image depuis ECR
# et d'envoyer leurs logs vers CloudWatch, sans exposer ces sous-réseaux
# directement sur Internet.
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name    = "${var.project_name}-nat"
    Project = var.project_name
  }

  depends_on = [aws_internet_gateway.main]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name    = "${var.project_name}-rt-private"
    Project = var.project_name
  }
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private.id
}
