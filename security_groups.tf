# SG-Web (pour l’ALB)
resource "aws_security_group" "sg_web" {
  name        = "${var.project_name}-sg-web"
  description = "ALB ingress 80/443 depuis Internet"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-sg-web" }
}

# SG-Bastion
resource "aws_security_group" "sg_bastion" {
  name        = "${var.project_name}-sg-bastion"
  description = "SSH depuis IP publique de l admin"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH admin"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-sg-bastion" }
}

# SG-App (instances privées)
resource "aws_security_group" "sg_app" {
  name        = "${var.project_name}-sg-app"
  description = "HTTP depuis SG-Web, SSH depuis SG-Bastion"
  vpc_id      = aws_vpc.main.id

  ingress {
    description                  = "HTTP depuis ALB"
    from_port                    = 80
    to_port                      = 80
    protocol                     = "tcp"
    security_groups              = [aws_security_group.sg_web.id]
  }

  ingress {
    description                  = "SSH depuis Bastion"
    from_port                    = 22
    to_port                      = 22
    protocol                     = "tcp"
    security_groups              = [aws_security_group.sg_bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-sg-app" }
}

# SG-DB (RDS MySQL)
resource "aws_security_group" "sg_db" {
  name        = "${var.project_name}-sg-db"
  description = "MySQL depuis SG-App"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "MySQL"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_app.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-sg-db" }
}