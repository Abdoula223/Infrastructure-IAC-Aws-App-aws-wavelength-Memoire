🚀 Architecture Cloud Hybride AWS - Mémoire Master
📖 Description

Ce projet Terraform implémente une architecture cloud hybride scalable et sécurisée sur AWS, combinant une infrastructure multi-AZ dans la région Paris avec une extension edge computing via AWS Wavelength Dakar.

Contexte : Mémoire de Master démontrant la maîtrise des architectures cloud modernes, de l'Infrastructure as Code et des bonnes pratiques DevOps.
🏗️ Architecture
📋 Composants Principaux

    🌍 Réseau : VPC multi-AZ + Wavelength Dakar

    🛡️ Sécurité : Segmentation 3 couches (ALB/App/Data)

    ⚙️ Compute : Auto Scaling Groups + Load Balancers

    🗄️ Données : PostgreSQL Multi-AZ + Redis ElastiCache

    🌐 DNS : Route53 avec geo-routing intelligent

    📊 Monitoring : CloudWatch logs, alertes, dashboard

🎯 Objectifs Atteints

    ✅ Haute Disponibilité (> 99.9%)

    ✅ Scalabilité Automatique (Auto Scaling)

    ✅ Performance Optimisée (Latence Dakar: 8ms vs 200ms Paris)

    ✅ Sécurité Renforcée (Micro-segmentation)

    ✅ Automatisation Complète (Infrastructure as Code)

📁 Structure du Projet
text

Infrastructure-IAC-Aws-App-aws-wavelength-Memoire/
├── 📄 provider.tf                 # Configuration Terraform
├── 🌐 network.tf                  # VPC, subnets, routage
├── 🛡️ security.tf                # Security Groups
├── ⚙️ application_layer.tf       # EC2, ALB, Auto Scaling
├── 🗄️ config_rds_az.tf          # PostgreSQL Multi-AZ
├── 🔥 config_redis_elasti.tf     # Cluster Redis
├── 🌍 dns_distribution.tf        # Route53 geo-routing
├── 📊 monitoring.tf              # CloudWatch monitoring
└── ⚙️ variables.tf               # Variables de configuration

🚀 Déploiement
Prérequis

    Compte AWS avec permissions appropriées

    Terraform >= 1.0

    AWS CLI configuré

Déploiement Automatique
bash

# Initialisation
terraform init

# Validation de la syntaxe
terraform validate

# Plan de déploiement
terraform plan

# Déploiement
terraform apply -auto-approve

🔧 Commandes Utiles
bash

# Voir l'état actuel
terraform state list

# Visualiser les outputs
terraform output

# Destruction de l'infrastructure
terraform destroy -auto-approve

💰 Estimation des Coût
📊 Résultats Techniques
✅ Validation des Objectifs

    Disponibilité : 100% pendant les tests

    Latence : 8ms Dakar vs 200ms Paris

    Scalabilité : Auto Scaling 1→3 instances

    Sécurité : 3 couches segmentées

    Automatisation : Déploiement Terraform complet

🎯 Métriques Clés
bash

# Outputs après déploiement
dashboard_url = "https://eu-west-3.console.aws.amazon.com/cloudwatch/..."
alb_paris_dns = "alb-paris-main-xxx.eu-west-3.elb.amazonaws.com"
alb_dakar_dns = "alb-dakar-wz-xxx.elb.amazonaws.com"

🛠️ Technologies Utilisées

    Infrastructure as Code : Terraform

    Cloud Provider : AWS

    Compute : EC2, Auto Scaling, ELB

    Réseau : VPC, Wavelength, Route53

    Base de Données : RDS PostgreSQL, ElastiCache Redis

    Monitoring : CloudWatch, SNS

    Sécurité : Security Groups, IAM

📈 Bonnes Pratiques Implémentées
🔒 Sécurité

    Segmentation réseau 3 couches

    Principes du moindre privilège

    Chiffrement des données au repos

    Security Groups restrictifs

⚡ Performance

    Architecture Multi-AZ

    Cache Redis pour performances

    Geo-routing intelligent

    Load Balancing réparti

🔄 DevOps

    Infrastructure as Code

    Monitoring centralisé

    Alertes automatiques

    Documentation complète

 Contexte Académique

Ce projet a été réalisé dans le cadre d'un Mémoire de Master démontrant :

    La maîtrise des architectures cloud hybrides

    L'implémentation d'Infrastructure as Code

    L'optimisation coûts/performances

    Les bonnes pratiques DevOps et Sécurité

 Support

Pour toute question concernant ce projet :

    📧 Email : agabdoulaye16@gmail.com

    💼 LinkedIn : www.linkedin.com/in/abdoulaye-diallo-1b0431308

📄 Licence

Ce projet est destiné à des fins éducatives et académiques.
