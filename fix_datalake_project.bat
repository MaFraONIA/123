@echo off
echo ===== SCRIPT DE CORRECTION DU PROJET DATALAKE =====
echo.
echo Correction du fichier docker-compose.yml...
echo Sauvegarde du fichier original vers docker-compose.yml.bak
copy temp_project_analysis/Projet-datalake-main/docker-compose.yml temp_project_analysis/Projet-datalake-main/docker-compose.yml.bak
type temp_project_analysis/Projet-datalake-main/docker-compose.yml | findstr /v "version:" > temp_project_analysis/Projet-datalake-main/docker-compose.yml.tmp
move /y temp_project_analysis/Projet-datalake-main/docker-compose.yml.tmp temp_project_analysis/Projet-datalake-main/docker-compose.yml
echo Docker-compose.yml corrigé.
echo.
echo Installation des dépendances...
pip install -r requirements.txt
echo.
echo Démarrage des services Docker un par un...
echo Assurez-vous que Docker Desktop est en cours d'exécution.
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
echo Démarrage de MySQL...
docker-compose up -d mysql
timeout /t 5
echo.
echo Démarrage de MongoDB...
docker-compose up -d mongodb
timeout /t 5
echo.
echo Configuration d'Airflow...
set AIRFLOW_HOME=%USERPROFILE%\airflow
mkdir %AIRFLOW_HOME%\dags 2>nul
echo.
echo Initialisation de la base de données Airflow...
airflow db init
echo.
echo Création d'un utilisateur Airflow...
airflow users create --username admin --password admin --firstname Admin --lastname User --role Admin --email admin@example.com
echo.
echo Copie des DAGs vers le dossier Airflow...
copy dags\* %AIRFLOW_HOME%\dags\
echo.
echo Pour démarrer Airflow, exécutez les commandes suivantes dans deux terminaux séparés:
echo Terminal 1: airflow webserver --port 8080
echo Terminal 2: airflow scheduler
echo.
echo Puis accédez à http://localhost:8080 dans votre navigateur
echo Nom d'utilisateur: admin, Mot de passe: admin
echo.
echo ===== OPTION ALTERNATIVE: EXÉCUTION LOCALE =====
echo Si Docker ou Airflow ne fonctionne pas, vous pouvez exécuter le pipeline localement.
echo.
echo Pour exécuter le pipeline localement, utilisez la commande suivante:
echo python pipeline_local.py
echo.
