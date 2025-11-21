# --- ALB DAKAR MANQUANT - AJOUT ---
resource "aws_lb" "alb_dakar" {
  name               = "alb-dakar-wz"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.sg_alb.id]
  
  # Pour Wavelength, besoin de 2 subnets différents
  subnet_mapping {
    subnet_id = data.aws_subnet.public_dakar.id
  }
  
  subnet_mapping {
    subnet_id = aws_subnet.public_dakar_2.id  # Nouveau subnet
  }

  tags = {
    Name    = "alb-dakar-wavelength"
    Project = "Memoire-Cloud-Architecture"
    Region  = "dakar-wz"
  }
}

# Second subnet pour Dakar (nécessaire pour ALB)
resource "aws_subnet" "public_dakar_2" {
  vpc_id                  = data.aws_vpc.main.id
  cidr_block              = "10.0.101.0/24"
  availability_zone       = "eu-west-3b"  # Différent du premier
  map_public_ip_on_launch = true

  tags = {
    Name    = "subnet-public-dakar-wavelength-2"
    Tier    = "Public-WZ"
    Project = "Memoire-Cloud-Architecture"
  }
}

# --- AMÉLIORATION USER_DATA ---
resource "aws_launch_template" "app_template" {
  name_prefix   = "app-ec2-template-"
  image_id      = "ami-0d3c032f5934e1b41"
  instance_type = "t3.micro"
  vpc_security_group_ids = [data.aws_security_group.sg_app.id]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    # Script de démarrage professionnel
    set -e  # Arrêt sur erreur
    
    # Mise à jour système
    yum update -y -q
    yum install -y python3
    
    # Création structure applicative
    mkdir -p /var/www/html
    cat > /var/www/html/health.html << EOL
    <html>
    <body>
      <h1>Application Memoire Cloud</h1>
      <p>Health: <span style="color:green">OK</span></p>
      <p>Region: $(curl -s http://169.254.169.254/latest/meta-data/placement/region)</p>
      <p>AZ: $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</p>
    </body>
    </html>
    EOL
    
    # Démarrage service avec gestion de processus
    cd /var/www/html
    nohup python3 -m http.server 8080 > /var/log/app.log 2>&1 &
    
    # Health check immédiat
    sleep 5
    curl -f http://localhost:8080/health.html || exit 1
  EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name    = "app-instance-${var.environment}"
      Project = "Memoire-Cloud-Architecture"
      Environment = var.environment
    }
  }

  lifecycle {
    ignore_changes = [name_prefix]
    create_before_destroy = true
  }
}
