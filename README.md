# Cloud DevOps Platform

A portfolio DevOps/SRE project demonstrating an end-to-end CI/CD workflow for a Spring Boot CRUD application using Jenkins, Docker, Kubernetes, AWS, and Terraform.

## Architecture

Developer
   |
   v
GitHub
   |
   v
Jenkins CI/CD
   |  Build → Test → Package
   |  Docker Build → Push → Deploy
   v
Amazon ECR
   |
   v
Amazon EKS
   |
   +-- Pod 1 → Spring Boot CRUD API
   +-- Pod 2 → Spring Boot CRUD API
   |
   v
Application Load Balancer
   |
   v
Public API / Users


## Tech Stack

- Application: Java, Spring Boot, Maven
- CI/CD: Jenkins
- Containerization: Docker
- Cloud: AWS
- Container Registry: Amazon ECR
- Orchestration: Kubernetes, Amazon EKS
- Load Balancing: AWS Application Load Balancer
- Infrastructure as Code: Terraform

## What It Does

The project automates the complete journey from source code to a publicly accessible application:
1. Developers push code to GitHub.
2. Jenkins automatically builds and tests the application.
3. Maven packages the application and Docker builds the container image.
4. Jenkins pushes the image to Amazon ECR with a build-specific tag.
5. Jenkins updates the Kubernetes Deployment running on Amazon EKS.
6. Kubernetes manages two application replicas and performs health checks.
7. The AWS Load Balancer Controller exposes the application through an internet-facing ALB.
8. The Spring Boot CRUD API can then be accessed publicly.


## Key Features

- Automated CI/CD — Jenkins handles build, test, Docker image creation, ECR push, and EKS deployment.
- Containerized application — Multi-stage Docker build with a non-root runtime user.
- Kubernetes deployment — Application runs with two replicas on Amazon EKS.
- Health and reliability — Startup, readiness, and liveness probes are configured for the application.
- AWS integration — ECR stores application images, EKS runs the workloads, and ALB provides public access.
- Infrastructure as Code — Terraform manages the AWS infrastructure instead of relying on manual provisioning.
- Deployment verification — Jenkins verifies Kubernetes rollout completion and running pods.
- Rollback capability — Kubernetes rollout history and rollback were tested as part of the deployment workflow.
- End-to-end CRUD verification — The deployed public API was verified using real GET, POST, PUT, and DELETE requests.
