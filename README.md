# Harness Home Lab

> An end-to-end enterprise-style Harness Continuous Delivery (CD) home lab built on Azure Kubernetes Service (AKS).

## Objective

This repository is designed to learn **Harness CD** from the ground up using a real-world deployment workflow.

Instead of isolated examples, we will build a complete CI/CD platform that mirrors how many enterprise organizations deploy applications.

By the end of this lab, you will be able to:

* Deploy applications using Harness CD
* Understand Harness architecture
* Configure Delegates
* Create Connectors
* Manage Services and Environments
* Build deployment pipelines
* Promote releases from Dev → QA → Prod
* Troubleshoot pipeline failures
* Migrate existing Harness pipelines between environments

---

# Architecture

```text
                    GitHub
                       │
                       │
              Source Code & Manifests
                       │
                       ▼
                  Harness Platform
                       │
        ┌──────────────┼──────────────┐
        │              │              │
        ▼              ▼              ▼
 GitHub Connector  ACR Connector  Kubernetes Connector
                       │
                       ▼
                Harness Delegate
                       │
                       ▼
                     AKS Cluster
                ┌────────┼────────┐
                ▼        ▼        ▼
              dev       qa      prod
```

---

# Technology Stack

| Component          | Technology                     |
| ------------------ | ------------------------------ |
| Cloud              | Microsoft Azure                |
| Kubernetes         | Azure Kubernetes Service (AKS) |
| Container Registry | Azure Container Registry (ACR) |
| CI/CD              | Harness                        |
| Source Control     | GitHub                         |
| Application        | Python Flask                   |
| Container Runtime  | Docker                         |
| Orchestration      | Kubernetes                     |
| IaC (Future)       | Terraform                      |

---

# Azure Resources

The lab intentionally uses only the minimum Azure resources required.

| Resource       | Purpose            |
| -------------- | ------------------ |
| Resource Group | Resource container |
| AKS            | Kubernetes cluster |
| ACR            | Container registry |

No additional Azure services are deployed initially to keep the lab simple and cost-effective.

---

# Learning Roadmap

## Phase 0 — Lab Setup

* Azure Subscription
* Resource Group
* AKS
* Azure Container Registry
* GitHub Repository
* Harness Account

---

## Phase 1 — Build Sample Application

* Python Flask Application
* Dockerfile
* Health Endpoint
* Versioning

---

## Phase 2 — Containerization

* Docker Basics
* Build Images
* Run Containers
* Image Tagging

---

## Phase 3 — Azure Container Registry

* Push Images
* Pull Images
* Authentication
* Image Management

---

## Phase 4 — Kubernetes

* Deployment
* Service
* ConfigMap
* Secret
* Namespace

---

## Phase 5 — Harness Fundamentals

* Organization
* Project
* Delegate
* Delegate Selectors

---

## Phase 6 — Harness Connectors

* GitHub Connector
* Kubernetes Connector
* ACR Connector

---

## Phase 7 — Harness Services

* Kubernetes Manifest
* Artifact Source
* Runtime Variables

---

## Phase 8 — Environments

* Development
* QA
* Production

---

## Phase 9 — Infrastructure Definitions

* Cluster
* Namespace
* Deployment Target

---

## Phase 10 — First Deployment

Deploy application to:

```
AKS → dev namespace
```

---

## Phase 11 — Application Updates

* Build v1.0.1
* Push to ACR
* Deploy using Harness

---

## Phase 12 — Runtime Inputs

* Environment
* Image Tag
* Namespace

---

## Phase 13 — Variables & Expressions

Learn Harness expressions such as:

```
<+pipeline.variables.imageTag>

<+service.name>

<+env.name>
```

---

## Phase 14 — Secrets

Store and use:

* GitHub credentials
* Container registry credentials
* Application secrets

---

## Phase 15 — Templates

Convert repetitive pipeline components into reusable templates.

---

## Phase 16 — Git Experience

Store Harness YAML inside GitHub.

Learn:

* Pipeline as Code
* Version Control
* Pull Request workflow

---

## Phase 17 — Harness CI

Build Docker images using Harness.

Workflow:

```
GitHub
      │
      ▼
Harness CI
      │
      ▼
Azure Container Registry
```

---

## Phase 18 — Multi-Environment Deployment

```
Dev

↓

QA

↓

Production
```

Include approval gates before Production deployment.

---

## Phase 19 — Deployment Strategies

* Rolling Update
* Canary Deployment
* Blue/Green Deployment
* Rollback

---

## Phase 20 — Enterprise Features

* Manual Approval
* Failure Strategy
* Notifications
* Input Sets
* Pipeline Variables

---

## Phase 21 — Troubleshooting

Practice resolving common issues such as:

* Delegate Offline
* Connector Failures
* ImagePullBackOff
* CrashLoopBackOff
* Kubernetes Deployment Errors
* Manifest Errors
* Authentication Problems
* Failed Rollouts

---

## Phase 22 — Dev to Prod Pipeline Migration

Simulate a real enterprise task.

Activities include:

* Copy Existing Pipeline
* Update Connectors
* Change Environment
* Modify Variables
* Configure Production Approvals
* Validate Production Deployment

---

# Repository Structure

```
harness-home-lab/
│
├── app/
│   ├── app.py
│   ├── requirements.txt
│   ├── Dockerfile
│   └── README.md
│
├── kubernetes/
│   ├── base/
│   ├── dev/
│   ├── qa/
│   └── prod/
│
├── harness/
│   ├── connectors/
│   ├── delegates/
│   ├── services/
│   ├── environments/
│   ├── pipelines/
│   ├── templates/
│   └── input-sets/
│
├── scripts/
│   ├── create-lab.sh
│   ├── start-aks.sh
│   ├── stop-aks.sh
│   ├── validate.sh
│   └── cleanup.sh
│
└── README.md
```

---

# Expected Outcome

After completing this lab, you should be able to:

* Build containerized applications
* Push images to Azure Container Registry
* Deploy applications to AKS using Harness
* Configure Delegates and Connectors
* Create Services and Environments
* Build enterprise deployment pipelines
* Promote releases across environments
* Implement deployment strategies
* Troubleshoot Harness and Kubernetes deployments
* Confidently migrate Harness pipelines from Development to Production

---

# Target Audience

This project is intended for:

* DevOps Engineers
* DevSecOps Engineers
* Cloud Engineers
* Platform Engineers
* Site Reliability Engineers (SRE)
* Engineers preparing for enterprise Harness implementations

---

# Future Enhancements

After completing the core learning path, additional integrations may include:

* Terraform
* Helm
* SonarQube
* Trivy
* GitHub Actions
* Prometheus
* Grafana
* Policy as Code
* Security Scanning
* GitOps

---

**Goal:** Learn Harness by building and operating a realistic, enterprise-style deployment platform from source code to production deployment.
