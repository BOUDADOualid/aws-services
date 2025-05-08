# 🚀 Installation de Minikube sur Ubuntu 24.04 (EC2)

Ce guide explique pas à pas comment installer et configurer **Minikube** sur une instance **EC2 Ubuntu 24.04**, en utilisant **Docker** comme moteur.

---

## ✅ Pré-requis

- Instance EC2 (Ubuntu 24.04)
- Accès root ou `sudo`
- Accès Internet

---

## 🧱 Étapes détaillées avec explications

### 1. Mise à jour du système

```bash
sudo apt update && sudo apt upgrade -y
```
- Met à jour les paquets installés sur le système pour éviter les conflits de dépendances.

---

### 2. Installation de Docker

```bash
sudo apt install -y docker.io
```
- Installe Docker, un moteur de conteneurisation utilisé par Minikube.

```bash
sudo systemctl enable docker
sudo systemctl start docker
```
- Active Docker au démarrage et le démarre immédiatement.

```bash
sudo usermod -aG docker $USER
newgrp docker
```
- Donne les droits Docker à l'utilisateur actuel pour éviter de devoir taper `sudo` à chaque commande Docker.

---

### 3. Installation de kubectl (client Kubernetes)

```bash
curl -LO https://dl.k8s.io/release/v1.30.0/bin/linux/amd64/kubectl
```
- Télécharge la version stable 1.30.0 de `kubectl`. Change la version si nécessaire.

```bash
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
```
- Rend le fichier exécutable et le place dans le PATH système pour un accès global.

---

### 4. Installation de Minikube

```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```
- Télécharge et installe Minikube sur la machine.

---

### 5. Démarrage de Minikube

```bash
minikube start --driver=docker
```
- Démarre un cluster Kubernetes local en utilisant Docker comme moteur (driver).
- Télécharge les images nécessaires, initialise Kubernetes, configure `kubectl`.

---

### 6. Vérification du cluster

```bash
kubectl get nodes
```
- Vérifie que le nœud `minikube` est bien `Ready`, preuve que Kubernetes est opérationnel.

---

## ⚗️ Exemple de test avec un déploiement

### Créer un déploiement avec une image simple

```bash
kubectl create deployment hello-minikube --image=kicbase/echo-server:1.0
```

### Exposer le déploiement via un service

```bash
kubectl expose deployment hello-minikube --type=NodePort --port=8080
```

### Obtenir l'URL du service

```bash
minikube service hello-minikube --url
```

---

## 🧹 Nettoyage

```bash
minikube stop
```
- Arrête le cluster Kubernetes (sans le supprimer).

```bash
minikube delete
```
- Supprime complètement le cluster Minikube.

---

## 📌 Remarques

- Minikube est destiné à **l’apprentissage et au développement local**.
- Pour des déploiements réels sur AWS, utilisez plutôt **Amazon EKS**.
- Il est conseillé d’ouvrir les ports NodePort dans les règles de sécurité EC2 pour tester les services web exposés.
