# GreenOps Solutions — Projet MediTrack Cloud Deployment

Étude de cas Bachelor Administrateur Système DevOps (Niveau 6) — Bloc de compétences
"Automatiser le déploiement d'une infrastructure dans le cloud".

## Contexte

MediTrack, PME du secteur médical, souhaite automatiser le déploiement de son site
vitrine **MediTrack Online** sur AWS, avec une infrastructure fiable, sécurisée et
conforme RGPD/HDS.

## Architecture

- **VPC** sécurisé avec sous-réseau dédié
- **S3** : hébergement du site statique
- **CloudFront** : distribution du contenu (HTTPS)
- **EC2** (optionnelle) : serveur web léger (Nginx/Apache) pour démontrer
  l'automatisation Ansible

Architecture minimaliste : pas de base de données, pas de pipeline CI/CD complexe.

## Structure du repo

```
site/         # site statique MediTrack Online (HTML/CSS)
terraform/    # provisionnement de l'infra AWS (VPC, S3, CloudFront, EC2)
ansible/      # configuration du serveur EC2 (install web server, sécurité, déploiement fichiers)
docs/         # comptes-rendus et rapport final
```

## Déploiement

```bash
# 1. Provisionner l'infrastructure
cd terraform
terraform init
terraform plan
terraform apply

# 2. Configurer le serveur et déployer le site (si EC2 utilisée)
cd ../ansible
ansible-playbook -i inventory.ini playbook.yml
```

L'URL publique du site est disponible dans les outputs Terraform (`terraform output cloudfront_url`).

## Sécurité

- Utilisateur IAM dédié, politique de moindre privilège
- Chiffrement des volumes EBS
- HTTPS via CloudFront
- Firewall (UFW) et gestion des utilisateurs sur l'instance EC2

## Auteur

Rafael — GreenOps Solutions
