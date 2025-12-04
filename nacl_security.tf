locals {
  cidr_public_az1       = "10.0.1.0/24"
  cidr_private_app_all  = "10.0.10.0/24"
  cidr_private_data_all = "10.0.20.0/24"
  cidr_vpc              = "10.0.0.0/16"
}

# 1. NACL Publique
resource "aws_network_acl" "public_nacl" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = [aws_subnet.public_paris_az1.id, aws_subnet.public_paris_az2.id]
  
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 443
  }
  
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = local.cidr_private_app_all 
    from_port  = 8080
    to_port    = 8080
  }
  
  egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }
  
  tags = { Name = "Public-NACL" }
}

# 2. NACL App
resource "aws_network_acl" "app_nacl" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = [
    aws_subnet.private_app_paris_az1.id, 
    aws_subnet.private_app_paris_az2.id, 
    aws_subnet.private_app_paris_az3.id
  ]
  tags = { Name = "App-NACL" }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = local.cidr_public_az1
    from_port  = 8080
    to_port    = 8080
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = local.cidr_private_data_all
    from_port  = 1024
    to_port    = 65535
  }

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = local.cidr_private_data_all
    from_port  = 5432
    to_port    = 6379
  }
}

# 3. NACL Data
resource "aws_network_acl" "data_nacl" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = [
    aws_subnet.private_data_paris_az1.id, 
    aws_subnet.private_data_paris_az2.id, 
    aws_subnet.private_data_paris_az3.id
  ]
  tags = { Name = "Data-NACL" }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = local.cidr_private_app_all
    from_port  = 5432
    to_port    = 6379
  }
}
