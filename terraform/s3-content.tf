# =============================================================================
# Déploiement du contenu du site statique — géré par Terraform (IaC)
# =============================================================================


locals {
  site_dir = "${path.module}/../site"

  # Association extension → type MIME, pour que le navigateur interprète
  # correctement chaque fichier (sans ça, tout serait servi en
  # application/octet-stream et le site s'afficherait mal).
  mime_types = {
    ".html" = "text/html"
    ".css"  = "text/css"
    ".js"   = "application/javascript"
    ".json" = "application/json"
    ".png"  = "image/png"
    ".jpg"  = "image/jpeg"
    ".jpeg" = "image/jpeg"
    ".gif"  = "image/gif"
    ".svg"  = "image/svg+xml"
    ".ico"  = "image/x-icon"
    ".webp" = "image/webp"
  }
}

resource "aws_s3_object" "site_files" {
  # Parcourt récursivement tous les fichiers de site/ (hors dossiers)
  for_each = fileset(local.site_dir, "**")

  bucket = aws_s3_bucket.site.id
  key    = each.value
  source = "${local.site_dir}/${each.value}"

  # Terraform ne remplace le fichier que si son contenu a réellement changé.
  etag = filemd5("${local.site_dir}/${each.value}")

  content_type = lookup(
    local.mime_types,
    regex("\\.[^.]+$", each.value),
    "application/octet-stream"
  )
}
