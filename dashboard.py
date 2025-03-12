import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Charger les données
@st.cache_data
def load_data():
    return pd.read_csv("local_dataset/curated/bigtech_curated.csv")

# Titre de l'application
st.title("Tableau de bord d'analyse des tweets Big Tech")

# Charger les données
df = load_data()

# Afficher des informations de base
st.header("Aperçu des données")
st.write(f"Nombre total de tweets : {len(df)}")
st.dataframe(df.head())

# Sélecteur d'entreprise (si disponible)
if 'search_query' in df.columns:
    st.header("Filtrer par entreprise")
    companies = ['Toutes'] + sorted(df['search_query'].unique().tolist())
    selected_company = st.selectbox("Choisir une entreprise", companies)

    if selected_company != 'Toutes':
        filtered_df = df[df['search_query'] == selected_company]
    else:
        filtered_df = df
else:
    filtered_df = df

# Afficher des statistiques
st.header("Statistiques")
col1, col2 = st.columns(2)

with col1:
    st.subheader("Distribution des mots")
    fig, ax = plt.subplots()
    filtered_df['word_count'].hist(bins=30, ax=ax)
    st.pyplot(fig)

with col2:
    if 'polarity' in filtered_df.columns:
        st.subheader("Distribution de la polarité")
        fig, ax = plt.subplots()
        sns.histplot(filtered_df['polarity'], bins=30, kde=True, ax=ax)
        st.pyplot(fig)

# Afficher les tweets les plus retweetés
st.header("Top 10 des tweets les plus retweetés")
top_tweets = filtered_df.sort_values('retweet_count', ascending=False).head(10)
for i, (_, tweet) in enumerate(top_tweets.iterrows()):
    st.write(f"**{i+1}. Retweets: {tweet['retweet_count']}**")
    st.write(tweet['text'])
    st.write("---")