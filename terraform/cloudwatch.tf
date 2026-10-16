
# =============================================================================
# Bloc 3 — Observabilité : Dashboard CloudWatch, Topic SNS, Alarmes
# =============================================================================
#
# Les 5 métriques ci-dessous ont été choisies selon les méthodes USE/RED et les
# 4 signaux dorés (Latence, Trafic, Erreurs, Saturation) — voir la justification
# complète dans docs/Bloc3/Bloc3-notes-travail.md (Exercice 1).
#
# Note : contrairement à la console (qui ne propose dans son navigateur que les
# métriques ayant déjà publié au moins un point de donnée), Terraform permet de
# référencer HTTPCode_Target_5XX_Count directement sans bricolage JSON, même
# si elle n'a encore jamais été émise (système sain = graphique vide, normal).

locals {
  alb_dimension = { LoadBalancer = aws_lb.api.arn_suffix }
  ecs_dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.api.name
  }
  rds_dimension = { DBInstanceIdentifier = aws_db_instance.main.id }
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "MediTrack-API-Sante" # Pas d'accent : CloudWatch n'autorise que 0-9A-Za-z-_

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric", x = 0, y = 0, width = 6, height = 6
        properties = {
          title  = "ALB - Trafic (RequestCount)"
          view   = "timeSeries"
          region = var.aws_region
          period = 300
          stat   = "Sum"
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", local.alb_dimension.LoadBalancer]
          ]
        }
      },
      {
        type = "metric", x = 6, y = 0, width = 6, height = 6
        properties = {
          title  = "ALB - Erreurs (HTTPCode_Target_5XX_Count)"
          view   = "timeSeries"
          region = var.aws_region
          period = 300
          stat   = "Sum"
          metrics = [
            ["AWS/ApplicationELB", "HTTPCode_Target_5XX_Count", "LoadBalancer", local.alb_dimension.LoadBalancer]
          ]
        }
      },
      {
        type = "metric", x = 12, y = 0, width = 6, height = 6
        properties = {
          title  = "ALB - Latence (TargetResponseTime)"
          view   = "timeSeries"
          region = var.aws_region
          period = 300
          stat   = "Average"
          metrics = [
            ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", local.alb_dimension.LoadBalancer]
          ]
        }
      },
      {
        type = "metric", x = 18, y = 0, width = 6, height = 6
        properties = {
          title  = "ECS-CPUUtilization"
          view   = "timeSeries"
          region = var.aws_region
          period = 300
          stat   = "Average"
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ClusterName", local.ecs_dimensions.ClusterName, "ServiceName", local.ecs_dimensions.ServiceName]
          ]
        }
      },
      {
        type = "metric", x = 0, y = 6, width = 6, height = 6
        properties = {
          title  = "RDS-CPUUtilization"
          view   = "timeSeries"
          region = var.aws_region
          period = 300
          stat   = "Average"
          metrics = [
            ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", local.rds_dimension.DBInstanceIdentifier]
          ]
        }
      }
    ]
  })
}

# --- SNS : canal de notification des alertes critiques ---

resource "aws_sns_topic" "alerts" {
  name = "Meditrack-Alertes-Critiques"

  tags = {
    Name    = "${var.project_name}-alertes-critiques"
    Project = var.project_name
  }
}

# L'abonnement est créé automatiquement, mais reste "PendingConfirmation" tant
# que le lien reçu par e-mail n'a pas été cliqué manuellement (protection
# anti-spam AWS, impossible à automatiser via Terraform).
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# --- Alarmes CloudWatch (P1 Erreurs ALB, P2 Saturation RDS) ---

resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name          = "Alerte-ALB-5xx-Critique"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = 5

  namespace   = "AWS/ApplicationELB"
  metric_name = "HTTPCode_Target_5XX_Count"
  dimensions  = local.alb_dimension
  period      = 300
  statistic   = "Sum"

  alarm_actions = [aws_sns_topic.alerts.arn]

  tags = {
    Name    = "${var.project_name}-alerte-alb-5xx"
    Project = var.project_name
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_cpu" {
  alarm_name          = "Alerte-RDS-CPU-Haute"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = 80

  namespace   = "AWS/RDS"
  metric_name = "CPUUtilization"
  dimensions  = local.rds_dimension
  period      = 60
  statistic   = "Average"

  alarm_actions = [aws_sns_topic.alerts.arn]

  tags = {
    Name    = "${var.project_name}-alerte-rds-cpu"
    Project = var.project_name
  }
}
