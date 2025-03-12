# Modifiez pipeline_local.py
import os
import shutil
import pandas as pd
import kagglehub
from pathlib import Path
import re
import emoji
from datetime import datetime

def download_kaggle_csv(output_dir: str):
    """Télécharge et extrait le dataset depuis KaggleHub"""
    print("=== Téléchargement du dataset depuis KaggleHub ===")
    local_kaggle_path = kagglehub.dataset_download("wjia26/big-tech-companies-tweet-sentiment")

    # Assurez-vous que le dossier de sortie existe
    Path(output_dir).mkdir(parents=True, exist_ok=True)

    # Nom du fichier cible
    target_filename = "Bigtech - 12-07-2020 till 19-09-2020.csv"

    # Rechercher le CSV
    for root, dirs, files in os.walk(local_kaggle_path):
        for f in files:
            if f == target_filename:
                source_path = os.path.join(root, f)
                dest_path = os.path.join(output_dir, f)
                shutil.copyfile(source_path, dest_path)
                print(f"Fichier copié dans : {dest_path}")
                return dest_path

    raise FileNotFoundError(f"Fichier '{target_filename}' non trouvé")

def preprocess_data(input_file: str, output_dir: str):
    """Prétraite les données (équivalent à preprocess_to_staging.py)"""
    print("\n=== Prétraitement des données ===")

    # Créer le dossier de sortie
    Path(output_dir).mkdir(parents=True, exist_ok=True)

    # Charger les données
    df = pd.read_csv(input_file)
    print(f"Données chargées : {len(df)} lignes")

    # Afficher les colonnes disponibles
    print(f"Colonnes disponibles : {df.columns.tolist()}")

    # Nettoyage de base
    df['clean_text'] = df['text'].apply(lambda x: re.sub(r'http\S+', '', str(x)))  # Supprimer les URLs
    df['clean_text'] = df['clean_text'].apply(lambda x: re.sub(r'@\w+', '', x))    # Supprimer les mentions
    df['clean_text'] = df['clean_text'].apply(lambda x: re.sub(r'#\w+', '', x))    # Supprimer les hashtags
    df['clean_text'] = df['clean_text'].apply(lambda x: emoji.replace_emoji(x, ''))  # Supprimer les emojis
    df['clean_text'] = df['clean_text'].apply(lambda x: x.strip())                 # Supprimer les espaces

    # Ajouter une colonne de date (utiliser la date actuelle si 'date' n'existe pas)
    if 'date' not in df.columns:
        df['date'] = datetime.now().strftime("%Y-%m-%d")
    else:
        df['date'] = pd.to_datetime(df['date'])

    # Sauvegarder en CSV
    output_file = os.path.join(output_dir, "bigtech_staging.csv")
    df.to_csv(output_file, index=False)
    print(f"Données prétraitées sauvegardées dans : {output_file}")

    return output_file

def process_curated(input_file: str, output_dir: str):
    """Traite les données pour la couche curated (version simplifiée)"""
    print("\n=== Traitement final des données ===")

    # Créer le dossier de sortie
    Path(output_dir).mkdir(parents=True, exist_ok=True)

    # Charger les données
    df = pd.read_csv(input_file)

    # Ajouter quelques transformations simples
    df['word_count'] = df['clean_text'].apply(lambda x: len(str(x).split()))
    df['processed_date'] = datetime.now().strftime("%Y-%m-%d")

    # Sauvegarder en CSV (au lieu de MongoDB)
    output_file = os.path.join(output_dir, "bigtech_curated.csv")
    df.to_csv(output_file, index=False)
    print(f"Données finales sauvegardées dans : {output_file}")

    return output_file

def main():
    # Définir les dossiers
    raw_dir = "local_dataset/raw"
    staging_dir = "local_dataset/staging"
    curated_dir = "local_dataset/curated"

    # Étape 1: Télécharger les données brutes
    raw_file = download_kaggle_csv(raw_dir)

    # Étape 2: Prétraiter les données
    staging_file = preprocess_data(raw_file, staging_dir)

    # Étape 3: Traiter les données pour la couche curated
    curated_file = process_curated(staging_file, curated_dir)

    print("\n=== Pipeline terminé avec succès ===")
    print(f"Données brutes: {raw_file}")
    print(f"Données prétraitées: {staging_file}")
    print(f"Données finales: {curated_file}")

if __name__ == "__main__":
    main()