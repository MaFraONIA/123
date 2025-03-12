# Modifiez analyze_data.py
import pandas as pd
import matplotlib.pyplot as plt

def analyze_data():
    # Charger les données finales
    df = pd.read_csv("local_dataset/curated/bigtech_curated.csv")

    # Afficher les colonnes disponibles
    print(f"Colonnes disponibles : {df.columns.tolist()}")

    # Afficher quelques statistiques
    print(f"Nombre total de tweets: {len(df)}")

    # Vérifier si les colonnes existent avant de les utiliser
    if 'company' in df.columns:
        print(f"\nRépartition par entreprise:")
        print(df['company'].value_counts())

        # Créer visualisation
        plt.figure(figsize=(10, 6))
        df['company'].value_counts().plot(kind='bar')
        plt.title('Nombre de tweets par entreprise')
        plt.tight_layout()
        plt.savefig('tweets_par_entreprise.png')

    if 'sentiment' in df.columns:
        print(f"\nRépartition par sentiment:")
        print(df['sentiment'].value_counts())

        # Créer visualisation
        plt.figure(figsize=(10, 6))
        df['sentiment'].value_counts().plot(kind='bar')
        plt.title('Répartition des sentiments')
        plt.tight_layout()
        plt.savefig('sentiments.png')

    # Analyser la longueur des textes
    plt.figure(figsize=(10, 6))
    df['word_count'].hist(bins=50)
    plt.title('Distribution du nombre de mots par tweet')
    plt.xlabel('Nombre de mots')
    plt.ylabel('Fréquence')
    plt.tight_layout()
    plt.savefig('distribution_mots.png')

    print("\nAnalyse terminée. Visualisations sauvegardées.")

if __name__ == "__main__":
    analyze_data()