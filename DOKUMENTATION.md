# Dokumentation: Kubernetes-Projekt

## Inhaltsverzeichnis
1. [Einleitung](#einleitung)
2. [Grundlegende Einrichtung](#grundlegende-einrichtung)  
   2.1. [Minikube installieren](#21-minikube-installieren)  
   2.2. [Minikube starten](#22-minikube-starten)  
3. [Erstes Testprojekt mit Docker und Kubernetes](#erstes-testprojekt-mit-docker-und-kubernetes)  
   3.1. [Einfaches HTML und Dockerfile](#31-einfaches-html-und-dockerfile)  
   3.2. [Docker-Image bauen und pushen](#32-docker-image-bauen-und-pushen)  
   3.3. [Deployment und Service in Kubernetes](#33-deployment-und-service-in-kubernetes)  
   3.4. [Test über Minikube](#34-test-über-minikube)  
4. [Projekt: devops-portfolio-k8s](#projekt-devops-portfolio-k8s)  
   4.1. [GitHub-Repository und Grundstruktur](#41-github-repository-und-grundstruktur)  
   4.2. [Docker-Image bauen und pushen](#42-docker-image-bauen-und-pushen)  
   4.3. [Konfiguration mittels Template und Einstiegsskript](#43-konfiguration-mittels-template-und-einstiegsskript)  
   4.4. [Kubernetes-Deployment und Service](#44-kubernetes-deployment-und-service)  
   4.5. [ConfigMap und Secret](#45-configmap-und-secret)  
   4.6. [Liveness & Readiness Probes](#46-liveness--readiness-probes)  
   4.7. [Horizontal Pod Autoscaler (HPA)](#47-horizontal-pod-autoscaler-hpa)  
5. [Zusammenfassung](#zusammenfassung)

## Einleitung
In diesem Dokument beschreibe ich meinen Workflow bei der Umsetzung eines Kubernetes-Projekts. Dabei dokumentiere ich ausschließlich die durchgeführten Schritte sowie die dazugehörigen Befehle.

## Grundlegende Einrichtung

### 2.1 Minikube installieren
Um lokal ein Kubernetes-Cluster nutzen zu können, habe ich Minikube auf meinem Mac mit Homebrew installiert:

```bash
brew install minikube
```

### 2.2 Minikube starten
Danach habe ich den Minikube-Cluster gestartet:

```bash
minikube start
```


## Erstes Testprojekt mit Docker und Kubernetes
*(Das ist nur ein Test für mich selbst, um das Konzept von Docker Hub und Minikube zu verstehen und zu testen.)*

### 3.1 Einfaches HTML und Dockerfile
Um mich mit dem Ablauf vertraut zu machen, habe ich zunächst ein simples HTML-Projekt erstellt und ein Docker-Image mit NGINX als Basis gebaut. Die wichtigsten Schritte:

1. **Index.html** mit einfachem Inhalt erstellen.  
2. **Dockerfile** anlegen, das auf `nginx:alpine` basiert, die eigene HTML-Seite kopiert und Port 80 freigibt.

### 3.2 Docker-Image bauen und pushen
Anschließend habe ich das Docker-Image lokal gebaut und in mein Docker-Hub-Repository hochgeladen:

```bash
docker build -t <mein-dockerhub-nutzername>/<mein-image>:<tag> .
docker push <mein-dockerhub-nutzername>/<mein-image>:<tag>
```

### 3.3 Deployment und Service in Kubernetes
Um dieses einfache Image in Minikube zu testen, habe ich ein Deployment und einen Service erstellt:

1. **Deployment.yaml**: Enthält das Deployment (z. B. 1 Replica, Container-Port 80, Image-Name etc.).  
2. **Service.yaml**: Definiert den NodePort-Service, um über den Minikube-Cluster auf das Deployment zugreifen zu können.

Diese habe ich angewendet mit:

```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

### 3.4 Test über Minikube
Schließlich wurde das einfache Webprojekt über den NodePort abgerufen:

```bash
minikube service <service-name>
```

## Projekt: devops-portfolio-k8s
Nach dem erfolgreichen Test habe ich mein eigentliches Projekt namens **"devops-portfolio-k8s"** aufgesetzt. Ziel war es, eine kleine Webanwendung (HTML/CSS/Bootstrap) zu erstellen, die mit NGINX ausgeliefert wird, und darauf aufbauend Kubernetes-Funktionen (ConfigMaps, Secrets, Probes, HPA) zu demonstrieren.

### 4.1 GitHub-Repository und Grundstruktur
- Ein neues Repository namens `devops-portfolio-k8s` auf GitHub erstellt.
- **index.html** "**HTML & CSS:** Eine kreative einseitige HTML-Seite mit Bootstrap wurde entwickelt, um den Bewerbungsprozess darzustellen." (später `index.template.html`) sowie **styles.css** initialisiert.
- Ein **Dockerfile** geschrieben, das auf `nginx:alpine` basiert.

### 4.2 Docker-Image bauen und pushen
Ähnlich wie beim Testprojekt wurde das Image lokal gebaut und in Docker Hub hochgeladen:

```bash
docker build -t <mein-dockerhub-nutzername>/devops-portfolio-k8s:latest .
docker push <mein-dockerhub-nutzername>/devops-portfolio-k8s:latest
```

### 4.3 Konfiguration mittels Template und Einstiegsskript
Um das HTML dynamisch mit Variablen (z. B. Benutzername, Passwort etc.) zu befüllen, habe ich Folgendes realisiert:

- **index.template.html**: Platzhalter (`${VARIABLE}`) für dynamische Daten.
- **entrypoint.sh**: Shell-Skript, das mittels `envsubst` den Template-Inhalt in eine final nutzbare `index.html` überführt. Anschließend startet es NGINX im Vordergrund:

  ```bash
  #!/bin/sh
  envsubst < /usr/share/nginx/html/index.template.html > /usr/share/nginx/html/index.html
  exec nginx -g 'daemon off;'
  ```

- Ergänzung des Dockerfiles, um das Skript ausführbar zu machen und als Entrypoint zu nutzen:

  ```dockerfile
  COPY entrypoint.sh /entrypoint.sh
  RUN chmod +x /entrypoint.sh
  ENTRYPOINT ["/entrypoint.sh"]
  ```

### 4.4 Kubernetes-Deployment und Service
1. **deployment.yaml**:  
   - Verwendung des Images `artaa/devops-portfolio-k8s:latest`.  
   - Definition von Ressourcenanforderungen und Limits.  
   - Einbindung von ConfigMap und Secret (siehe unten).  
   - Einbau von Liveness- und Readiness-Probes.  

2. **service.yaml**:  
   - Ein NodePort-Service, der den Containerport 80 nach außen verfügbar macht.

Anwendung in Minikube mittels:

```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

### 4.5 ConfigMap und Secret
- **configmap.yaml**:  
  - Enthält Variablen wie `PAGE_NAME`, `NICK_NAME`, `LINKTREE_URL` usw.  
  - Wird im Deployment unter `envFrom` eingebunden.

- **secret.yaml**:  
  - Enthält beispielsweise die Variable `PASSWORD` Base64-kodiert.  
  - Ebenfalls im Deployment unter `envFrom` referenziert.

Deployment aktualisieren:

```bash
kubectl apply -f configmap.yaml
kubectl apply -f secret.yaml
kubectl apply -f deployment.yaml
```

### 4.6 Liveness & Readiness Probes
Um sicherzustellen, dass der Container fehlerfrei läuft und bereit ist, Traffic zu empfangen, wurden Health Checks konfiguriert.

Im Deployment wurden zwei Liveness & Readiness Probes konfiguriert:

```yaml
livenessProbe:
  httpGet:
    path: /
    port: 80
  initialDelaySeconds: 10
  periodSeconds: 15
  timeoutSeconds: 2

readinessProbe:
  httpGet:
    path: /
    port: 80
  initialDelaySeconds: 5
  periodSeconds: 5
  timeoutSeconds: 1
```

Diese Probes stellen sicher, dass der Container einerseits am Laufen ist und andererseits bereit ist, Traffic zu empfangen.

Anwendung in Minikube mittels:

```bash
kubectl apply -f deployment.yaml
```

**Testen der Probes:**

- Um den Fehlerzustand zu simulieren:
  
  ```bash
  kubectl exec -it <pod-name> -- pkill nginx
  ```

- Anschließend kann der Zustand mit `kubectl describe pod <pod-name>` und `kubectl logs <pod-name>` überprüft werden.

**Beispielausgabe der Logs:**
Und ich könnte außerdem Folgendes tun:

```bash
kubectl logs <pod-name>
#oder
kubectl describe pod <pod-name> 
```



```
node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type     Reason     Age                    From               Message
  ----     ------     ----                   ----               -------
  Normal   Scheduled  6m34s                  default-scheduler  Successfully assigned default/devops-portfolio-k8s-5465797d9f-cr8lq to minikube
  Normal   Pulled     6m32s                  kubelet            Successfully pulled image "artaa/devops-portfolio-k8s:latest" in 1.107s (1.107s including waiting). Image size: 49374704 bytes.
  Normal   Pulled     5m51s                  kubelet            Successfully pulled image "artaa/devops-portfolio-k8s:latest" in 1.176s (1.176s including waiting). Image size: 49374704 bytes.
  Normal   Pulled     4m48s                  kubelet            Successfully pulled image "artaa/devops-portfolio-k8s:latest" in 1.102s (1.102s including waiting). Image size: 49374704 bytes.
  Warning  Unhealthy  2m51s                  kubelet            Readiness probe failed: Get "http://10.244.0.35:80/": dial tcp 10.244.0.35:80: connect: connection refused
  Warning  BackOff    2m33s (x6 over 5m2s)   kubelet            Back-off restarting failed container devops-portfolio-k8s in pod devops-portfolio-k8s-5465797d9f-cr8lq_default(3f0222e4-76f5-4429-a9e4-877c9f60017b)
  Normal   Pulling    2m21s (x4 over 6m33s)  kubelet            Pulling image "artaa/devops-portfolio-k8s:latest"
  Normal   Created    2m20s (x4 over 6m32s)  kubelet            Created container: devops-portfolio-k8s
  Normal   Pulled     2m20s                  kubelet            Successfully pulled image "artaa/devops-portfolio-k8s:latest" in 1.181s (1.181s including waiting). Image size: 49374704 bytes.
  Normal   Started    2m19s (x4 over 6m31s)  kubelet            Started container devops-portfolio-k8s
...
```

### 4.7 Horizontal Pod Autoscaler (HPA)
Der nächste Schritt war die Skalierung der Anwendung mit Kubernetes Horizontal Pod Autoscaler (HPA).

Um die Skalierbarkeit zu demonstrieren, habe ich einen **HorizontalPodAutoscaler** konfiguriert:

- **hpa.yaml**:  
  - `minReplicas: 1`, `maxReplicas: 5`, Zielwert für CPU-Auslastung (`averageUtilization`) auf `20%` gesetzt.

Anwenden durch:

```bash
kubectl apply -f hpa.yaml
```

**Test der Skalierung**

Mit folgendem Befehl wurden die HPA-Metriken überwacht:

```bash
kubectl get hpa --watch
```

Zusammenfassend konnte durch die Simulation hoher Last (z. B. mit Apache Benchmark) getestet werden, ob die Anwendung korrekt skaliert:

```bash
ab -n 10000 -c 100 http://127.0.0.1:<NodePort>/
```

**Beispielhafte Änderungen während des Tests:**

```
NAME                       REFERENCE                         NAME                       REFERENCE                         TARGETS       MINPODS   MAXPODS   REPLICAS   AGE
devops-portfolio-k8s-hpa   Deployment/devops-portfolio-k8s   cpu: 5%/20%   1         5         1          25m
devops-portfolio-k8s-hpa   Deployment/devops-portfolio-k8s   cpu: 95%/20%   1         5         1          26m
devops-portfolio-k8s-hpa   Deployment/devops-portfolio-k8s   cpu: 95%/20%   1         5         4          26m
devops-portfolio-k8s-hpa   Deployment/devops-portfolio-k8s   cpu: 95%/20%   1         5         5          26m
devops-portfolio-k8s-hpa   Deployment/devops-portfolio-k8s   cpu: 50%/20%   1         5         5          27m
devops-portfolio-k8s-hpa   Deployment/devops-portfolio-k8s   cpu: 5%/20%    1         5         5          28m
devops-portfolio-k8s-hpa   Deployment/devops-portfolio-k8s   cpu: 5%/20%    1         5         5          33m
devops-portfolio-k8s-hpa   Deployment/devops-portfolio-k8s   cpu: 5%/20%    1         5         2          33m
devops-portfolio-k8s-hpa   Deployment/devops-portfolio-k8s   cpu: 5%/20%    1         5         2          34m
devops-portfolio-k8s-hpa   Deployment/devops-portfolio-k8s   cpu: 5%/20%    1         5         2          34m
devops-portfolio-k8s-hpa   Deployment/devops-portfolio-k8s   cpu: 5%/20%    1         5         1          34m
```

## Zusammenfassung
- **Minikube** aufgesetzt, um ein lokales Kubernetes-Cluster zu betreiben.  
- **Docker-Image** einer statischen Website mit **NGINX** als Basis erstellt und in Docker Hub veröffentlicht.  
- **Deployment und Service** in Kubernetes angelegt, um die Anwendung auszurollen und über einen NodePort verfügbar zu machen.  
- **ConfigMap** und **Secret** zur Konfiguration empfindlicher Daten und Variablen eingesetzt.  
- **Probes** (Liveness & Readiness) implementiert, um die Anwendungsverfügbarkeit zu gewährleisten.  
- **Horizontal Pod Autoscaler** (HPA) hinzugefügt, um Skalierung unter Last zu demonstrieren.  

Durch diese Schritte habe ich ein vollständiges, kleines DevOps-Szenario auf meinem lokalen Cluster abgebildet und kann so das Zusammenspiel zwischen Docker, Kubernetes und den wichtigsten Kubernetes-Konzepten (Probes, ConfigMaps, Secrets und Autoscaling) vorführen.