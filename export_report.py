# Créez un fichier export_report.py
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from fpdf import FPDF
import os

def create_report():
    # Charger les données
    df = pd.read_csv("local_dataset/curated/bigtech_curated.csv")

    # Créer un dossier pour les images temporaires
    os.makedirs("report_images", exist_ok=True)

    # Générer quelques visualisations
    # 1. Distribution des mots
    plt.figure(figsize=(10, 6))
    df['word_count'].hist(bins=30)
    plt.title('Distribution du nombre de mots par tweet')
    plt.savefig('report_images/word_distribution.png')
    plt.close()

    # 2. Distribution de la polarité
    if 'polarity' in df.columns:
        plt.figure(figsize=(10, 6))
        sns.histplot(df['polarity'], bins=30, kde=True)
        plt.title('Distribution de la polarité')
        plt.savefig('report_images/polarity_distribution.png')
        plt.close()

    # Créer le PDF
    pdf = FPDF()
    pdf.add_page()

    # Titre
    pdf.set_font('Arial', 'B', 16)
    pdf.cell(0, 10, 'Rapport d\'analyse des tweets Big Tech', 0, 1, 'C')
    pdf.ln(10)

    # Statistiques générales
    pdf.set_font('Arial', 'B', 14)
    pdf.cell(0, 10, '1. Statistiques générales', 0, 1)
    pdf.set_font('Arial', '', 12)
    pdf.cell(0, 10, f'Nombre total de tweets: {len(df)}', 0, 1)

    # Ajouter les images
    pdf.add_page()
    pdf.set_font('Arial', 'B', 14)
    pdf.cell(0, 10, '2. Visualisations', 0, 1)

    pdf.set_font('Arial', '', 12)
    pdf.cell(0, 10, 'Distribution du nombre de mots par tweet:', 0, 1)
    pdf.image('report_images/word_distribution.png', x=10, y=None, w=180)

    if 'polarity' in df.columns:
        pdf.add_page()
        pdf.cell(0, 10, 'Distribution de la polarité des tweets:', 0, 1)
        pdf.image('report_images/polarity_distribution.png', x=10, y=None, w=180)

    # Sauvegarder le PDF
    pdf.output('rapport_analyse_tweets.pdf')
    print("Rapport PDF créé : rapport_analyse_tweets.pdf")

if __name__ == "__main__":
    create_report()