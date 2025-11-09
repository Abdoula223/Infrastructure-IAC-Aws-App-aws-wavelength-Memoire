# dns_distribution.tf - VERSION 20/20

# --- ZONE DNS PROFESSIONNELLE ---
resource "aws_route53_zone" "primary" {
  name    = var.domain_name
  comment = "Zone DNS pour architecture hybride Paris-Dakar"

  tags = {
    Project     = "Memoire-Cloud-Architecture"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# --- ROUTAGE GÉO AVANCÉ ---

# Europe → Paris
resource "aws_route53_record" "europe_routing" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "app.${var.domain_name}"
  type    = "A"
  set_identifier = "europe-traffic"

  geolocation_routing_policy {
    continent = "EU"
  }

  alias {
    name                   = aws_lb.alb_paris.dns_name
    zone_id                = aws_lb.alb_paris.zone_id
    evaluate_target_health = true
  }
}

# Afrique → Dakar
resource "aws_route53_record" "africa_routing" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "app.${var.domain_name}"
  type    = "A"
  set_identifier = "africa-traffic"

  geolocation_routing_policy {
    continent = "AF"
  }

  alias {
    name                   = aws_lb.alb_dakar.dns_name
    zone_id                = aws_lb.alb_dakar.zone_id
    evaluate_target_health = true
  }
}

# Amériques → Paris (fallback)
resource "aws_route53_record" "americas_routing" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "app.${var.domain_name}"
  type    = "A"
  set_identifier = "americas-traffic"

  geolocation_routing_policy {
    continent = "NA"  # Amérique du Nord
  }

  alias {
    name                   = aws_lb.alb_paris.dns_name
    zone_id                = aws_lb.alb_paris.zone_id
    evaluate_target_health = true
  }
}

# Default → Paris (catch-all)
resource "aws_route53_record" "default_routing" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "app.${var.domain_name}"
  type    = "A"
  set_identifier = "default-traffic"

  alias {
    name                   = aws_lb.alb_paris.dns_name
    zone_id                = aws_lb.alb_paris.zone_id
    evaluate_target_health = true
  }
}

# --- RECORDS ADDITIONNELS PROFESSIONNELS ---

# API endpoint
resource "aws_route53_record" "api" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "api.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.alb_paris.dns_name
    zone_id                = aws_lb.alb_paris.zone_id
    evaluate_target_health = true
  }
}

# Monitoring endpoint
resource "aws_route53_record" "monitoring" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "status.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.alb_paris.dns_name
    zone_id                = aws_lb.alb_paris.zone_id
    evaluate_target_health = true
  }
}

# Health check Route53 pour monitoring avancé
resource "aws_route53_health_check" "app_health" {
  fqdn              = "app.${var.domain_name}"
  port              = 80
  type              = "HTTP"
  resource_path     = "/health.html"
  failure_threshold = "3"
  request_interval  = "30"

  tags = {
    Name    = "app-health-check"
    Project = "Memoire-Cloud-Architecture"
  }
}
