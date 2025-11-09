# variables.tf - Configuration flexible
variable "environment" {
  description = "Environnement de déploiement"
  type        = string
  default     = "poc"
}

variable "domain_name" {
  description = "Nom de domaine pour l'application"
  type        = string
  default     = "memoire-cloud-test.internal"
}

variable "alert_email" {
  description = "Email pour recevoir les alertes"
  type        = string
  default     = "agabdoulaye16@gmail.com"
}
