#!/bin/bash
set -e

echo "=== SCRIPT D'EXÉCUTION DU PROJET DATALAKE ==="
echo

# Vérifier si Docker est installé
if ! command -v docker &> /dev/null; then
    echo "Docker n'est pas installé. Veuillez l'installer avant de continuer."
    exit 1
fi

# Vérifier si Docker Compose est installé
if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose n'est pas installé. Veuillez l'installer avant de continuer."
    exit 1
fi

# Vérifier si Docker est en cours d'exécution
if ! docker info &> /dev/null; then
    echo "Docker n'est pas en cours d'exécution. Veuillez démarrer Docker avant de continuer."
    exit 1
fi

# Se placer dans le répertoire du projet
cd "$(dirname "$0")/extracted_project/Projet-datalake-main"
echo "Répertoire courant: $(pwd)"
echo

# Afficher le contenu du répertoire
echo "Contenu du répertoire:"
ls -la
echo

# Vérifier si docker-compose.yml existe
if [ ! -f "docker-compose.yml" ]; then
    echo "Erreur: docker-compose.yml non trouvé"
    exit 1
fi

# Arrêter les conteneurs existants
echo "Arrêt des conteneurs existants..."
docker-compose down
echo

# Démarrer les services un par un
echo "Démarrage des services un par un..."

# Démarrer LocalStack
echo "Démarrage de LocalStack..."
docker-compose up -d localstack
sleep 10
echo

# Créer les buckets S3
echo "Création des buckets S3..."
docker-compose exec localstack awslocal s3 mb s3://raw
docker-compose exec localstack awslocal s3 mb s3://staging
docker-compose exec localstack awslocal s3 mb s3://curated
echo

# Démarrer MongoDB
echo "Démarrage de MongoDB..."
docker-compose up -d mongodb
sleep 5
echo

# Démarrer MySQL
echo "Démarrage de MySQL..."
docker-compose up -d mysql
sleep 5
echo

# Démarrer Elasticsearch
echo "Démarrage d'Elasticsearch..."
docker-compose up -d elasticsearch
sleep 5
echo

# Démarrer Postgres
echo "Démarrage de Postgres..."
docker-compose up -d postgres
sleep 5
echo

# Initialiser Airflow
echo "Initialisation d'Airflow..."
docker-compose up -d airflow-init
sleep 10
echo

# Démarrer Airflow
echo "Démarrage d'Airflow..."
docker-compose up -d airflow-webserver airflow-scheduler
sleep 10
echo

# Vérifier l'état des conteneurs
echo "État des conteneurs:"
docker-compose ps
echo

echo "=== PROJET DATALAKE DÉMARRÉ ==="
echo "Airflow est accessible à l'adresse: http://localhost:8081"
echo "Nom d'utilisateur: airflow"
echo "Mot de passe: airflow"
echo
echo "Pour arrêter le projet, exécutez: docker-compose down"
