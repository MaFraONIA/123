@echo off
echo === SCRIPT D'EXECUTION DU PROJET DATALAKE ===
echo.

REM Vérifier si Docker est installé
where docker >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Docker n'est pas installe. Veuillez l'installer avant de continuer.
    exit /b 1
)

REM Vérifier si Docker Compose est installé
where docker-compose >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Docker Compose n'est pas installe. Veuillez l'installer avant de continuer.
    exit /b 1
)

REM Se placer dans le répertoire du projet
cd %~dp0extracted_project\Projet-datalake-main
echo Repertoire courant: %CD%
echo.

REM Afficher le contenu du répertoire
echo Contenu du repertoire:
dir
echo.

REM Vérifier si docker-compose.yml existe
if not exist "docker-compose.yml" (
    echo Erreur: docker-compose.yml non trouve
    exit /b 1
)

REM Arrêter les conteneurs existants
echo Arret des conteneurs existants...
docker-compose down
echo.

REM Démarrer les services un par un
echo Demarrage des services un par un...

REM Démarrer LocalStack
echo Demarrage de LocalStack...
docker-compose up -d localstack
timeout /t 10 /nobreak
echo.

REM Créer les buckets S3
echo Creation des buckets S3...
docker-compose exec localstack awslocal s3 mb s3://raw
docker-compose exec localstack awslocal s3 mb s3://staging
docker-compose exec localstack awslocal s3 mb s3://curated
echo.

REM Démarrer MongoDB
echo Demarrage de MongoDB...
docker-compose up -d mongodb
timeout /t 5 /nobreak
echo.

REM Démarrer MySQL
echo Demarrage de MySQL...
docker-compose up -d mysql
timeout /t 5 /nobreak
echo.

REM Démarrer Elasticsearch
echo Demarrage d'Elasticsearch...
docker-compose up -d elasticsearch
timeout /t 5 /nobreak
echo.

REM Démarrer Postgres
echo Demarrage de Postgres...
docker-compose up -d postgres
timeout /t 5 /nobreak
echo.

REM Initialiser Airflow
echo Initialisation d'Airflow...
docker-compose up -d airflow-init
timeout /t 10 /nobreak
echo.

REM Démarrer Airflow
echo Demarrage d'Airflow...
docker-compose up -d airflow-webserver airflow-scheduler
timeout /t 10 /nobreak
echo.

REM Vérifier l'état des conteneurs
echo Etat des conteneurs:
docker-compose ps
echo.

echo === PROJET DATALAKE DEMARRE ===
echo Airflow est accessible a l'adresse: http://localhost:8081
echo Nom d'utilisateur: airflow
echo Mot de passe: airflow
echo.
echo Pour arreter le projet, executez: docker-compose down
