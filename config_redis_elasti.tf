# config_redis_elasti.tf - Configuration Cluster Redis ElastiCache

# Subnet Group pour ElastiCache
resource "aws_elasticache_subnet_group" "main" {
  name       = "memoire-redis-subnet-group"
  subnet_ids = [
    aws_subnet.private_data_paris_az1.id,
    aws_subnet.private_data_paris_az2.id,
    aws_subnet.private_data_paris_az3.id
  ]

  tags = {
    Name = "ElastiCache Redis Subnet Group"
  }
}

# Cluster Redis
resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "memoire-redis-cluster"
  engine               = "redis"
  engine_version       = "7.0"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  port                 = 6379

  # Sécurité
  security_group_ids   = [aws_security_group.sg_data.id]
  subnet_group_name    = aws_elasticache_subnet_group.main.name

  # Snapshots automatiques
  snapshot_retention_limit = 5
  snapshot_window          = "03:00-05:00"

  tags = {
    Name = "ElastiCache Redis"
  }
}
