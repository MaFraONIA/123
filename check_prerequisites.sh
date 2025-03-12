#!/bin/bash
set -e

echo "=== VÉRIFICATION DES PRÉREQUIS ==="
echo

# Vérifier si Docker est installé
echo -n "Docker: "
if command -v docker &> /dev/null; then
    echo "Installé ($(docker --version))"
else
    echo "Non installé"
    echo "Veuillez installer Docker: https://docs.docker.com/get-docker/"
fi

# Vérifier si Docker Compose est installé
echo -n "Docker Compose: "
if command -v docker-compose &> /dev/null; then
    echo "Installé ($(docker-compose --version))"
else
    echo "Non installé"
    echo "Veuillez installer Docker Compose: https://docs.docker.com/compose/install/"
fi

# Vérifier si Docker est en cours d'exécution
echo -n "Docker en cours d'exécution: "
if docker info &> /dev/null; then
    echo "Oui"
else
    echo "Non"
    echo "Veuillez démarrer Docker"
fi

# Vérifier la mémoire allouée à Docker
echo "Vérification de la mémoire allouée à Docker..."
if docker info &> /dev/null; then
    if command -v grep &> /dev/null; then
        docker info | grep -i memory || echo "Impossible de déterminer la mémoire allouée"
    else
        echo "Impossible de déterminer la mémoire allouée (grep non disponible)"
    fi
else
    echo "Impossible de déterminer la mémoire allouée (Docker non en cours d'exécution)"
fi

echo
echo "=== RECOMMANDATIONS ==="
echo "1. Assurez-vous que Docker dispose d'au moins 4 Go de mémoire"
echo "2. Assurez-vous que Docker dispose d'au moins 2 CPUs"
echo "3. Assurez-vous que Docker est en cours d'exécution avant de démarrer le projet"
echo

echo "Pour démarrer le projet, exécutez:"
echo "./run_datalake_project.sh"
