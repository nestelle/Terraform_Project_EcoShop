output "vpc_id" {
  value = aws_vpc.main.id
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "app_private_ips" {
  value = [for i in aws_instance.app : i.private_ip]
}

output "rds_endpoint" {
  value = aws_db_instance.mysql.address
}

output "sg_ids" {
  value = {
    sg_web    = aws_security_group.sg_web.id
    sg_app    = aws_security_group.sg_app.id
    sg_db     = aws_security_group.sg_db.id
    sg_bastion= aws_security_group.sg_bastion.id
  }
}