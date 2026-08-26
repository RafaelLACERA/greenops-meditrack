# Requirements

| Name                                                                     | Version |
| ------------------------------------------------------------------------ | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.9  |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | ~> 5.0  |

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | 5.100.0 |

## Modules

No modules.

## Resources

| Name                                                                                                                                                                                  | Type        |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_cloudfront_distribution.site](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution)                                               | resource    |
| [aws_cloudfront_origin_access_control.site](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control)                             | resource    |
| [aws_eip.web](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip)                                                                                        | resource    |
| [aws_instance.web](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)                                                                              | resource    |
| [aws_internet_gateway.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway)                                                             | resource    |
| [aws_key_pair.deployer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair)                                                                         | resource    |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)                                                                     | resource    |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association)                                             | resource    |
| [aws_s3_bucket.site](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)                                                                           | resource    |
| [aws_s3_bucket_policy.site](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy)                                                             | resource    |
| [aws_s3_bucket_public_access_block.site](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block)                                   | resource    |
| [aws_s3_bucket_server_side_encryption_configuration.site](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource    |
| [aws_s3_bucket_versioning.site](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning)                                                     | resource    |
| [aws_s3_object.site_files](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object)                                                                     | resource    |
| [aws_security_group.web](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                                                                  | resource    |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                                                               | resource    |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)                                                                                       | resource    |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami)                                                                                  | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)                                                         | data source |

## Inputs

| Name                                                                                       | Description                                                                                                                                        | Type     | Default                         | Required |
| ------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------------------------------- | :------: |
| <a name="input_admin_ip_cidr"></a> [admin_ip_cidr](#input_admin_ip_cidr)                   | Adresse IP publique de l'administrateur autorisée en SSH sur l'instance EC2 (format CIDR, ex: 82.65.12.34/32). À adapter à ton IP publique réelle. | `string` | n/a                             |   yes    |
| <a name="input_availability_zone"></a> [availability_zone](#input_availability_zone)       | Zone de disponibilité utilisée pour le sous-réseau                                                                                                 | `string` | `"eu-west-3a"`                  |    no    |
| <a name="input_aws_profile"></a> [aws_profile](#input_aws_profile)                         | Profil AWS CLI dédié au projet MediTrack (créé en Q1)                                                                                              | `string` | `"meditrack"`                   |    no    |
| <a name="input_aws_region"></a> [aws_region](#input_aws_region)                            | Région AWS de déploiement (Paris, cohérent avec les impératifs RGPD/HDS)                                                                           | `string` | `"eu-west-3"`                   |    no    |
| <a name="input_environment"></a> [environment](#input_environment)                         | Environnement de déploiement (ex: prod, preprod)                                                                                                   | `string` | `"prod"`                        |    no    |
| <a name="input_project_name"></a> [project_name](#input_project_name)                      | Nom du projet, utilisé comme préfixe pour nommer les ressources                                                                                    | `string` | `"meditrack"`                   |    no    |
| <a name="input_public_subnet_cidr"></a> [public_subnet_cidr](#input_public_subnet_cidr)    | Plage d'adresses IP du sous-réseau public (où sera placée l'instance EC2)                                                                          | `string` | `"10.0.1.0/24"`                 |    no    |
| <a name="input_ssh_public_key_path"></a> [ssh_public_key_path](#input_ssh_public_key_path) | Chemin vers la clé publique SSH dédiée au projet (générée avec ssh-keygen, jamais la clé privée)                                                   | `string` | `"~/.ssh/meditrack_devops.pub"` |    no    |
| <a name="input_vpc_cidr"></a> [vpc_cidr](#input_vpc_cidr)                                  | Plage d'adresses IP du VPC                                                                                                                         | `string` | `"10.0.0.0/16"`                 |    no    |

## Outputs

| Name                                                                                                                          | Description                                                                           |
| ----------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| <a name="output_cloudfront_distribution_id"></a> [cloudfront_distribution_id](#output_cloudfront_distribution_id)             | ID de la distribution CloudFront (utile pour invalider le cache après un déploiement) |
| <a name="output_cloudfront_oac_id"></a> [cloudfront_oac_id](#output_cloudfront_oac_id)                                        | ID de l'Origin Access Control, à utiliser dans la distribution CloudFront             |
| <a name="output_cloudfront_url"></a> [cloudfront_url](#output_cloudfront_url)                                                 | URL publique du site statique MediTrack Online (livrable principal)                   |
| <a name="output_ec2_instance_id"></a> [ec2_instance_id](#output_ec2_instance_id)                                              | ID de l'instance EC2                                                                  |
| <a name="output_ec2_public_ip"></a> [ec2_public_ip](#output_ec2_public_ip)                                                    | Adresse IP publique fixe de l'instance EC2 (à utiliser dans l'inventaire Ansible)     |
| <a name="output_public_subnet_id"></a> [public_subnet_id](#output_public_subnet_id)                                           | ID du sous-réseau public (où sera placée l'instance EC2)                              |
| <a name="output_s3_bucket_arn"></a> [s3_bucket_arn](#output_s3_bucket_arn)                                                    | ARN du bucket S3 (utilisé dans la policy d'accès CloudFront)                          |
| <a name="output_s3_bucket_name"></a> [s3_bucket_name](#output_s3_bucket_name)                                                 | Nom du bucket S3 hébergeant le site statique                                          |
| <a name="output_s3_bucket_regional_domain_name"></a> [s3_bucket_regional_domain_name](#output_s3_bucket_regional_domain_name) | Nom de domaine régional du bucket (utilisé comme origine CloudFront)                  |
| <a name="output_vpc_id"></a> [vpc_id](#output_vpc_id)                                                                         | ID du VPC créé pour le projet MediTrack                                               |
| <a name="output_web_security_group_id"></a> [web_security_group_id](#output_web_security_group_id)                            | ID du security group web (HTTP/HTTPS ouverts, SSH restreint)                          |
