# DevOps Portfolio (Kubernetes & Docker)

This project is a DevOps portfolio demonstration, showcasing Kubernetes deployment and management using Docker and Minikube.

## Table of Contents
1. [Overview](#overview)
2. [Quick Start](#quick-start)
   - [Local Docker](#local-docker)
   - [Local Docker Compose](#local-docker-compose)
   - [Deployment on Minikube](#deployment-on-minikube)
3. [Project Structure](#project-structure)
4. [Further Considerations](#further-considerations)


## Overview
This repository contains a simple HTML page served by an Nginx container. The page’s content is parameterized via environment variables and, in a Kubernetes environment, managed with ConfigMaps and Secrets. The project also demonstrates the use of liveness/readiness probes and a Horizontal Pod Autoscaler (HPA) to ensure high availability and scalability.

## Quick Start

### Local Docker
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
     -e LINKTREE_URL="github.com/artamrj/devops-portfolio-k8s" \
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

### Local Docker Compose
1. **Clone the Repository:**  
   (Skip if already cloned)
   ```bash
   git clone https://github.com/your-username/devops-portfolio-k8s.git
   cd devops-portfolio-k8s
   ```
2. **Start the Application:**
   ```bash
   docker-compose up -d
   ```
   This command uses the `docker-compose.yaml` file to set up and run the container with predefined environment variables.
3. **Access the Application:**  
   Open your browser and navigate to [http://localhost:8080](http://localhost:8080).

---

### Deployment on Minikube
1. **Start Minikube:**
   ```bash
   minikube start
   ```
2. **(Optional) Launch the Minikube Dashboard:**
   ```bash
   minikube dashboard
   ```
3. **Deploy Kubernetes Manifests:**
   ```bash
   cd k8s
   kubectl apply -f configmap.yaml
   kubectl apply -f secret.yaml
   kubectl apply -f deployment.yaml
   kubectl apply -f service.yaml
   kubectl apply -f hpa.yaml   # Optional: to enable autoscaling
   ```
4. **Verify Deployments:**
   ```bash
   kubectl get pods
   kubectl get svc
   kubectl get hpa # Optional: to enable autoscaling
   ```
5. **Access the Service:**
   ```bash
   minikube service devops-portfolio-k8s-service
   ```
   This command opens your default web browser to the application’s NodePort.

---

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
├── TIMELINE.md             # Detailed project development documentation
└── PROBLEMS.md             # Troubleshooting guide for common issues
```

---

## Further Considerations
- **Security:** Implement HTTPS and secure credential management.
- **Monitoring:** Integrate tools like Prometheus and Grafana for real-time monitoring.
- **CI/CD:** Automate your build and deployment pipeline.
- **Production Readiness:** Configure namespaces, RBAC, and resource quotas for a production-grade environment.