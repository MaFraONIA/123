import pandas as pd
import matplotlib.pyplot as plt
import os
import base64
from io import BytesIO

def get_image_base64(fig):
    """Convertit une figure matplotlib en base64 pour l'inclure dans un HTML"""
    buf = BytesIO()
    fig.savefig(buf, format='png')
    buf.seek(0)
    img_str = base64.b64encode(buf.read()).decode('utf-8')
    return img_str

def create_html_report():
    """Crée un rapport HTML avec les analyses des données"""
    # Charger les données
    df = pd.read_csv("local_dataset/curated/bigtech_curated.csv")

    # Créer les visualisations
    # 1. Distribution des mots
    fig1 = plt.figure(figsize=(10, 6))
    plt.hist(df['word_count'], bins=30)
    plt.title('Distribution du nombre de mots par tweet')
    plt.xlabel('Nombre de mots')
    plt.ylabel('Fréquence')
    img1 = get_image_base64(fig1)
    plt.close(fig1)

    # 2. Distribution de la polarité
    fig2 = plt.figure(figsize=(10, 6))
    plt.hist(df['polarity'], bins=30)
    plt.title('Distribution de la polarité des tweets')
    plt.xlabel('Polarité')
    plt.ylabel('Fréquence')
    img2 = get_image_base64(fig2)
    plt.close(fig2)

    # 3. Retweets par entreprise
    if 'search_query' in df.columns:
        fig3 = plt.figure(figsize=(12, 6))
        retweets_by_company = df.groupby('search_query')['retweet_count'].mean().sort_values(ascending=False)
        retweets_by_company.plot(kind='bar')
        plt.title('Nombre moyen de retweets par entreprise')
        plt.tight_layout()
        img3 = get_image_base64(fig3)
        plt.close(fig3)
    else:
        img3 = None

    # Créer le HTML
    html = f"""
    <!DOCTYPE html>
    <html>
    <head>
        <title>Rapport d'analyse des tweets Big Tech</title>
        <style>
            body {{ font-family: Arial, sans-serif; margin: 20px; }}
            h1 {{ color: #333366; }}
            h2 {{ color: #666699; }}
            .stats {{ background-color: #f5f5f5; padding: 15px; border-radius: 5px; }}
            .image-container {{ margin: 20px 0; }}
            table {{ border-collapse: collapse; width: 100%; }}
            th, td {{ border: 1px solid #ddd; padding: 8px; text-align: left; }}
            th {{ background-color: #f2f2f2; }}
        </style>
    </head>
    <body>
        <h1>Rapport d'analyse des tweets Big Tech</h1>

        <h2>Statistiques générales</h2>
        <div class="stats">
            <p>Nombre total de tweets: <strong>{len(df)}</strong></p>
            <p>Polarité moyenne: <strong>{df['polarity'].mean():.4f}</strong></p>
            <p>Nombre moyen de retweets: <strong>{df['retweet_count'].mean():.2f}</strong></p>
            <p>Longueur moyenne des tweets: <strong>{df['word_count'].mean():.2f} mots</strong></p>
        </div>

        <h2>Distribution du nombre de mots par tweet</h2>
        <div class="image-container">
            <img src="data:image/png;base64,{img1}" alt="Distribution du nombre de mots" width="800">
        </div>

        <h2>Distribution de la polarité des tweets</h2>
        <div class="image-container">
            <img src="data:image/png;base64,{img2}" alt="Distribution de la polarité" width="800">
        </div>
    """

    if img3:
        html += f"""
        <h2>Nombre moyen de retweets par entreprise</h2>
        <div class="image-container">
            <img src="data:image/png;base64,{img3}" alt="Retweets par entreprise" width="800">
        </div>
        """

    html += """
    </body>
    </html>
    """

    # Écrire le HTML dans un fichier
    with open('rapport_analyse_tweets.html', 'w', encoding='utf-8') as f:
        f.write(html)

    print("Rapport HTML créé : rapport_analyse_tweets.html")

if __name__ == "__main__":
    create_html_report()