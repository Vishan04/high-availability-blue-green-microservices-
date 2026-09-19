High-Availability Blue-Green Microservices Deployment Platform

A DevOps-based microservices deployment platform implementing Blue-Green Deployment with automated CI/CD, containerization, Kubernetes orchestration, Infrastructure as Code, and NGINX-based traffic routing.

---

Overview

This project demonstrates a production-inspired deployment strategy for releasing new application versions with minimal service interruption.

Two isolated application environments are maintained:

- Blue — Current stable version
- Green — New version under validation

The new release is deployed to the Green environment while Blue continues serving traffic. After successful validation, traffic is switched to Green. If an issue occurs, traffic can be redirected back to Blue.

The complete workflow is automated through Jenkins, while Kubernetes infrastructure is defined using Terraform.

---

Architecture

                         Developer
                             │
                             ▼
                          GitHub
                             │
                             ▼
                          Jenkins
                             │
              ┌──────────────┼──────────────┐
              │              │              │
              ▼              ▼              ▼
          Checkout       Docker Build   Terraform Plan
              │              │              │
              └──────────────┼──────────────┘
                             │
                             ▼
                     Kubernetes Cluster
                        (Minikube)
                             │
                ┌────────────┴────────────┐
                │                         │
                ▼                         ▼
          BLUE Environment         GREEN Environment
             v1                        v2
                │                         │
                └────────────┬────────────┘
                             │
                             ▼
                      Traffic Router
                             │
                             ▼
                       NGINX Ingress
                             │
                             ▼
                           Users

---

Technology Stack

Technology| Role
Python / Flask| Microservices
Docker| Containerization
Docker Compose| Local development
Kubernetes| Container orchestration
Minikube| Local Kubernetes cluster
NGINX Ingress| Application routing
Terraform| Infrastructure as Code
Jenkins| CI/CD automation
Git| Version control
GitHub| Source code management
PowerShell| Windows automation

---

Application Architecture

The application consists of two microservices.

Frontend Service

- Flask-based application
- Runs on port "5000"
- Provides application and product endpoints
- Communicates with the Product Service

Product Service

- Flask-based backend microservice
- Runs on port "5001"
- Provides product data
- Includes a health endpoint

Service communication:

Frontend
   │
   │ HTTP
   ▼
Product Service

---

Blue-Green Deployment Strategy

Blue Environment

The Blue environment contains the currently stable application version.

Frontend       → v1
Product Service → v1

Blue continues serving traffic while the next release is prepared.

Green Environment

The Green environment contains the new application version.

Frontend       → v2
Product Service → v2

Green can be deployed and validated independently without immediately affecting the live environment.

Traffic Switch

After validation:

Before:

Users
  │
  ▼
NGINX
  │
  ▼
BLUE v1


After:

Users
  │
  ▼
NGINX
  │
  ▼
GREEN v2

Rollback

If the new version has an issue:

GREEN v2
   │
   │ Rollback
   ▼
BLUE v1

This allows the previous stable version to receive traffic again without rebuilding the application.

---

CI/CD Pipeline

Jenkins automates the deployment workflow.

GitHub
   │
   ▼
Checkout
   │
   ▼
Validate Tools
   │
   ▼
Build Docker Images
   │
   ▼
Terraform Init
   │
   ▼
Terraform Plan
   │
   ▼
Deploy Kubernetes Resources

Jenkins Pipeline Stages

1. Checkout

Retrieves the source code from the GitHub repository.

2. Validate Project

Validates the availability of:

- Docker
- kubectl
- Terraform

3. Build Docker Images

Builds the frontend and product-service container images.

4. Terraform Plan

Initializes Terraform and generates an infrastructure plan.

5. Deploy to Kubernetes

Deploys Kubernetes resources recursively:

kubectl apply -R -f kubernetes

---

Infrastructure as Code

Terraform is used to define Kubernetes infrastructure as code.

Current Terraform configuration manages core resources including:

- Blue namespace
- Green namespace
- Routing namespace
- Blue frontend deployment
- Green frontend deployment
- Blue product-service deployment
- Green product-service deployment
- Blue frontend service

Terraform workflow:

cd terraform
terraform init
terraform validate
terraform plan

