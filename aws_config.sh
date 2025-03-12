#!/bin/bash
set -e

echo "=== CONFIGURATION DES VARIABLES D'ENVIRONNEMENT AWS ==="
echo

# Configurer les variables d'environnement AWS
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
export AWS_ENDPOINT_URL=http://localhost:4566

echo "Variables d'environnement AWS configurées:"
echo "AWS_ACCESS_KEY_ID=test"
echo "AWS_SECRET_ACCESS_KEY=test"
echo "AWS_DEFAULT_REGION=us-east-1"
echo "AWS_ENDPOINT_URL=http://localhost:4566"
echo

echo "Pour utiliser ces variables dans votre terminal actuel, exécutez:"
echo "source aws_config.sh"
