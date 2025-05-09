
# Déploiement Nginx avec Kubernetes sur EC2

## Prérequis

- **Minikube** installé
- **Docker** installé (si tu utilises Docker comme driver Minikube)
- **kubectl** configuré
- **EC2 Instance** avec accès SSH
`LoadBalancer`

---

## 1. Démarrer Minikube

### Démarrer Minikube avec Docker comme driver :

```bash
minikube start --driver=docker
```

### Vérifier le statut du cluster :

```bash
minikube status
```

### Vérifier l'adresse IP de Minikube :

```bash
minikube ip
```

---

## 2. Créer le fichier de déploiement YAML pour Nginx

Crée un fichier appelé `nginx-deployment.yaml` avec le contenu suivant :

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
```

### Appliquer le déploiement avec `kubectl` :

```bash
kubectl apply -f nginx-deployment.yaml
```

### Vérifier que le déploiement a bien été effectué avec `kubectl` :

```bash
kubectl get pods
```

Cela devrait retourner la liste des pods en cours d'exécution, incluant les pods de Nginx.

---

## 3. Créer le fichier de service YAML pour Nginx

### Option 1: Pour **NodePort**

Crée un fichier appelé `nginx-service-nodeport.yaml` avec le contenu suivant :

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  type: NodePort
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
      nodePort: 30851
```

### Option 2: Pour **LoadBalancer** (si tu veux une IP publique pour accéder à Nginx)

Crée un fichier appelé `nginx-service-loadbalancer.yaml` avec le contenu suivant :

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  type: LoadBalancer
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
```

### Appliquer le service avec `kubectl` :

Pour **NodePort** :

```bash
kubectl apply -f nginx-service-nodeport.yaml
```

Pour **LoadBalancer** :

```bash
kubectl apply -f nginx-service-loadbalancer.yaml
```

### Vérifier que le service est bien exposé avec `kubectl` :

```bash
kubectl get svc nginx-service
```

Cela te permettra de voir l'IP et le port exposés pour accéder à ton service Nginx.

---

## 4. Accéder à Nginx depuis ta machine locale

### Méthode 1 : Accès via NodePort

Si tu utilises **NodePort**, tu peux accéder à Nginx via l'IP publique de ton instance EC2 et le port `30851`.

```bash
curl http://<EC2_PUBLIC_IP>:30851
```

### Méthode 2 : Accès via LoadBalancer + minikube tunnel

Si tu utilises **LoadBalancer**, lance le tunnel sur EC2 :

```bash
sudo minikube tunnel
```

Puis récupère l'IP publique attribuée au service avec `kubectl` :

```bash
kubectl get svc nginx-service
```

Accède à Nginx via cette IP dans ton navigateur :

```bash
curl http://<EXTERNAL-IP>
```

---

## 5. Commandes supplémentaires avec `kubectl`

Voici quelques commandes `kubectl` utiles pour gérer ton cluster Kubernetes.

### Vérifier les ressources Kubernetes :

- **Vérifier les pods** :

```bash
kubectl get pods
```

- **Vérifier les services** :

```bash
kubectl get svc
```

- **Vérifier les déploiements** :

```bash
kubectl get deployments
```

- **Vérifier les namespaces** :

```bash
kubectl get namespaces
```

- **Vérifier les logs d'un pod** :

```bash
kubectl logs <nom-du-pod>
```

### Supprimer des ressources Kubernetes :

- **Supprimer un pod** :

```bash
kubectl delete pod <nom-du-pod>
```

- **Supprimer un déploiement** :

```bash
kubectl delete deployment <nom-du-déploiement>
```

- **Supprimer un service** :

```bash
kubectl delete svc <nom-du-service>
```

- **Supprimer une ressource** avec un fichier YAML :

```bash
kubectl delete -f <nom-du-fichier.yaml>
```

---

## 6. Dépannage

### Arrêter Minikube

Pour arrêter Minikube :

```bash
minikube stop
```

### Supprimer Minikube et toutes ses ressources

Si tu veux tout supprimer :

```bash
minikube delete
```

---

## Conclusion

Tu as maintenant un déploiement Nginx fonctionnel sur Kubernetes avec Minikube sur EC2. Tu peux maintenant tester l'accès depuis ta machine locale à l'aide de NodePort ou d'un service LoadBalancer.

---

### N'hésite pas à compléter ce fichier avec des informations supplémentaires ou des étapes personnalisées en fonction de ton environnement !
