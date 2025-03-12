# Guide d'exécution du projet Data Lake

Ce guide vous aidera à exécuter le projet Data Lake avec Docker et Airflow.

## Prérequis

- Docker
- Docker Compose
- Au moins 4 Go de mémoire allouée à Docker
- Au moins 2 CPUs alloués à Docker

## Étapes d'exécution

### 1. Vérifier les prérequis

Exécutez le script de vérification des prérequis :

```bash
# Linux/macOS
./check_prerequisites.sh

# Windows
check_prerequisites.bat
```

### 2. Configurer les variables d'environnement AWS

Exécutez le script de configuration AWS :

```bash
# Linux/macOS
source aws_config.sh

# Windows
aws_config.bat
```

### 3. Démarrer le projet

Exécutez le script de démarrage :

```bash
# Linux/macOS
./run_datalake_project.sh

# Windows
run_datalake_project.bat
```

### 4. Accéder à Airflow

Une fois le projet démarré, accédez à Airflow à l'adresse suivante :

```
http://localhost:8081
```

Utilisez les identifiants suivants :
- Nom d'utilisateur : airflow
- Mot de passe : airflow

### 5. Arrêter le projet

Pour arrêter le projet, exécutez :

```bash
docker-compose down
```

## Résolution des problèmes

### Problème : Les services ne démarrent pas

Si certains services ne démarrent pas, essayez de les démarrer individuellement :

```bash
docker-compose up -d <service>
```

Remplacez `<service>` par le nom du service (localstack, mongodb, mysql, etc.).

### Problème : Erreur de mémoire

Si vous rencontrez des erreurs de mémoire, augmentez la mémoire allouée à Docker dans les paramètres de Docker Desktop.

### Problème : Ports déjà utilisés

Si certains ports sont déjà utilisés, modifiez les ports dans le fichier `docker-compose.yml`.
