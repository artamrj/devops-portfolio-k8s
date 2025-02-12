# DevOps Portfolio (Kubernetes & Docker)

A demonstration project showcasing how to deploy a simple, parameterized HTML page using Docker and Kubernetes. This repository illustrates best practices for containerization, environment variable management, health checks, and autoscaling with a focus on a local development workflow and a more comprehensive Kubernetes test using Minikube.

> **Note:**  
> The **Docker** deployment (Local Docker and Docker Compose) simply renders the HTML page with environment variable substitution. It does not test Kubernetes-specific features such as liveness/readiness probes or autoscaling. For a complete test of these capabilities, deploy the application on Minikube.


## Table of Contents

- [Overview](#overview)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Docker](#docker)
    - [Local Docker](#local-docker)
    - [Docker Compose](#docker-compose)
  - [Deployment on Minikube](#deployment-on-minikube)
- [Project Structure](#project-structure)
- [Further Considerations](#further-considerations)

#### Complete Process Documentation in German
- [Full Process Documentation](DOKUMENTATION.md)
- [Issues Encountered During Implementation](PROBLEMS.md)

## Overview

This project contains a simple HTML page served by an Nginx container. The content is dynamically rendered using environment variables (e.g., PAGE_NAME, NICK_NAME, etc.). In a Kubernetes environment, these variables are managed via ConfigMaps and Secrets, and the deployment uses liveness/readiness probes along with a Horizontal Pod Autoscaler (HPA) to ensure high availability and scalability.


## Getting Started

### Prerequisites

- **Git:** [Download and install Git](https://git-scm.com/)
- **Docker:** [Install Docker](https://docs.docker.com/get-docker/)
- **Minikube:** [Install Minikube](https://minikube.sigs.k8s.io/docs/start/)


### Docker

#### Local Docker

This method uses Docker to build and run the container. It is ideal for quickly viewing the HTML page with environment variable substitution but **does not** test Kubernetes-specific features.

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/artamrj/devops-portfolio-k8s.git
   cd devops-portfolio-k8s
   ```

2. **Build the Docker Image:**

   ```bash
   docker build -t devops-portfolio:v1 .
   ```

3. **Run the Container:**

   ```bash
   docker run -it --name devops-portfolio -p 8080:80 \
     -e PAGE_NAME="DevOps Portfolio" \
     -e NICK_NAME="Max" \
     -e LINKTREE_URL="https://github.com/artamrj/devops-portfolio-k8s" \
     -e NAME="Max Mustermann" \
     -e LASTNAME_PLACE="" \
     -e HEADER_IMAGE_URL="https://2cm.es/Se7b" \
     -e PROFILE_IMAGE_URL="https://2cm.es/Se9c" \
     -e PASSWORD="sud0MakeMeASandwich" \
     devops-portfolio:v1
   ```

4. **Access the Application:**  
   Open your browser and navigate to [http://localhost:8080](http://localhost:8080).

---

#### Docker Compose

Docker Compose simplifies container management by using a pre-defined configuration.

1. **Clone the Repository:**  
   (Skip if already cloned)

   ```bash
   git clone https://github.com/artamrj/devops-portfolio-k8s.git
   cd devops-portfolio-k8s
   ```

2. **Start the Application:**

   ```bash
   docker-compose up -d
   ```

   This command reads the `docker-compose.yaml` file to configure and run the container with predefined environment variables.

3. **Access the Application:**  
   Open your browser and navigate to [http://localhost:8080](http://localhost:8080).

---

### Deployment on Minikube

For a full Kubernetes test—including health probes, environment variable management through ConfigMaps/Secrets, and autoscaling—deploy the application on Minikube.

1. **Start Minikube:**

   ```bash
   minikube start
   ```

2. **(Optional) Launch the Minikube Dashboard:**

   ```bash
   minikube dashboard
   ```

3. **Deploy Kubernetes Manifests:**

   Navigate to the `k8s` directory and apply the manifests:

   ```bash
   cd k8s
   kubectl apply -f configmap.yaml
   kubectl apply -f secret.yaml
   kubectl apply -f deployment.yaml
   kubectl apply -f service.yaml
   kubectl apply -f hpa.yaml   # Optional: Enable autoscaling
   ```

4. **Verify Deployments:**

   ```bash
   kubectl get pods
   kubectl get svc
   kubectl get hpa   # Optional: Verify autoscaling
   ```

5. **Access the Service:**

   ```bash
   minikube service devops-portfolio-k8s-service
   ```

   This command opens your default web browser to the application’s NodePort.

## Project Structure

```
devops-portfolio-k8s/
├── k8s/
│   ├── configmap.yaml      # Kubernetes ConfigMap for environment variables
│   ├── deployment.yaml     # Deployment manifest with liveness & readiness probes
│   ├── hpa.yaml            # Horizontal Pod Autoscaler configuration
│   ├── secret.yaml         # Kubernetes Secret for sensitive data
│   └── service.yaml        # Service manifest (NodePort)
├── index.template.html     # HTML template with placeholders for environment variables
├── styles.css              # CSS for page styling
├── entrypoint.sh           # Entrypoint script (uses envsubst for dynamic substitution)
├── dockerfile              # Dockerfile for building the image
├── docker-compose.yaml     # Docker Compose configuration for local deployment
├── README.md               # This file (project overview)
├── DOKUMENTATION.md        # Detailed project development documentation
└── PROBLEMS.md             # Troubleshooting guide for common issues
```

## Further Considerations

- **Security:**  
  Consider implementing HTTPS, secure credential management, and secrets management best practices.

- **Monitoring:**  
  Integrate monitoring tools such as Prometheus and Grafana to gain insights into application performance and health.

- **CI/CD:**  
  Automate your build and deployment pipeline using tools like Jenkins, GitHub Actions, or GitLab CI/CD.

- **Production Readiness:**  
  For production deployments, configure namespaces, Role-Based Access Control (RBAC), and resource quotas to enhance security and stability.
