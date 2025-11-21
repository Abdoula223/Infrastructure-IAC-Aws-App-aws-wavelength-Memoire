# monitoring.tf - VERSION PROFESSIONNELLE
# --- VARIABLES POUR FLEXIBILITÉ ---
variable "alarm_cpu_threshold" {
  description = "Seuil CPU pour les alarmes"
  type        = number
  default     = 80
}
variable "log_retention_days" {
  description = "Durée de rétention des logs"
  type        = number
  default     = 30
}
# --- CLOUDWATCH LOGS AVANCÉS ---
# Log Group Paris avec configuration avancée
resource "aws_cloudwatch_log_group" "app_logs_paris" {
  name              = "/aws/ec2/memoire-app/paris"
  retention_in_days = var.log_retention_days
  kms_key_id        = aws_kms_key.logs.arn
  tags = {
    Project     = "Memoire-Cloud-Architecture"
    Environment = var.environment
    Region      = "eu-west-3"
    Component   = "application"
  }
}
# Log Group Dakar
resource "aws_cloudwatch_log_group" "app_logs_dakar" {
  name              = "/aws/ec2/memoire-app/dakar"
  retention_in_days = var.log_retention_days
  kms_key_id        = aws_kms_key.logs.arn

  tags = {
    Project     = "Memoire-Cloud-Architecture"
    Environment = var.environment
    Region      = "dakar-wz"
    Component   = "application"
  }
}
# Log Group ALB
resource "aws_cloudwatch_log_group" "alb_logs" {
  name              = "/aws/alb/memoire-app"
  retention_in_days = var.log_retention_days
  tags = {
    Project     = "Memoire-Cloud-Architecture"
    Environment = var.environment
    Component   = "load-balancer"
  }
}
# --- ALARMES COMPLÈTES ---
# Alarme CPU Paris
resource "aws_cloudwatch_metric_alarm" "high_cpu_paris" {
  alarm_name          = "memoire-high-cpu-paris-${var.environment}"
  alarm_description   = "CPU utilization > ${var.alarm_cpu_threshold}% for Paris ASG"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = var.alarm_cpu_threshold
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg_paris.name
  }
  tags = {
    Project     = "Memoire-Cloud-Architecture"
    Environment = var.environment
    Severity    = "high"
  }
}
# Alarme CPU Dakar
resource "aws_cloudwatch_metric_alarm" "high_cpu_dakar" {
  alarm_name          = "memoire-high-cpu-dakar-${var.environment}"
  alarm_description   = "CPU utilization > ${var.alarm_cpu_threshold}% for Dakar ASG"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = var.alarm_cpu_threshold
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg_dakar.name
  }
  tags = {
    Project     = "Memoire-Cloud-Architecture"
    Environment = var.environment
    Severity    = "high"
  }
}
# Alarme mémoire (métrique custom)
resource "aws_cloudwatch_metric_alarm" "high_memory_paris" {
  alarm_name          = "memoire-high-memory-paris-${var.environment}"
  alarm_description   = "Memory utilization > 85% for Paris instances"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "CWAgent"
  period              = "300"
  statistic           = "Average"
  threshold           = 85
  alarm_actions       = [aws_sns_topic.alerts.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg_paris.name
    InstanceId           = "i-*"  # Pour toutes les instances
  }
  tags = {
    Project     = "Memoire-Cloud-Architecture"
    Environment = var.environment
    Severity    = "medium"
  }
}
# Alarme erreurs 5xx ALB
resource "aws_cloudwatch_metric_alarm" "alb_5xx_errors" {
  alarm_name          = "memoire-alb-5xx-errors-${var.environment}"
  alarm_description   = "High rate of 5xx errors from ALB"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "300"
  statistic           = "Sum"
  threshold           = 10
  alarm_actions       = [aws_sns_topic.alerts.arn]
  dimensions = {
    LoadBalancer = aws_lb.alb_paris.arn_suffix
  }
  tags = {
    Project     = "Memoire-Cloud-Architecture"
    Environment = var.environment
    Severity    = "critical"
  }
}
# --- SNS POUR NOTIFICATIONS ---
resource "aws_sns_topic" "alerts" {
  name = "memoire-alerts-${var.environment}"
  
  tags = {
    Project     = "Memoire-Cloud-Architecture"
    Environment = var.environment
  }
}
resource "aws_sns_topic_subscription" "email_alerts" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}
# --- DASHBOARD CLOUDWATCH PROFESSIONNEL ---
resource "aws_cloudwatch_dashboard" "main_dashboard" {
  dashboard_name = "Memoire-Cloud-Architecture-${var.environment}"
  dashboard_body = jsonencode({
    widgets = [
      # Header
      {
        type   = "text"
        x      = 0
        y      = 0
        width  = 24
        height = 2
        properties = {
          markdown = "# 🎓 Dashboard Mémoire Cloud - ${var.environment}\n## Architecture Hybride Paris + Dakar"
        }
      },
      # CPU Utilization
      {
        type   = "metric"
        x      = 0
        y      = 2
      }