# =============================================================================
# S3 — hébergement du site statique MediTrack Online
# =============================================================================
#
# Choix de sécurité : le bucket reste privé (aucun accès public direct).
# Seul CloudFront pourra lire son contenu, via un Origin Access Control (OAC).
# C'est la méthode recommandée par AWS (plus sûre qu'un bucket public classique
# avec "S3 static website hosting"), particulièrement adaptée ici vu le
# contexte RGPD/HDS de MediTrack.

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "site" {
  # Le nom d'un bucket S3 doit être unique au niveau mondial : on suffixe avec
  # l'account ID pour éviter toute collision.
  bucket = "${var.project_name}-site-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name    = "${var.project_name}-site"
    Project = var.project_name
    Env     = var.environment
  }
}

# Blocage complet des accès publics : le bucket ne sera jamais accessible
# directement, uniquement via CloudFront.
resource "aws_s3_bucket_public_access_block" "site" {
  bucket = aws_s3_bucket.site.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Chiffrement des objets stockés (au repos), bonne pratique AWS pour la
# protection des données — répond aux impératifs RGPD/HDS.
resource "aws_s3_bucket_server_side_encryption_configuration" "site" {
  bucket = aws_s3_bucket.site.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Versioning activé : permet de récupérer une version précédente d'un fichier
# en cas d'erreur de déploiement, contribue à la disponibilité du service.
resource "aws_s3_bucket_versioning" "site" {
  bucket = aws_s3_bucket.site.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Origin Access Control : c'est ce qui permettra à CloudFront (et uniquement
# CloudFront) d'aller lire les objets du bucket. Le lien avec la distribution
# CloudFront et la policy du bucket seront complétés dans le bloc CloudFront.
resource "aws_cloudfront_origin_access_control" "site" {
  name                              = "${var.project_name}-oac"
  description                       = "OAC pour le bucket du site statique MediTrack"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
