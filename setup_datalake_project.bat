import os
import zipfile
import shutil
from pathlib import Path

# Créer un dossier temporaire pour l'extraction
temp_dir = Path("temp_project")
if temp_dir.exists():
    shutil.rmtree(temp_dir)
temp_dir.mkdir()

# Extraire le ZIP
print(f"Extraction de Projet-datalake-main.zip...")
with zipfile.ZipFile("Projet-datalake-main.zip", 'r') as zip_ref:
    zip_ref.extractall(temp_dir)

# Vérifier la structure exacte
print("\nStructure exacte du projet:")
for root, dirs, files in os.walk(temp_dir):
    level = root.replace(str(temp_dir), '').count(os.sep)
    indent = ' ' * 4 * level
    print(f"{indent}{os.path.basename(root)}/")
    sub_indent = ' ' * 4 * (level + 1)
    for f in files:
        print(f"{sub_indent}{f}")

# Rechercher spécifiquement le fichier docker-compose.yml
print("\nRecherche du fichier docker-compose.yml:")
docker_compose_paths = []
for root, dirs, files in os.walk(temp_dir):
    for file in files:
        if file.lower() == 'docker-compose.yml':
            path = os.path.join(root, file)
            docker_compose_paths.append(path)
            print(f"Trouvé à: {path}")
            # Afficher les premières lignes du fichier
            print("\nContenu des premières lignes:")
            with open(path, 'r') as f:
                lines = f.readlines()[:10]  # Afficher les 10 premières lignes
                for line in lines:
                    print(f"  {line.strip()}")

# Créer un script batch corrigé
print("\nCréation d'un script batch corrigé...")

bat_content = """@echo off
echo ===== SCRIPT DE CORRECTION DU PROJET DATALAKE =====
echo.

REM Vérifier si Docker est installé
docker --version > nul 2>&1
if %errorlevel% neq 0 (
    echo Docker n'est pas installé ou n'est pas dans le PATH.
    echo Veuillez installer Docker Desktop depuis https://www.docker.com/products/docker-desktop
    exit /b 1
)

REM Vérifier si Docker est en cours d'exécution
docker info > nul 2>&1
if %errorlevel% neq 0 (
    echo Docker n'est pas en cours d'exécution.
    echo Veuillez démarrer Docker Desktop et réessayer.
    exit /b 1
)

echo Docker est correctement installé et en cours d'exécution.
echo.

REM Correction du fichier docker-compose.yml
echo Correction du fichier docker-compose.yml...
echo Sauvegarde du fichier original vers docker-compose.yml.bak
copy docker-compose.yml docker-compose.yml.bak

REM Utiliser PowerShell pour supprimer la ligne "version:"
powershell -Command "(Get-Content docker-compose.yml) | Where-Object {$_ -notmatch '^version:'} | Set-Content docker-compose.yml.tmp"
move /y docker-compose.yml.tmp docker-compose.yml
echo Docker-compose.yml corrigé.
echo.

REM Installation des dépendances
echo Installation des dépendances...
pip install -r build/requirements.txt
echo.

REM Configuration des variables d'environnement AWS pour LocalStack
echo Configuration des variables d'environnement AWS...
set AWS_ACCESS_KEY_ID=test
set AWS_SECRET_ACCESS_KEY=test
set AWS_DEFAULT_REGION=us-east-1
echo Variables d'environnement AWS configurées.
echo.

REM Démarrage des services Docker un par un
echo Démarrage des services Docker un par un...
echo.

echo Démarrage de LocalStack...
docker-compose up -d localstack
timeout /t 10
echo.

echo Création des buckets S3...
aws --endpoint-url=http://localhost:4566 s3 mb s3://raw
aws --endpoint-url=http://localhost:4566 s3 mb s3://staging
aws --endpoint-url=http://localhost:4566 s3 mb s3://curated
echo.

echo Démarrage de MongoDB...
docker-compose up -d mongodb
timeout /t 5
echo.

echo Démarrage de MySQL...
docker-compose up -d mysql
timeout /t 5
echo.

echo Démarrage de Postgres (pour Airflow)...
docker-compose up -d postgres
timeout /t 5
echo.

echo Initialisation d'Airflow...
docker-compose up -d airflow-init
timeout /t 10
echo.

echo Démarrage des services Airflow...
docker-compose up -d airflow-webserver airflow-scheduler
echo.

echo Tous les services ont été démarrés.
echo.

echo Pour accéder à l'interface web d'Airflow, ouvrez votre navigateur et accédez à:
echo http://localhost:8081
echo.

echo Pour vérifier l'état des services Docker:
echo docker ps
echo.

echo Pour arrêter tous les services:
echo docker-compose down
echo.

echo ===== CONFIGURATION TERMINÉE =====
"""

with open("setup_datalake_project.bat", "w") as f:
    f.write(bat_content)

print("Script batch corrigé créé: setup_datalake_project.bat")

# Créer un script pour vérifier l'état des services
check_script = """@echo off
echo ===== VÉRIFICATION DE L'ÉTAT DES SERVICES =====
echo.

REM Vérifier si Docker est en cours d'exécution
docker info > nul 2>&1
if %errorlevel% neq 0 (
    echo Docker n'est pas en cours d'exécution.
    echo Veuillez démarrer Docker Desktop et réessayer.
    exit /b 1
)

echo État des services Docker:
docker ps
echo.

echo Vérification de LocalStack:
curl -s http://localhost:4566 > nul
if %errorlevel% neq 0 (
    echo LocalStack n'est pas accessible.
) else (
    echo LocalStack est en cours d'exécution.
    echo Vérification des buckets S3:
    aws --endpoint-url=http://localhost:4566 s3 ls
)
echo.

echo Vérification de MongoDB:
docker exec -it mongodb mongosh --eval "db.version()" > nul 2>&1
if %errorlevel% neq 0 (
    echo MongoDB n'est pas accessible.
) else (
    echo MongoDB est en cours d'exécution.
)
echo.

echo Vérification de MySQL:
docker exec -it mysql mysql -uroot -pexample -e "SELECT VERSION();" > nul 2>&1
if %errorlevel% neq 0 (
    echo MySQL n'est pas accessible.
) else (
    echo MySQL est en cours d'exécution.
)
echo.

echo Vérification d'Airflow:
curl -s http://localhost:8081 > nul
if %errorlevel% neq 0 (
    echo L'interface web d'Airflow n'est pas accessible.
) else (
    echo L'interface web d'Airflow est accessible.
)
echo.

echo ===== VÉRIFICATION TERMINÉE =====
"""

with open("check_services.bat", "w") as f:
    f.write(check_script)

print("Script de vérification créé: check_services.bat")

# Créer un guide d'utilisation
guide = """# Guide d'utilisation du projet Data Lake

## Prérequis
- Docker Desktop installé et en cours d'exécution
- Python 3.9+ installé
- AWS CLI installé

## Installation et configuration

1. **Correction et démarrage des services**
   
   Exécutez le script `setup_datalake_project.bat` pour :
   - Corriger le fichier docker-compose.yml
   - Installer les dépendances
   - Configurer les variables d'environnement AWS
   - Démarrer les services Docker un par un