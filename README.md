# Projet AWS EcoShop – Master 1 IPSSI

## 📌 Présentation
Ce projet a été réalisé dans le cadre du **Master 1 à l’école IPSSI**.  
Il met en place une infrastructure **3-tier AWS** via **Terraform**, comprenant :
- Un **VPC** dédié avec subnets publics et privés  
- Un **bastion host** pour l’accès SSH  
- Deux **serveurs applicatifs EC2** derrière un **ALB**  
- Une **base de données RDS MySQL** en haute disponibilité  

---

## 🚀 Déploiement de l’infrastructure

### 1. Initialisation
```bash
terraform init
````

### 2. Vérification du plan

```bash
terraform plan
```

### 3. Application du déploiement

```bash
terraform apply
```

Confirmer avec `yes`.

---

## 🧹 Suppression

Pour détruire l’infrastructure :

```bash
terraform destroy
```

---

## 👨‍🎓 Auteur

Projet réalisé dans le cadre du **Master 1 – IPSSI**
Module : *Infrastructure as Code avec Terraform*

par: Vienne Maryon & Estelle Nathan
