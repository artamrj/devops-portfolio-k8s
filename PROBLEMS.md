## Überblick
In diesem Dokument werden die während meines Projekts aufgetretenen Probleme sowie die jeweiligen Lösungsansätze kurz und prägnant beschrieben.

## 1. Docker-Daemon nicht erreichbar beim Start von Minikube

- **Problem:**  
  Beim Starten von Minikube erhielt ich eine Fehlermeldung, dass der Docker-Daemon nicht erreichbar sei.
  
- **Ursache:**  
  Der Docker-Daemon war nicht aktiv.

- **Lösung:**  
  Ich habe den Docker-Daemon gestartet, sodass Minikube ohne weitere Probleme initialisiert werden konnte.

## 2. ErrImagePull beim Deployment des Testprojekts

- **Problem:**  
  Beim ersten Deployment des Testprojekts trat der Fehler `ErrImagePull` auf, da das angegebene Image `artaa/nginx-bewerbung:latest` nicht gefunden wurde.
  
- **Ursache:**  
  Das Docker-Image wurde nicht mit dem Tag `latest` gepusht, sondern mit einem spezifischen Tag (z. B. `1.0`).

- **Lösung:**  
  Ich habe den Image-Tag in der Deployment-Konfiguration von `latest` auf `1.0` angepasst, sodass Kubernetes das korrekte Image abrufen konnte.

## 3. AmbiguousSelector und HPA-Fehler

- **Problem:**  
  Beim Einsatz des Horizontal Pod Autoscalers erhielt ich die Fehlermeldung:
  ```
  pods by selector app=devops-portfolio-k8s are controlled by multiple HPAs: [default/devops-portfolio-hpa default/devops-portfolio-k8s-hpa]
  ```
  Dadurch wurde der CPU-Utilisierungswert als `<unknown>` angezeigt.

- **Ursache:**  
  Mehrere HPAs waren auf dieselben Pods ausgerichtet, was zu einer Mehrdeutigkeit (AmbiguousSelector) führte.

- **Lösung:**  
  Ich habe die HPA-Konfiguration überprüft und sichergestellt, dass ausschließlich ein HPA auf die betroffenen Pods zeigt. Dadurch wurde die Mehrdeutigkeit beseitigt und die CPU-Metriken konnten korrekt ermittelt werden.

## Fazit
Durch gezielte Anpassungen in der Konfiguration – insbesondere beim Image-Tag und der HPA-Zuweisung – konnte ich alle identifizierten Probleme erfolgreich beheben und den stabilen Betrieb der Anwendung sicherstellen.