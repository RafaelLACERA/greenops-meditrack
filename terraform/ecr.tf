
# =============================================================================
# ECR — dépôt privé pour l'image Docker de l'API MediTrack
# =============================================================================

resource "aws_ecr_repository" "api" {
  name = "${var.project_name}-api"

  image_scanning_configuration {
    scan_on_push = false
  }

  # Permet de supprimer le dépôt même s'il contient encore des images :
  # pratique pour le cycle destroy/apply répété du Bloc 3.
  force_delete = true

  tags = {
    Name    = "${var.project_name}-api-ecr"
    Project = var.project_name
  }
}