This allows infrastructure configuration to be version-controlled and reproduced consistently.

---

Kubernetes Architecture

The cluster contains separate namespaces for the deployment environments and traffic routing.

Kubernetes Cluster
│
├── blue
│   ├── Frontend Deployment
│   ├── Frontend Service
│   └── Product Service
│
├── green
│   ├── Frontend Deployment
│   ├── Frontend Service
│   └── Product Service
│
└── routing
    ├── Traffic Router
    ├── NGINX Configuration
    └── Ingress

Each application deployment uses multiple replicas to improve availability.

---

NGINX Traffic Routing

NGINX is used as the traffic-routing layer between the external Ingress and the Blue/Green environments.

Client
  │
  ▼
NGINX Ingress
  │
  ▼
Traffic Router
  │
  ├──────────────► Blue
  │
  └──────────────► Green

The router can be configured to direct application traffic to either environment.

---

Docker

Each microservice has its own Docker image.

Build the frontend:

docker build -t blue-green-frontend:v2 ./frontend

Build the Product Service:

docker build -t blue-green-product-service:v2 ./product-service

For local development:

docker compose up --build

---

Project Structure

blue-green-microservices/
│
├── frontend/
│   ├── app.py
│   ├── Dockerfile
│   └── requirements.txt
│
├── product-service/
│   ├── app.py
│   ├── Dockerfile
│   └── requirements.txt
│
├── kubernetes/
│   ├── blue/
│   │   ├── frontend-deployment.yaml
│   │   └── product-service-deployment.yaml
│   │
│   ├── green/
│   │   ├── frontend-deployment.yaml
│   │   └── product-service-deployment.yaml
│   │
│   └── traffic-router/
│       ├── router.yaml
│       └── nginx.conf
│
├── terraform/
│   └── main.tf
│
├── docker-compose.yml
├── Jenkinsfile
└── README.md

---

Deployment Workflow

The complete release process is:

1. Developer updates application
              │
              ▼
2. Code pushed to GitHub
              │
              ▼
3. Jenkins pipeline starts
              │
              ▼
4. Docker images are built
              │
              ▼
5. Terraform infrastructure is validated/planned
              │
              ▼
6. Kubernetes resources are deployed
              │
              ▼
7. Green environment runs new version
              │
              ▼
8. Application is validated
              │
              ▼
9. Traffic can be switched to Green
              │
              ▼
10. Blue remains available for rollback

---

Verification Commands

Check Kubernetes pods:

kubectl get pods -A

Check deployments:

kubectl get deployments -A

Check services:

kubectl get services -A

Check Ingress:

kubectl get ingress -A

Check namespaces:

kubectl get namespaces

---

Key Features

- Blue-Green deployment architecture
- Zero/minimal-interruption release strategy
- Microservices-based application
- Docker containerization
- Kubernetes orchestration
- Multiple application replicas
- NGINX traffic routing
- Automated Jenkins CI/CD pipeline
- Terraform Infrastructure as Code
- GitHub-based version control
- Application rollback capability
- Separate Blue and Green environments
- Automated recursive Kubernetes deployment

---

Project Outcome

The project demonstrates an end-to-end DevOps workflow for deploying containerized microservices using Kubernetes.

The implementation successfully demonstrates:

Source Control
      ↓
CI/CD Automation
      ↓
Container Build
      ↓
Infrastructure as Code
      ↓
Kubernetes Deployment
      ↓
Blue-Green Release
      ↓
Traffic Switching
      ↓
Rollback

This architecture provides a practical foundation for understanding how modern DevOps teams can manage application releases while maintaining an available stable version during deployment.

---

Skills Demonstrated

DevOps:
CI/CD, deployment automation, release management

Containerization:
Docker, Docker Compose

Orchestration:
Kubernetes, Minikube

Infrastructure as Code:
Terraform

CI/CD:
Jenkins

Networking:
NGINX Ingress, Kubernetes Services

Version Control:
Git, GitHub

Programming:
Python, Flask

---

Author

 vishan Sree A

B.E. Computer Science and Engineering — 2026

Project Focus

DevOps | Kubernetes | Docker | Jenkins | Terraform | CI/CD | Microservices | Blue-Green Deployment