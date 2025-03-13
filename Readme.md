# 🚀 Provisioning Multi-Tier Java Web Application with Terraform

## 📌 Project Overview
This project provisions the entire infrastructure for a **multi-tier Java web application** using **Terraform**. With Infrastructure as Code (IaC), we ensure **consistency, scalability, and automation** in cloud resource management.

## 🎯 Why Terraform?
✅ **Infrastructure as Code (IaC)** – Manage resources efficiently using code.  
✅ **Automation & Consistency** – Avoid manual errors and ensure reproducibility.  
✅ **Scalability & Flexibility** – Easily adjust and expand infrastructure.  
✅ **Multi-Cloud Support** – Deploy on AWS, Azure, GCP, and more.  

## 🛠 Tech Stack
- **Terraform** – Infrastructure as Code
- **AWS** – Cloud provider
- **EC2** – Compute resources
- **VPC, Subnets, Security Groups** – Network management
- **IAM** – Identity and access management

## 📂 Project Structure
```
📂 /
 ├── providers.tf         # Cloud provider configuration
 ├── variables.tf         # Input variables
 ├── output.tf            # Outputs for easy access
 ├── network.tf           # VPC, Subnets, Route Tables
 ├── securitygroups.tf    # Security rules
 ├── iam.tf               # IAM roles and permissions
 ├── main.tf              # EC2 instance creation
 ├── README.md            # Project documentation
```

## 🔧 Setup Instructions

### 1️⃣ **Clone the Repository**
```bash
git clone <repo-link>
cd terraform-infra
```

### 2️⃣ **Initialize Terraform**
```bash
terraform init
```

### 3️⃣ **Plan the Deployment**
```bash
terraform plan
```

### 4️⃣ **Apply the Changes & Provision Resources**
```bash
terraform apply -auto-approve
```

### 5️⃣ **Get the Outputs**
```bash
terraform output
```

## 🚀 Next Steps
- Implement auto-scaling groups.
- Integrate with Kubernetes for containerized workloads.

## 🤝 Contributors
- **Nader Ashour**
- **Mohamed Elweza**

#DevOps #Terraform #AWS #InfrastructureAsCode #Cloud #Automation
