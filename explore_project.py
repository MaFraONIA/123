import os
import pandas as pd

def explore_project_structure():
    """Explore la structure du projet et affiche les informations importantes"""
    print("=== Exploration du projet Data Lake ===\n")

    # 1. Afficher la structure des dossiers
    print("Structure des dossiers principaux :")
    for root, dirs, files in os.walk('.', topdown=True):
        level = root.count(os.sep)
        if level <= 1:  # Limiter la profondeur
            indent = ' ' * 4 * level
            print(f"{indent}{os.path.basename(root)}/")
            sub_indent = ' ' * 4 * (level + 1)
            for f in files[:5]:  # Limiter le nombre de fichiers affichés
                print(f"{sub_indent}{f}")
            if len(files) > 5:
                print(f"{sub_indent}... ({len(files)-5} fichiers supplémentaires)")

    # 2. Explorer les données traitées
    print("\nAperçu des données traitées :")
    try:
        df = pd.read_csv("local_dataset/curated/bigtech_curated.csv")
        print(f"Nombre total de lignes : {len(df)}")
        print(f"Colonnes disponibles : {', '.join(df.columns)}")

        # Afficher quelques statistiques
        print("\nStatistiques sur les données :")
        if 'polarity' in df.columns:
            print(f"Polarité moyenne : {df['polarity'].mean():.4f}")
        if 'retweet_count' in df.columns:
            print(f"Nombre moyen de retweets : {df['retweet_count'].mean():.2f}")
        if 'word_count' in df.columns:
            print(f"Longueur moyenne des tweets : {df['word_count'].mean():.2f} mots")

        # Afficher les 5 premiers tweets
        print("\nExemples de tweets :")
        for i, row in df.head(5).iterrows():
            print(f"Tweet {i+1}: {row['text'][:100]}...")
    except Exception as e:
        print(f"Erreur lors de l'exploration des données : {e}")

    # 3. Explorer les scripts Python
    print("\nScripts Python importants :")
    python_files = []
    for root, dirs, files in os.walk('.'):
        for file in files:
            if file.endswith('.py'):
                python_files.append(os.path.join(root, file))

    for py_file in python_files[:10]:  # Limiter à 10 fichiers
        print(f"- {py_file}")

    if len(python_files) > 10:
        print(f"... et {len(python_files)-10} autres scripts Python")

    print("\nExploration terminée.")

if __name__ == "__main__":
    explore_project_structure()