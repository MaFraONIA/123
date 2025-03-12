import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

def advanced_analysis():
    # Charger les données
    df = pd.read_csv("local_dataset/curated/bigtech_curated.csv")

    print("=== Analyse avancée des données ===")

    # 1. Analyse des entreprises mentionnées (si disponible)
    if 'search_query' in df.columns:
        print("\nMentions d'entreprises :")
        company_counts = df['search_query'].value_counts()
        print(company_counts)

        # Visualisation
        plt.figure(figsize=(12, 6))
        company_counts.plot(kind='bar')
        plt.title('Mentions par entreprise')
        plt.tight_layout()
        plt.savefig('mentions_entreprises.png')

    # 2. Analyse de polarité (sentiment)
    if 'polarity' in df.columns:
        print("\nStatistiques de polarité :")
        print(df['polarity'].describe())

        # Visualisation
        plt.figure(figsize=(10, 6))
        plt.hist(df['polarity'], bins=50)
        plt.title('Distribution de la polarité des tweets')
        plt.xlabel('Polarité (sentiment)')
        plt.savefig('distribution_polarite.png')

        # Polarité moyenne par entreprise
        if 'search_query' in df.columns:
            polarity_by_company = df.groupby('search_query')['polarity'].mean().sort_values()

            plt.figure(figsize=(12, 6))
            polarity_by_company.plot(kind='bar')
            plt.title('Polarité moyenne par entreprise')
            plt.axhline(y=0, color='r', linestyle='-')
            plt.tight_layout()
            plt.savefig('polarite_par_entreprise.png')

    # 3. Analyse de l'engagement
    if 'retweet_count' in df.columns:
        print("\nStatistiques de retweets :")
        print(df['retweet_count'].describe())

        # Visualisation
        plt.figure(figsize=(10, 6))
        plt.hist(df['retweet_count'].clip(0, 100), bins=50, log=True)
        plt.title('Distribution des retweets (échelle log)')
        plt.xlabel('Nombre de retweets')
        plt.savefig('distribution_retweets.png')

        # Retweets moyens par entreprise
        if 'search_query' in df.columns:
            retweets_by_company = df.groupby('search_query')['retweet_count'].mean().sort_values(ascending=False)

            plt.figure(figsize=(12, 6))
            retweets_by_company.plot(kind='bar')
            plt.title('Nombre moyen de retweets par entreprise')
            plt.tight_layout()
            plt.savefig('retweets_par_entreprise.png')

    # 4. Relation entre longueur du tweet et engagement
    plt.figure(figsize=(10, 6))
    # Échantillonner pour éviter de surcharger le graphique
    sample_size = min(1000, len(df))
    sample_df = df.sample(sample_size)
    plt.scatter(sample_df['word_count'], sample_df['retweet_count'], alpha=0.5)
    plt.title('Relation entre longueur du tweet et nombre de retweets')
    plt.xlabel('Nombre de mots')
    plt.ylabel('Nombre de retweets')
    plt.savefig('longueur_vs_retweets.png')

    print("\nAnalyse avancée terminée. Visualisations sauvegardées.")

if __name__ == "__main__":
    advanced_analysis()