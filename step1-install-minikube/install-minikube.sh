#!/bin/bash

# Script d'installation de Minikube sur Ubuntu 24.04

set -e

echo "🔄 Mise à jour du système..."
sudo apt update && sudo apt upgrade -y

echo "🐳 Installation de Docker..."
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER

echo "♻️ Rechargement des groupes utilisateurs..."
newgrp docker

echo "🔧 Installation de kubectl..."
curl -LO https://dl.k8s.io/release/v1.30.0/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

echo "📦 Installation de Minikube..."
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

echo "🚀 Démarrage de Minikube avec Docker..."
minikube start --driver=docker

echo "✅ Vérification du nœud Kubernetes..."
kubectl get nodes

echo "🎉 Installation terminée avec succès !"
