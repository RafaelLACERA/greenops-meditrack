
# EC2 — instance serveur web (pour démonstration Ansible : Nginx/Apache)

# AMI Ubuntu la plus récente (26.04 LTS "Resolute Raccoon"), fournie par Canonical.
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-resolute-26.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Clé publique SSH dédiée au projet (générée localement avec ssh-keygen)
# 
resource "aws_key_pair" "deployer" {
  key_name   = "${var.project_name}-deployer-key"
  public_key = file(pathexpand(var.ssh_public_key_path))
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name               = aws_key_pair.deployer.key_name

  # Chiffrement du volume EBS racine 

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 8
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name    = "${var.project_name}-web"
    Project = var.project_name
    Env     = var.environment
  }
}

# Adresse IP publique fixe : afin d'eviter  que l'IP publique change
resource "aws_eip" "web" {
  instance = aws_instance.web.id
  domain   = "vpc"

  tags = {
    Name    = "${var.project_name}-web-eip"
    Project = var.project_name
  }
}
