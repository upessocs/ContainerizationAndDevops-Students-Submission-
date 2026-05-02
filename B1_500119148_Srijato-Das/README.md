# Containerization and DevOps Lab
### University of Petroleum and Energy Studies
**School of Computer Science | Cloud Computing & Virtualization Technology**

![Git](https://img.shields.io/badge/git-%23F05033.svg?style=for-the-badge&logo=git&logoColor=white) ![GitHub](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white) ![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white) ![Jenkins](https://img.shields.io/badge/jenkins-%23D24939.svg?style=for-the-badge&logo=jenkins&logoColor=white) ![Ansible](https://img.shields.io/badge/ansible-%23EE0000.svg?style=for-the-badge&logo=ansible&logoColor=white) ![SonarQube](https://img.shields.io/badge/sonarqube-%234781eb.svg?style=for-the-badge&logo=sonarqube&logoColor=white) ![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white) ![Ubuntu](https://img.shields.io/badge/ubuntu-%23E95420.svg?style=for-the-badge&logo=ubuntu&logoColor=white)

---

## Student Profile
- **Name:** Srijato Das
- **Sap Id:** 500119148
- **Enrollment No:** R2142230488
- **Batch:** B1 CCVT
- **Subject:** Containerization and DevOps

---

## Table of Contents
1. [Laboratory Overview](#laboratory-overview)
2. [Experiment Summary Table](#experiment-summary-table)
3. [Detailed Experimental Summaries](#detailed-experimental-summaries)
    - [Exp 0: WSL Configuration](#experiment-0-windows-subsystem-for-linux-wsl2-configuration)
    - [Exp 1: Virtualization Methodologies](#experiment-1-comparative-analysis-of-virtualization-methodologies)
    - [Exp 2: Docker Primaries](#experiment-2-docker-fundamental-operations)
    - [Exp 3: Layered Architecture](#experiment-3-nginx-deployment-and-image-layer-optimization)
    - [Exp 4: Docker Essentials](#experiment-4-docker-essential-runtimes)
    - [Exp 5: Persistence & Networks](#experiment-5-persistent-storage-and-network-isolation)
    - [Exp 6: Declarative Orchestration](#experiment-6-declarative-deployment-with-docker-compose)
    - [Exp 7: CI/CD Pipelines](#experiment-7-automated-cicd-pipeline-orchestration)
    - [Exp 9: Ansible Automation](#experiment-9-infrastructure-automation-via-ansible)
    - [Exp 10: Static Code Analysis](#experiment-10-static-application-security-testing-sast)
    - [Exp 11: Docker Swarm](#experiment-11-basic-cluster-orchestration-with-docker-swarm)
    - [Exp 12: Kubernetes Orchestration](#experiment-12-advanced-orchestration-via-kubernetes)
4. [Technical Specifications](#technical-specifications)
5. [Repository Organization](#repository-organization)

---

## Laboratory Overview
This technical portfolio documents a comprehensive series of laboratory experiments focused on the architecture, deployment, and management of cloud-native infrastructure. The curriculum provides an end-to-end perspective on the DevOps lifecycle, moving from local environment virtualization to advanced cluster orchestration and automated security analysis.

---

## Experiment Summary Table

| ID | Module Title | Primary Focus | Technical Stack | Documentation |
|:---:|:---|:---|:---|:---:|
| **0** | **WSL Configuration** | Environment Setup | WSL2, Ubuntu, Git | [View](https://srijato-05.github.io/DevOps-Theory-Lab/Lab/Experiment_0-Windows_Subsystem_for_Linux_Configuration.html) |
| **1** | **Virtualization Analysis**| VMs vs. Containers | Vagrant, VirtualBox | [View](https://srijato-05.github.io/DevOps-Theory-Lab/Lab/Experiment_1-Comparison_of_Virtual_Machines_and_Containers.html) |
| **2** | **Docker Primaries** | Image Lifecycle | Docker CLI, Nginx | [View](https://srijato-05.github.io/DevOps-Theory-Lab/Lab/Experiment_2-Docker_Basic_Operations.html) |
| **3** | **Layered Architecture** | Image Optimization | Alpine, UnionFS | [View](https://srijato-05.github.io/DevOps-Theory-Lab/Lab/Experiment_3-Deploying_NGINX_Using_Different_Base_Images_and_Comparing_Image_Layers.html) |
| **4** | **Docker Essentials** | Runtime Config | Env Vars, Mapping | [View](https://srijato-05.github.io/DevOps-Theory-Lab/Lab/Experiment_4-Docker_Essentials.html) |
| **5** | **Data Persistence** | Volume Management | Docker Volumes, Bridge | [View](https://srijato-05.github.io/DevOps-Theory-Lab/Lab/Experiment_5_Docker-Volumes_Monitoring_Networks.html) |
| **6** | **Declarative Deployment** | Service Orchestration | Docker Compose, YAML | [View](https://srijato-05.github.io/DevOps-Theory-Lab/Lab/Experiment_6_Docker_Run_Comparison_Docker_Compose.html) |
| **7** | **Pipeline Automation** | CI/CD Integration | Jenkins, GitHub, Hub | [View](https://srijato-05.github.io/DevOps-Theory-Lab/Lab/Experiment_7_Jenkins_Github_Docker-Hub.html) |
| **9** | **Configuration Management**| Infrastructure as Code | Ansible, SSH, YAML | [View](https://srijato-05.github.io/DevOps-Theory-Lab/Lab/Experiment_9_Infrastructure_Automation_using_Ansible.html) |
| **10** | **Static Analysis** | Security & Quality | SonarQube, Maven | [View](https://srijato-05.github.io/DevOps-Theory-Lab/Lab/Experiment_10_SonarQube_Static_Code_Analysis.html) |
| **11** | **Cluster Management** | Swarm Orchestration | Docker Swarm, Mesh | [View](https://srijato-05.github.io/DevOps-Theory-Lab/Lab/Experiment_11_Orchestration_using_Docker_Swarm.html) |
| **12** | **Advanced Orchestration** | Kubernetes API | K8s, Pods, Services | [View](https://srijato-05.github.io/DevOps-Theory-Lab/Lab/Experiment_12_Container_Orchestration_using_Kubernetes.html) |

---

## Detailed Experimental Summaries

### Experiment 0: Windows Subsystem for Linux (WSL2) Configuration
- **Objective:** Establishment of a high-performance, POSIX-compliant virtualization layer on Windows.
- **Key Tasks:** Enabling Virtual Machine Platform, installing Ubuntu 22.04 LTS, and configuring Git for cross-platform version control.
- **Outcome:** A unified development environment bridge between Windows and Linux kernels.
- **Manual:** [Lab 0 Manual](https://srijato-05.github.io/DevOps-Theory-Lab/Lab/Experiment_0-Windows_Subsystem_for_Linux_Configuration.html)

### Experiment 1: Comparative Analysis of Virtualization Methodologies
- **Objective:** Empirical study comparing Hypervisor-based virtualization (VMs) with OS-level containerization.
- **Key Tasks:** Deploying Ubuntu via Vagrant/VirtualBox and comparing its boot-time/resource usage against Docker containers.
- **Outcome:** Deep understanding of hardware abstraction vs. kernel sharing.
- **Manual:** [Lab 1 Manual](https://srijato-05.github.io/DevOps-Theory-Lab/Lab/Experiment_1-Comparison_of_Virtual_Machines_and_Containers.html)

### Experiment 2: Docker Fundamental Operations
- **Objective:** Mastering the container lifecycle through the Docker CLI.
- **Key Tasks:** Pulling images from Docker Hub, running detached containers, and managing ephemeral container states.
- **Outcome:** Proficiency in image acquisition and container runtime management.
- **Manual:** [Lab 2 Manual](https://srijato-05.github.io/DevOps-Theory-Lab/Lab/Experiment_2-Docker_Basic_Operations.html)

### Experiment 3: NGINX Deployment and Image Layer Optimization
- **Objective:** Optimization of storage footprint through layered architecture analysis.
- **Key Tasks:** Building custom NGINX images using Ubuntu and Alpine bases to compare UnionFS layer metadata.
- **Outcome:** Implementation of lightweight, security-hardened images (Alpine reduction of ~90%).
- **Manual:** [Lab 3 Manual](https://srijato-05.github.io/DevOps-Theory-Lab/Lab/Experiment_3-Deploying_NGINX_Using_Different_Base_Images_and_Comparing_Image_Layers.html)

### Experiment 4: Docker Essential Runtimes
- **Objective:** Advanced runtime configuration and application containerization.
- **Key Tasks:** Environment variable injection, custom port mapping, and executing interactive bash sessions within containers.
- **Outcome:** Flexible deployment patterns for multi-environment application logic.
- **Manual:** [Lab 4 Manual](https://srijato-05.github.io/DevOps-Theory-Lab/Lab/Experiment_4-Docker_Essentials.html)

### Experiment 5: Persistent Storage and Network Isolation
- **Objective:** Implementing non-volatile storage and isolated inter-container networking.
- **Key Tasks:** Creating Docker Volumes for data persistence and custom bridge networks for secure service-to-service communication.
- **Outcome:** Resilient data management and hardened network boundaries.
- **Manual:** [Lab 5 Manual](https://srijato-05.github.io/DevOps-Theory-Lab/Lab/Experiment_5_Docker-Volumes_Monitoring_Networks.html)

### Experiment 6: Declarative Deployment with Docker Compose
- **Objective:** Transitioning from imperative commands to declarative multi-service stacks.
- **Key Tasks:** Orchestrating a WordPress/MySQL stack using a single `docker-compose.yml` file.
- **Outcome:** Repeatable, version-controlled multi-container infrastructure.
- **Manual:** [Lab 6 Manual](https://srijato-05.github.io/DevOps-Theory-Lab/Lab/Experiment_6_Docker_Run_Comparison_Docker_Compose.html)

### Experiment 7: Automated CI/CD Pipeline Orchestration
- **Objective:** Construction of an end-to-end automated software delivery pipeline.
- **Key Tasks:** Integrating Jenkins with GitHub webhooks to trigger automated Docker builds and pushes to Docker Hub.
- **Outcome:** Zero-touch deployment workflow from commit to production registry.
- **Manual:** [Lab 7 Manual](https://srijato-05.github.io/DevOps-Theory-Lab/Lab/Experiment_7_Jenkins_Github_Docker-Hub.html)

### Experiment 9: Infrastructure Automation via Ansible
- **Objective:** Agentless configuration management for large-scale infrastructure.
- **Key Tasks:** Distributing SSH keys and executing idempotent YAML playbooks to standardize remote server states.
- **Outcome:** Eliminating configuration drift through automated system provisioning.
- **Manual:** [Lab 9 Manual](https://srijato-05.github.io/DevOps-Theory-Lab/Lab/Experiment_9_Infrastructure_Automation_using_Ansible.html)

### Experiment 10: Static Application Security Testing (SAST)
- **Objective:** Integrating automated quality gates into the DevOps lifecycle.
- **Key Tasks:** Using SonarQube to analyze code for vulnerabilities, bugs, and technical debt.
- **Outcome:** Enhanced software reliability and security posture prior to runtime.
- **Manual:** [Lab 10 Manual](https://srijato-05.github.io/DevOps-Theory-Lab/Lab/Experiment_10_SonarQube_Static_Code_Analysis.html)

### Experiment 11: Basic Cluster Orchestration with Docker Swarm
- **Objective:** Transitioning to distributed cluster management and high availability.
- **Key Tasks:** Initializing a Swarm manager, scaling services horizontally, and implementing self-healing via health checks.
- **Outcome:** Resilient, load-balanced application delivery across multi-node clusters.
- **Manual:** [Lab 11 Manual](https://srijato-05.github.io/DevOps-Theory-Lab/Lab/Experiment_11_Orchestration_using_Docker_Swarm.html)

### Experiment 12: Advanced Orchestration via Kubernetes
- **Objective:** Leveraging the industry-standard Kubernetes API for workload management.
- **Key Tasks:** Configuration of Pods, Deployments, and NodePort Services to manage complex containerized ecosystems.
- **Outcome:** Enterprise-grade orchestration with advanced scheduling and lifecycle management.
- **Manual:** [Lab 12 Manual](https://srijato-05.github.io/DevOps-Theory-Lab/Lab/Experiment_12_Container_Orchestration_using_Kubernetes.html)

---

## Technical Specifications
- **Operating System:** Windows 11 Enterprise / Ubuntu 22.04 LTS (WSL2)
- **Container Engine:** Docker v24.0.7
- **IaC Tool:** Ansible v2.10.8
- **CI/CD Platform:** Jenkins LTS
- **Security Analysis:** SonarQube Community Edition
- **Orchestration:** Kubernetes v1.29.0 / Docker Swarm

---

## Repository Organization
- **[/Lab](./Lab):** Technical documentation and experimental procedures.
- **[/Asset](./Asset):** Empirical evidence, diagrams, and terminal logs.
- **[/Project_Assignment](./Project_Assignment):** Specialized network and security implementations.
- **[PDF Generation Guide](./Lab/Appendix_PDF_Generation_Guide.md):** Manual for converting the portfolio to a submission-ready PDF.
