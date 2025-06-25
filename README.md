On va commerce d'abord par ce partie et utliser les mages tableau pour compléter ce qui est écris ci-desous : ### 4.1 Migration réalisée vers Tableau Server
{- **Dashboards migrés** : Lister précisément lesquels (WSP View ? Order Analysis ? etc.)
Tous est sur Tableau Server, certains plus complets que d'autres, j'ai plus utiliser des paramètres sur tableau que sur Power BI  pour limiter les modifications manuelles.
1. Billing
- Il me faut ajouter les double filtres du POWER BI Privé/ Public (Capex/Opex) mais aussi les différents canaux (distributions, brokers, commerciaux) et leurs membres.
Ce n'est pas possible de faire de double filtre tableau sans utiliser les extensions, le problème avec les extensions est que :
- ça a lourdi le chargement du Dashboard (plus on en utilise plus le chargement sera long), surtout parce que ça va traiter plusieurs milliers des lignes et une trentaine de colonne 
- Sur le serveur Samsung, c'est la version tableau 2023 qui est installé, s'il utilise une extension compatibilité avec Tableau 2023 ça va fonctionne mais si pour X, Y raisons on faissez la mise à jour du tableau server Samsung (par exemple 2025), l'extension peut ne plus fonctionner car la mise à jour des extensions peuvent ne pas être régilier
Pour toutes ces raisons, le mieux serait de splitter ces fitres. 
Il me faut aussi améliorer la partie UX/UI de la version tableau du billing.
Sur la version tableau : 
- il est possible de passer de la devise euro en dollar grâce à un filtre, ainsi que convertir tout le Dashboard Billing.
- au lieu d'avoir un champ text pour modifier la date de mise à jour, c'est un paramètre qui prendre la date et l'heure du dernier changement du fichier source, plus champ date à modifier à chaque fois 
- sur tableau, le tableau  "GROWTH RATE 2025 VS 2024" est dynamique et s'adapter à tout le dashboard
- sur POWER Bi, j'avais utiliser ces formules pour calculer le montant accumulé "ACC_Y2025 BILLING AMOUNT 2025 = VAR yearN = 2025
VAR monthM = MAX(SEF_BILLING[BILLING MONTH ])
RETURN CALCULATE(SUM(SEF_BILLING[TOTAL BILLING AMOUNT (HT) €]),SEF_BILLING[BILLING YEAR]= yearN, SEF_BILLING[BILLING MONTH ]<=monthM)" et"ACC_Y2024 BILLING AMOUNT 2024 = VAR yearN = 2024
VAR monthM = MAX(SEF_BILLING[BILLING MONTH ])
RETURN CALCULATE(SUM(SEF_BILLING[TOTAL BILLING AMOUNT (HT) €]),SEF_BILLING[BILLING YEAR]= yearN, SEF_BILLING[BILLING MONTH ]<=monthM)", le problème avec cette approche il faut changer l'année en cours et l'année passé à chaque début d'année. sur tableau ces sont des parametres dont plus besoin de changer quoi ce soit car on a "INT([Billing Year])=YEAR(TODAY())" et "INT([Billing Year])=YEAR(TODAY())-1" 

2. ORDER INTAKE
- Il me faut ajouter les double filtres du POWER BI Privé/ Public (Capex/Opex) mais aussi les différents canaux (distributions, brokers, commerciaux) et leurs membres. (idem que le billing)
- Il me faut aussi améliorer la partie UX/UI de la version tableau du ORDER INTAKE.
Sur la version tableau : 
- il est possible de passer de la devise euro en dollar grâce à un filtre, ainsi que convertir tout le Dashboard Billing.
- au lieu d'avoir un champ text pour modifier la date de mise à jour, c'est un paramètre qui prendre la date et l'heure du dernier changement du fichier source, plus champ date à modifier à chaque fois 
- sur POWER Bi, j'avais utiliser ces formules pour calculer le montant accumulé "ACC BILLING AMOUNT 2022 = VAR yearN = 2022
VAR weekW = MAX('Calendar'[Week])
RETURN CALCULATE(SUM(SEF_ACTIVITY[TOTAL BILLING AMOUNT (HT) €]),SEF_ACTIVITY[CONTRACT RECEIPT YEAR]= yearN, 'Calendar'[Week]<=weekW)", "ACC BILLING AMOUNT 2023 = VAR yearN = 2023
VAR weekW = MAX('Calendar'[Week])
RETURN CALCULATE(SUM(SEF_ACTIVITY[TOTAL BILLING AMOUNT (HT) €]),SEF_ACTIVITY[CONTRACT RECEIPT YEAR]= yearN, 'Calendar'[Week]<=weekW)", "ACC BILLING AMOUNT 2024 = VAR yearN = 2024
VAR weekW = MAX('Calendar'[Week])
RETURN CALCULATE(SUM(SEF_ACTIVITY[TOTAL BILLING AMOUNT (HT) €]),SEF_ACTIVITY[CONTRACT RECEIPT YEAR]= yearN, 'Calendar'[Week]<=weekW)" et "ACC BILLING AMOUNT 2025 = VAR yearN = 2025
VAR weekW = MAX('Calendar'[Week])
RETURN CALCULATE(SUM(SEF_ACTIVITY[TOTAL BILLING AMOUNT (HT) €]),SEF_ACTIVITY[CONTRACT RECEIPT YEAR]= yearN, 'Calendar'[Week]<=weekW)" le problème avec cette approche il faut changer l'année en cours,l'année passé (year-2 et year-3) à chaque début d'année. sur tableau ces sont des parametres dont plus besoin de changer quoi ce soit car on a "YEAR(date([Contract Receipt Date]))= YEAR(TODAY())", "YEAR(date([Contract Receipt Date]))=YEAR(TODAY())-1", "YEAR(date([Contract Receipt Date]))=YEAR(TODAY())-2", "YEAR(date([Contract Receipt Date]))=YEAR(TODAY())-3" idem que le billing.

3. WSP VIEW

Etat donné que les besoins évolutifs de la division, la version du WSP VIEW de fin mars 2025 est différente de la version JUIN 205, la quasi totalité des tableaux, filtres et graphes doivent être changé, c'est le dashboard où il y'a beaucoup à refaire.

- Il me faut aussi améliorer la partie UX/UI de la version tableau 

4. CUSTOMER DATA

- au lieu d'avoir un champ text pour modifier la date de mise à jour, c'est un paramètre qui prendre la date et l'heure du dernier changement du fichier source, plus champ date à modifier à chaque fois 

La version du POWER BI et Tableau est la même c'est le dashboard où il y'a plus presque rien à modifier 
- Il me faut aussi améliorer la partie UX/UI de la version tableau 
 
5. Business Opportunities

- au lieu d'avoir un champ text pour modifier la date de mise à jour, c'est un paramètre qui prendre la date et l'heure du dernier changement du fichier source, plus champ date à modifier à chaque fois 

La version du POWER BI et Tableau est la même c'est le dashboard où il y'a presque plus rien à modifier
- Il me faut aussi améliorer la partie UX/UI de la version tableau 


6. Billing, Backlog & Forecast vs Target

- au lieu d'avoir un champ text pour modifier la date de mise à jour, c'est un paramètre qui prendre la date et l'heure du dernier changement du fichier source, plus champ date à modifier à chaque fois 

La version du POWER BI et Tableau est la même c'est le dashboard où il y'a presque plus rien à modifier
- Il me faut aussi améliorer la partie UX/UI de la version tableau 

7. INSTALLED BASE HME

- au lieu d'avoir un champ text pour modifier la date de mise à jour, c'est un paramètre qui prendre la date et l'heure du dernier changement du fichier source, plus champ date à modifier à chaque fois 

La version du POWER BI et Tableau est la même c'est le dashboard où il y'a presque plus rien à modifier
- Il me faut aussi améliorer la partie UX/UI de la version tableau mais ajouter ajouter de nouveaux filtres sur base de nouvelles demandes qui sont déjà présentent sur POWER BI.

} tu auras la suite dans les prochaines prompts.



