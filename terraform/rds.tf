
# =============================================================================
# RDS PostgreSQL — base de données de l'API, jamais accessible depuis Internet
# =============================================================================

resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_b.id]

  tags = {
    Name    = "${var.project_name}-db-subnet-group"
    Project = var.project_name
  }
}

# SG-RDS : n'autorise le trafic PostgreSQL (5432) que depuis SG-ECS.
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-sg-rds"
  description = "Allow_PostgreSQL_only_from_ECS_tasks"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "PostgreSQL depuis les taches ECS uniquement"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs.id]
  }

  egress {
    description = "Tout le trafic sortant autorise"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-sg-rds"
    Project = var.project_name
  }
}

resource "aws_db_instance" "main" {
  identifier     = "${var.project_name}-db"
  engine         = "postgres"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false
  multi_az               = false

  backup_retention_period = 0
  skip_final_snapshot     = true
  deletion_protection     = false

  tags = {
    Name    = "${var.project_name}-db"
    Project = var.project_name
    Env     = var.environment
  }
}
