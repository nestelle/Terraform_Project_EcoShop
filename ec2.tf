# Dernière AMI Amazon Linux 2
data "aws_ami" "al2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
}

# Bastion Host (t3.micro) dans un subnet public
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.al2.id
  instance_type               = "t3.micro"
  subnet_id                   = values(aws_subnet.public)[0].id
  associate_public_ip_address = true
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.sg_bastion.id]

  tags = { Name = "${var.project_name}-bastion" }
}

# Deux instances applicatives (t3.small) dans des subnets privés, AZ différentes
resource "aws_instance" "app" {
  count                       = 2
  ami                         = data.aws_ami.al2.id
  instance_type               = "t3.small"
  subnet_id                   = values(aws_subnet.private_app)[count.index].id
  associate_public_ip_address = false
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.sg_app.id]
  user_data                   = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y httpd php
    sudo systemctl enable httpd
    sudo systemctl start httpd
    sudo echo "EcoShop app OK – Server: $(hostname)" > /var/www/html/index.php
    EOF


  tags = { Name = "${var.project_name}-app-${count.index}" }
}