## Perles spirituelles

Q1/


Pour répondre à la question sur Proverbe 16:22, qui affirme que « les stupides sont punis par leur bêtise », il est essentiel d'explorer le sens de cette affirmation dans le contexte des Proverbes et de la sagesse biblique.

Compréhension du Proverbe

Le Proverbe 16:22 souligne que la sagesse et la compréhension sont des atouts précieux, tandis que la stupidité peut mener à des conséquences néfastes. Dans ce verset, la « bêtise » fait référence à un manque de discernement et à des choix imprudents. Les personnes qualifiées de « stupides » ne tiennent pas compte des conseils sages et des enseignements, ce qui les conduit souvent à des situations difficiles.

La Bêtise comme Source de Punition

La notion que les stupides sont « punis par leur bêtise » peut être interprétée de plusieurs manières :

Conséquences Naturelles : Les décisions imprudentes entraînent souvent des résultats négatifs. Par exemple, quelqu'un qui ignore les avertissements concernant des comportements risqués (comme la négligence financière ou des choix de vie malsains) peut faire face à des difficultés qui découlent directement de ses actions. Ces conséquences sont une forme de punition, car elles résultent de leur propre manque de sagesse.

Isolement Social : La stupidité peut également mener à l'isolement. Les personnes qui prennent des décisions irréfléchies peuvent perdre la confiance de leurs amis et de leur famille, ce qui les laisse seules face à leurs problèmes. Cette solitude peut être perçue comme une punition, car elle découle de leur incapacité à agir avec sagesse.

