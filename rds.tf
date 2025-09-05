# Subnet Group RDS (privé)
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "ecoshop-db-subnet-group"
  subnet_ids = [for s in aws_subnet.private_db : s.id]
  tags       = { Name = "ecoshop-db-subnet-group" }
}

# Instance RDS MySQL Multi-AZ
resource "aws_db_instance" "mysql" {
  identifier              = "${var.project_name}-mysql"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp2"
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.sg_db.id]
  multi_az                = true
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  skip_final_snapshot     = true
  deletion_protection     = false
  publicly_accessible     = false
  auto_minor_version_upgrade = true

  tags = { Name = "${var.project_name}-rds" }
}