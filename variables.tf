variable "project_name" {
  type        = string
  default     = "ecoshop"
  description = "Nom du projet (tags & noms de ressources)"
}

variable "environment" {
  type        = string
  default     = "prod"
  description = "Environnement (prod/stage/dev)"
}

variable "aws_region" {
  type        = string
  default     = "eu-west-3" # Paris
  description = "Région AWS"
}

variable "azs" {
  type        = list(string)
  default     = ["eu-west-3a", "eu-west-3b"]
  description = "Deux zones de disponibilité"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR du VPC"
}

variable "key_name" {
  type        = string
  description = "Nom de la paire de clés EC2 existante et télécharger localement"
}

variable "my_ip" {
  type        = string
  description = "Votre IP publique (sans /32). Ex: 1.2.3.4"
}

variable "db_username" {
  type        = string
  default     = "admin"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Mot de passe RDS MySQL (exigé)"
}

variable "db_name" {
  type        = string
  default     = "ecoshop"
}