Apprentissage par la Souffrance : Parfois, les individus doivent faire face à des échecs ou à des souffrances pour apprendre. Cette forme d'apprentissage peut être douloureuse, mais elle est souvent nécessaire pour développer la sagesse. Ainsi, la punition par la bêtise peut être vue comme un moyen d'inciter à la réflexion et à la croissance personnelle.

Réflexion sur la Sagesse

Le contraste entre la sagesse et la stupidité est un thème récurrent dans les Proverbes. La sagesse est souvent présentée comme une voie qui mène à la vie, à la prospérité et à des relations saines. En revanche, la stupidité est associée à la destruction et à la souffrance. En ce sens, le verset nous rappelle l'importance de rechercher la sagesse et d'apprendre des erreurs.


Q2/

Le chapitre 16 du livre des Proverbes regorge de sagesse pratique et de leçons profondes sur la vie, la conduite humaine et la relation avec Dieu. Voici quelques leçons clés que l'on peut tirer de ce chapitre, accompagnées de réflexions sur des versets spécifiques.

### La Souveraineté de Dieu

Un des thèmes centraux de Proverbe 16 est la souveraineté de Dieu sur les plans humains. Le verset 1 déclare : « L'homme propose, mais c'est l'Éternel qui dispose. » Cela nous rappelle que, bien que nous puissions avoir nos propres projets et intentions, c'est finalement Dieu qui guide nos pas. Cette vérité nous incite à faire preuve d'humilité et à reconnaître que nos plans doivent être alignés avec la volonté divine. En acceptant cette réalité, nous pouvons trouver la paix même lorsque nos projets ne se déroulent pas comme prévu.

### La Valeur de la Sagesse

Le verset 16 souligne l'importance de la sagesse : « Quelle est la sagesse ? Elle vaut mieux que l'or ! » Cela met en lumière que la sagesse est un trésor inestimable, bien plus précieux que les richesses matérielles. La sagesse nous aide à prendre des décisions éclairées et à naviguer dans les défis de la vie. En cherchant la sagesse, nous investissons dans notre avenir et dans notre bien-être spirituel. Cela nous pousse à prioriser l'acquisition de connaissances et de discernement plutôt que de nous concentrer uniquement sur des gains matériels.

### La Communication et les Relations

Le verset 24 dit : « Les paroles agréables sont un rayon de miel, douces à l'âme et salutaires au corps. » Ce verset souligne l'impact des mots que nous utilisons dans nos interactions. Des paroles bienveillantes et encourageantes peuvent apporter du réconfort et de la guérison. Cela nous rappelle l'importance de cultiver des relations positives et de choisir nos mots avec soin. En pratiquant une communication constructive, nous pouvons renforcer nos liens avec les autres et créer un environnement harmonieux.

### La Justice et l'Honnêteté

Le verset 11 affirme : « La balance et les poids justes sont à l'Éternel ; tous les poids dans le sac sont son œuvre. » Ce passage met en avant l'importance de l'intégrité et de la justice dans nos affaires. Dieu valorise l'honnêteté et la droiture, et il attend de nous que nous agissions de manière équitable dans nos transactions et nos relations. Cela nous incite à examiner nos propres pratiques et à nous assurer que nous agissons avec équité, tant dans nos affaires personnelles que professionnelles.

### La Confiance en Dieu

Enfin, le verset 3 nous exhorte : « Recommande à l'Éternel tes œuvres, et tes projets réussiront. » Cela nous encourage à confier nos efforts à Dieu. En plaçant notre confiance en lui et en cherchant sa direction, nous pouvons être assurés que nos efforts seront bénis. Cette leçon nous rappelle que la réussite ne dépend pas uniquement de nos compétences ou de notre travail acharné, mais aussi de notre dépendance à Dieu.




## Étude biblique de l’assemblée


