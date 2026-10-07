# Cloud DevOps Platform

A portfolio DevOps/SRE project showcasing an end-to-end CI/CD pipeline for a Spring Boot CRUD application, using Jenkins for automation, Docker for containerization, Kubernetes and Amazon EKS for deployment, Amazon ECR for storing container images, AWS and Terraform for cloud infrastructure provisioning, and Amazon RDS for PostgreSQL database storage.

## Architecture

```mermaid
flowchart TD
    Dev(["Developer"]) --> Git["GitHub Repository"]

    subgraph CICD["CI/CD Pipeline"]
        Git --> Jenkins["Jenkins"]
        Jenkins --> Build["Build & Test"]
        Build --> Docker["Package & Build Docker Image"]
        Docker --> Push["Push Image"]
    end

    subgraph AWS["Amazon Web Services"]
        ECR[("Amazon ECR")]
        subgraph EKS["Amazon EKS Cluster"]
            Deploy["Kubernetes Deployment"]
            P1["Spring Boot Pod 1"]
            P2["Spring Boot Pod 2"]
            Deploy --> P1
            Deploy --> P2
        end
        ALB["AWS Load Balancer Controller"]
        LB(["Application Load Balancer"])
        RDS[("Amazon RDS for PostgreSQL")]

        LB --> P1
        LB --> P2
        P1 --> RDS
        P2 --> RDS
        ALB -. "Manages" .-> LB
    end

    Push --> ECR
    ECR -->|"Image deployed by Jenkins"| Deploy
    LB --> Users(["Public API / Users"])

    TF["Terraform"] -. "Provisions AWS infrastructure" .-> AWS

    classDef source fill:#e8f0fe,stroke:#4285f4,color:#174ea6
    classDef pipeline fill:#fff3e0,stroke:#ef9a3c,color:#7a4100
    classDef cloud fill:#e8f5e9,stroke:#43a047,color:#1b5e20
    classDef infra fill:#f3e5f5,stroke:#8e44ad,color:#512e5f

    class Dev,Git source
    class Jenkins,Build,Docker,Push pipeline
    class ECR,Deploy,P1,P2,ALB,LB,Users cloud
    class RDS,TF infra
```

## Tech Stack

- Application: Java, Spring Boot, Maven
- CI/CD: Jenkins
- Containerization: Docker
- Cloud: AWS
- Container Registry: Amazon ECR
- Orchestration: Kubernetes, Amazon EKS
- Load Balancing: AWS Application Load Balancer
- Database: Amazon RDS for PostgreSQL
- Infrastructure as Code: Terraform

## What It Does

1. Developers push code to GitHub.
2. Jenkins builds and tests the application.
3. Maven packages the application and Docker builds the container image.
4. Jenkins pushes the image to Amazon ECR with a build-specific tag.
5. Jenkins updates the Kubernetes Deployment running on Amazon EKS.
6. Kubernetes manages two application replicas and performs health checks.
7. The AWS Load Balancer Controller exposes the application through an internet-facing ALB.
8. The Spring Boot CRUD API can then be accessed publicly.
9. The application stores and retrieves task data in a shared PostgreSQL database hosted on Amazon RDS.

## Key Features

- Automated CI/CD — Jenkins handles build, test, Docker image creation, ECR push, and EKS deployment.
- Containerized application — Multi-stage Docker build with a non-root runtime user.
- Kubernetes deployment — Application runs with two replicas on Amazon EKS.
- Health and reliability — Startup, readiness, and liveness probes are configured for the application.
- AWS integration — ECR stores application images, EKS runs the workloads, and ALB provides public access.
- Database integration — Amazon RDS for PostgreSQL stores task data shared by both application replicas.
- Database security — RDS access is restricted to the EKS node security group, with credentials managed through Kubernetes Secrets.
- Infrastructure as Code — Terraform manages the AWS infrastructure instead of relying on manual provisioning.
- Deployment verification — Jenkins verifies Kubernetes rollout completion and running pods.
- Rollback capability — Kubernetes rollout history and rollback were tested as part of the deployment workflow.
- End-to-end CRUD verification — The deployed public API was verified using real GET, POST, PUT, and DELETE requests.
