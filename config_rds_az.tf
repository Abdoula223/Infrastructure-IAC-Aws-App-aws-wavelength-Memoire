# config_rds_az.tf - Configuration Base de Données PostgreSQL Multi-AZ

# Subnet Group pour RDS (distribué sur 3 AZ)
resource "aws_db_subnet_group" "main" {
  name       = "memoire-rds-subnet-group"
  subnet_ids = [
    aws_subnet.private_data_paris_az1.id,
    aws_subnet.private_data_paris_az2.id,
    aws_subnet.private_data_paris_az3.id
  ]

  tags = {
    Name = "RDS Subnet Group Multi-AZ"
  }
}

# Instance RDS PostgreSQL Multi-AZ
resource "aws_db_instance" "postgres" {
  identifier              = "memoire-postgres-multiaz"
  engine                  = "postgres"
  engine_version          = "15.4"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp3"
  storage_encrypted       = true

  # Configuration Multi-AZ pour haute disponibilité
  multi_az                = true

  db_name                 = "ecommerce_db"
  username                = "admin"
  password                = "CHANGEME" # À stocker dans AWS Secrets Manager

  # Sécurité
  vpc_security_group_ids  = [aws_security_group.sg_data.id]
  db_subnet_group_name    = aws_db_subnet_group.main.name
  publicly_accessible     = false

  # Sauvegardes automatiques
  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "Mon:04:00-Mon:05:00"

  # Protection contre suppression accidentelle
  deletion_protection     = true
  skip_final_snapshot     = false
  final_snapshot_identifier = "memoire-postgres-final-snapshot"

  tags = {
    Name = "RDS PostgreSQL Multi-AZ"
  }
}