Pour répondre aux questions basées sur les paragraphes 10 à 18 des publications mentionnées, nous allons examiner la situation de Paul à Rome, sa manière de prêcher, et les leçons que nous pouvons en tirer.

### 10. Quelle était la situation de Paul à Rome, et qu’a-t-il fait peu après son arrivée ?

À son arrivée à Rome, Paul se trouvait sous la garde d'un soldat, vivant dans un domicile privé. Bien qu'il fût en détention, cela ne l'a pas empêché de continuer sa mission de proclamation du Royaume. Après un court repos, il a convoqué les notables juifs de la ville pour leur parler de sa foi. Cela montre son engagement à partager le message chrétien, même dans des circonstances difficiles. Paul a utilisé cette opportunité pour établir un dialogue avec ses compatriotes, démontrant ainsi sa détermination à prêcher, peu importe les obstacles.

### 11-12. Comment Paul s’y est-il pris pour faire tomber les probables préjugés de ses compatriotes ?

Paul a commencé par se présenter comme un « frère », cherchant à établir un terrain d’entente avec les Juifs. En précisant qu'il n'avait rien fait contre leur peuple ou leurs coutumes, il a cherché à dissiper les préjugés qu'ils pouvaient avoir à son égard. En expliquant qu'il avait été emprisonné non pas à cause de ses actions, mais en raison de l'opposition des Juifs à Jérusalem, il a voulu montrer qu'il n'était pas là pour accuser sa nation, mais pour partager un message d'espoir. Cette approche diplomatique est essentielle dans notre propre témoignage, car elle nous rappelle l'importance de créer des liens et de comprendre les préoccupations des autres avant de partager notre foi.

### 13-14. Comment Paul a-t-il introduit le thème du Royaume, et comment l’imiter ?

Paul a introduit le thème du Royaume en déclarant que c'était en raison de l'espérance d'Israël qu'il portait des chaînes. Cette déclaration a éveillé la curiosité de ses interlocuteurs, car elle touchait à des attentes profondes liées au Messie et à son royaume. Pour imiter Paul, nous pouvons commencer nos conversations sur la foi en posant des questions ou en faisant des affirmations qui suscitent l'intérêt. Par exemple, en partageant des expériences personnelles ou des réflexions sur des sujets spirituels, nous pouvons engager les autres de manière significative. Utiliser des ressources comme des livres sur la prédication peut également nous aider à affiner notre approche.

### 15. Quels points forts distingue-t-on dans la façon de prêcher de Paul ?

Paul a démontré plusieurs points forts dans sa prédication :

Concentration sur le Royaume de Dieu : Il a centré son message sur le royaume, qui est le cœur de l'espérance chrétienne.
Persuasion : Il a cherché à convaincre ses auditeurs, montrant l'importance de la passion et de l'engagement dans notre témoignage.
Raisonnement à partir des Écritures : En utilisant la Loi de Moïse et les Prophètes, il a fondé son message sur des bases scripturaires solides, ce qui est crucial pour établir la crédibilité.
Dévouement : Prêcher toute la journée montre son engagement et sa détermination à partager la bonne nouvelle.

Ces éléments sont des exemples à suivre pour nous, car ils illustrent comment une prédication efficace nécessite à la fois une préparation spirituelle et une passion pour le message.

### 16-18. Pourquoi Paul ne s’est-il pas étonné du peu d’enthousiasme des Juifs de Rome, et comment devrions-nous réagir quand on rejette notre prédication ?

Paul n’a pas été surpris par le manque d’enthousiasme des Juifs, car il connaissait les prophéties qui annonçaient une insensibilité de leur part. Il a cité le prophète Isaïe pour illustrer que leur cœur était devenu insensible, ce qui est une réalité que nous pouvons rencontrer dans notre propre ministère. Lorsque nous faisons face à des rejets, il est important de ne pas le prendre personnellement. Comme Paul, nous devons comprendre que peu de gens trouveront le chemin de la vie, et cela ne doit pas nous décourager. Au contraire, nous devrions nous réjouir lorsque des personnes bien disposées acceptent notre message, car cela témoigne de l'œuvre de Dieu dans leur cœur.

Conclusion

Les leçons tirées de l'expérience de Paul à Rome sont riches et variées. Elles nous enseignent l'importance de l'engagement, de la compréhension des autres, de la persuasion par des bases scripturaires, et de la résilience face au rejet. En suivant l'exemple de Paul, nous pouvons devenir des témoins plus efficaces du Royaume de Dieu, en nous appuyant sur la sagesse et la force que Dieu nous offre.
