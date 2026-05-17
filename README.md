# Enterprise 3-Tier GitOps Platform on AWS EKS (IaC)

![Security Scan](https://img.shields.io/badge/security-tfsec%20passed-brightgreen?style=for-the-badge&logo=terraform)
![Build Status](https://github.com/SRJM941/THREE-TIER-APP/actions/workflows/ci.yml/badge.svg)

A production-grade, highly available 3-tier architecture built on AWS using Terraform. This project demonstrates a robust pull-based GitOps CI/CD pipeline, hardened security through network isolation and AWS Shield, and scalable cloud-native principles tailored for enterprise environments.

## 🏗️ Architecture Overview
This platform utilizes a decoupled microservices approach managed by Kubernetes to ensure high availability, zero downtime deployments, and automatic scaling.

- **Frontend/Ingress:** Next.js UI exposed via AWS Application Load Balancer (ALB) with AWS Shield integration for DDoS protection.
- **Compute:** Amazon EKS (Elastic Kubernetes Service) running Node.js API and Frontend Pods across multi-AZ managed node groups.
- **Data Layer:** PostgreSQL deployed as a StatefulSet with persistent storage and internal cluster isolation.
- **Networking:** Custom VPC with public/private subnet segmentation, NAT Gateways, and AWS VPC-CNI Prefix Delegation optimized for high pod density.
- **Continuous Delivery:** ArgoCD deployed inside the cluster for automated, drift-free GitOps state reconciliation.

## 🚀 Key Features & Design Principles
- **Zero-Trust Network:** Strict Kubernetes Network Policies (`NetPol`) ensuring database pods only accept traffic from backend API pods, and backend pods only accept traffic from the frontend.
- **GitOps Workflow:** Fully automated CI/CD lifecycle using GitHub Actions and ArgoCD:
    - `CI Stage`: GitHub Actions authenticates via OIDC, builds Docker images, pushes to Amazon ECR, and automatically updates image tags in the Git repository.
    - `CD Stage`: ArgoCD detects changes in the `/gitops` directory and automatically pulls/syncs the EKS cluster state.
- **Shift-Left Security:** Automated infrastructure scanning using `tfsec` and `tflint` to catch misconfigurations before deployment.
- **State Management:** Enterprise-grade remote state locking using AWS S3 and DynamoDB to prevent concurrent pipeline conflicts and ensure atomic Terraform operations.

## 🗺️ System Architecture Diagram

```text
                          ┌─────────────────────────────────────────────┐
                          │               Internet / Users              │
                          └─────────────────────┬───────────────────────┘
                                                │
                          Direct ALB Access (k8s-threetie...elb.amazonaws.com)
                                                │
                         ┌──────────────────────▼─────────────────────────┐
                         │             AWS Cloud (ap-south-1)             │
                         │                                                │
                         │   ┌──────────────────────────────┐             │
                         │   │   VPC (10.0.0.0/16)          │             │
                         │   │                              │             │
                         │   │  Public Subnets (2 AZs)      │             │
                         │   │  ┌────────────┐ ┌──────────┐ │             │
                         │   │  │ ALB Ingress│ │ NAT GW   │ │             │
                         │   │  │(three-tier)│ │          │ │             │
                         │   │  └─────┬──────┘ └────┬─────┘ │             │
                         │   └────────┼─────────────┼───────┘             │
                         │            │             │                     │
                         │   ┌────────▼─────────────▼───────┐             │
                         │   │   Private Subnets (2 AZs)    │             │
                         │   │                              │             │
                         │   │  ┌─────────────────────────┐ │             │
                         │   │  │ EKS (three-tier-dev)    │ │             │
                         │   │  │ Node Group (t3.small)   │ │             │
                         │   │  │ ┌─────────────────────┐ │ │             │
                         │   │  │ │ ArgoCD (GitOps)     │ │ │             │
                         │   │  │ │ ALB Controller      │ │ │             │
                         │   │  │ │ Frontend (Next.js)  │ │ │             │
                         │   │  │ │ Backend (Node.js)   │ │ │             │
                         │   │  │ │ DB (PostgreSQL-0)   │ │ │             │
                         │   │  │ └─────────────────────┘ │ │             │
                         │   │  └─────────────────────────┘ │             │
                         │   └──────────────────────────────┘             │
                         │                                                │
                         │  AWS Services: ECR, IAM (OIDC), S3, DynamoDB   │
                         └────────────────────────────────────────────────┘

    ┌────────────────────────────── CI / CD ──────────────────────────────┐
    │                                                                     │
    │  GitHub Repository (SRJM941/THREE-TIER-APP)                         │
    │  ┌──────────────────────────────────────────────────────────────┐   │
    │  │ 1. Developer pushes code to 'main' branch                    │   │
    │  │ 2. GitHub Actions (ci.yml) triggers:                         │   │
    │  │     - OIDC auth to AWS IAM (Short-lived tokens)              │   │
    │  │     - Build Docker images for Frontend & Backend             │   │
    │  │     - Push images to AWS ECR (ap-south-1)                    │   │
    │  │     - Update K8s manifests in target Git directory           │   │
    │  └──────────────────────────────────────────────────────────────┘   │
    │                                                                     │
    │  GitOps Engine (ArgoCD inside three-tier-dev cluster)               │
    │  ┌──────────────────────────────────────────────────────────────┐   │
    │  │ - Monitors Git repository for manifest changes               │   │
    │  │ - Auto-syncs deployment state to 'three-tier-app' namespace  │   │
    │  └──────────────────────────────────────────────────────────────┘   │
    └─────────────────────────────────────────────────────────────────────┘
    
## 🛠️ Tech Stack
- **Infrastructure:** Terraform (v1.6+)
- **Cloud Provider:** AWS (Region: `ap-south-1`)
- **Container Orchestration:** Kubernetes (Amazon EKS)
- **CI/CD:** GitHub Actions & ArgoCD
- **Languages/Frameworks:** Next.js (Frontend), Node.js/Express (Backend), PostgreSQL (Database)

## 📋 CI/CD Pipeline Flow
1. **Linting & Security:** Automatic code validation via `tflint` and `tfsec`.
2. **Infrastructure Planning:** Dry-run via `terraform plan` to audit IaC changes.
3. **Application Build:** GitHub Actions builds multi-architecture Docker images and pushes to Amazon ECR.
4. **Manifest Update:** CI pipeline updates the `deployment.yaml` with the new image tags and commits back to the repo.
5. **Declarative Sync:** ArgoCD detects the Git commit and automatically applies the new state to the EKS cluster, bypassing manual `kubectl` interventions.
