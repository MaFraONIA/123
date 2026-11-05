@set T0 = 2026-06-30
 
with
w_base as 
(
select 
              date_arrete,
              flag_exclusion_rafras,
              case when company='LBP' and type_contrat_libelle like 'CCP%' then 0 
                            else flag_exclusion_rafras end as flag_exclusion_rafras_bis,
              flag_contrepartie_intra_groupe_avant_crm ,
              company,
              contrepartie_code_avant_crm_2, 
              contrepartie_libelle_avant_crm_2, 
              tiers_principal_avant_crm_etablissement, 
              tiers_principal_avant_crm_libelle_2,
              tiers_principal_avant_crm_code_tiers_2,
              contrepartie_maison_mere_avant_crm_granrisk_company,
              contrepartie_maison_mere_code_avant_crm_granrisk_2,
              contrepartie_maison_mere_libelle_avant_crm_granrisk_2,
              contrepartie_siren_avant_crm_2,
              Flag_credit_export,
              contrepartie_secteur_rafras_avant_crm,
              contrepartie_secteur_rafras_avant_crm_harmonise,
             contrepartie_secteur_rafras_libelle_avant_crm_harmonise,
              appetence_sectorielle,
              appetence_sectorielle_harmonise,
              categorie_produit, 
              type_balois_produit_rgpt,
              categorie_instrument, 
              type_balois_contrepartie_avant_crm,
              contrepartie_pays_rafras_brut_avant_crm,
              contrepartie_pays_rafras_avant_crm,
              contrepartie_pays_rafras_avant_crm_harmonise,
              appetence_geographique,
              appetence_geographique_harmonise,
              contrepartie_pays_rafras_libelle_avant_crm_harmonise,
              Flag_economie_avancee_sur_pays_harmonise,
              flag_zone_uem_sur_pays_harmonise,
              Flag_g7_sur_pays_harmonise,
              type_contrat_libelle ,
              flag_contrepartie_defaut_avant_crm,
              flag_chambre_compensation_avant_crm,
              flag_banque_de_france_avant_crm,
              financement_investissement,
              direction_affectation_cp,
              centre_profit,
              contrepartie_note_baloise,
              contrepartie_code_naf_avant_crm,
              contrepartie_libelle_naf_avant_crm,
              contrepartie_secteur_rafras_brut_avant_crm,
              flag_tiers_principal_nouveau,
			  type_tiers_principal_avant_crm_exclu_visu,
			  --
			  tiers_regroupe_avant_crm_etablissement,
			  case when tiers_principal_avant_crm_code_tiers_2 = 'CONTREPARTIE AGREGEE' then 'CONTREPARTIE AGREGEE' else  tiers_regroupe_avant_crm_code end as tiers_regroupe_avant_crm_code_2,
			  case when tiers_principal_avant_crm_code_tiers_2 = 'CONTREPARTIE AGREGEE' then 'CONTREPARTIE AGREGEE' else  tiers_regroupe_avant_crm_libelle end as tiers_regroupe_avant_crm_libelle_2,
			  tiers_regroupe_avant_crm_secteur_eco,
			  tiers_regroupe_groupement_secteur_eco,
			  --
			  contrepartie_secteur_eco_avant_crm_harmonise,
			  substr(contrepartie_secteur_rafras_avant_crm_harmonise,1,2) as num_secteur_harmonise,
              sum(ead_pre_ccf) as ead_pre_ccf,
              sum(ead_pre_ccf_corep) as ead_pre_ccf_corep,
			  0 as expo_cnp_brute,
			  0 as expo_cnp_ponderee
from db_prod_ri4.tbl_detaille_groupe_rafras
where date_arrete = '${T0}' 
group by 
              date_arrete,
              flag_exclusion_rafras,
              case when company='LBP' and type_contrat_libelle like 'CCP%' then 0 
                            else flag_exclusion_rafras end,
              flag_contrepartie_intra_groupe_avant_crm ,
              company,
              contrepartie_code_avant_crm_2, 
              contrepartie_libelle_avant_crm_2, 
              tiers_principal_avant_crm_etablissement, 
              tiers_principal_avant_crm_libelle_2,
              tiers_principal_avant_crm_code_tiers_2,
              contrepartie_maison_mere_avant_crm_granrisk_company,
              contrepartie_maison_mere_code_avant_crm_granrisk_2,
              contrepartie_maison_mere_libelle_avant_crm_granrisk_2,
              contrepartie_siren_avant_crm_2,
              Flag_credit_export,
              contrepartie_secteur_rafras_avant_crm,
              contrepartie_secteur_rafras_avant_crm_harmonise,
              contrepartie_secteur_rafras_libelle_avant_crm_harmonise,
              appetence_sectorielle,
              appetence_sectorielle_harmonise,
              categorie_produit, 
              type_balois_produit_rgpt,
              categorie_instrument, 
              type_balois_contrepartie_avant_crm,
              contrepartie_pays_rafras_brut_avant_crm,
              contrepartie_pays_rafras_avant_crm,
              contrepartie_pays_rafras_avant_crm_harmonise,
              appetence_geographique,
              appetence_geographique_harmonise,
              contrepartie_pays_rafras_libelle_avant_crm_harmonise,
              Flag_economie_avancee_sur_pays_harmonise,
              flag_zone_uem_sur_pays_harmonise,
              Flag_g7_sur_pays_harmonise,
              type_contrat_libelle ,
              flag_contrepartie_defaut_avant_crm,
              flag_chambre_compensation_avant_crm,
              flag_banque_de_france_avant_crm,
              financement_investissement,
              direction_affectation_cp,
              centre_profit,
              contrepartie_note_baloise,
              contrepartie_code_naf_avant_crm,
              contrepartie_libelle_naf_avant_crm,
              contrepartie_secteur_rafras_brut_avant_crm,
              flag_tiers_principal_nouveau,
			  type_tiers_principal_avant_crm_exclu_visu,
			  --
			  tiers_regroupe_avant_crm_etablissement,
			  case when tiers_principal_avant_crm_code_tiers_2 = 'CONTREPARTIE AGREGEE' then 'CONTREPARTIE AGREGEE' else  tiers_regroupe_avant_crm_code end ,
			  case when tiers_principal_avant_crm_code_tiers_2 = 'CONTREPARTIE AGREGEE' then 'CONTREPARTIE AGREGEE' else  tiers_regroupe_avant_crm_libelle end ,
			  tiers_regroupe_avant_crm_secteur_eco,
			  tiers_regroupe_groupement_secteur_eco,
			  -- 
			  contrepartie_secteur_eco_avant_crm_harmonise,
              substr(contrepartie_secteur_rafras_avant_crm_harmonise,1,2)
)
,
w_cnp as 
(
select 
              date_arrete,
              0 as flag_exclusion_rafras,
              0 as flag_exclusion_rafras_bis,
              flag_intragroupe as flag_contrepartie_intra_groupe_avant_crm ,
              'CNP' as company,
              num_cdc as contrepartie_code_avant_crm_2, 
              libelle_cdc as contrepartie_libelle_avant_crm_2, 
              -- tiers_principal_avant_crm_etablissement, 
              libelle_cdc as tiers_principal_avant_crm_libelle_2,
              -- num_cdc as tiers_principal_avant_crm_code_tiers_2,
              null as contrepartie_maison_mere_avant_crm_granrisk_company,
              null as contrepartie_maison_mere_code_avant_crm_granrisk_2,
              null as contrepartie_maison_mere_libelle_avant_crm_granrisk_2,
              null as contrepartie_siren_avant_crm_2,
              0 as Flag_credit_export,
              secteur_rafras as contrepartie_secteur_rafras_avant_crm,
              secteur_rafras as contrepartie_secteur_rafras_avant_crm_harmonise,
              secteur_rafras_libelle as contrepartie_secteur_rafras_libelle_avant_crm_harmonise,
              null as appetence_sectorielle,
              null as appetence_sectorielle_harmonise,
              null as categorie_produit, 
              null as type_balois_produit_rgpt,
              null as categorie_instrument, 
              null as type_balois_contrepartie_avant_crm,
              pays_rafras as contrepartie_pays_rafras_brut_avant_crm,
              pays_rafras as contrepartie_pays_rafras_avant_crm,
              pays_rafras as contrepartie_pays_rafras_avant_crm_harmonise,
              null as appetence_geographique,
              null as appetence_geographique_harmonise,
              pays_rafras_libelle as contrepartie_pays_rafras_libelle_avant_crm_harmonise,
              null as type_contrat_libelle ,
              0 as flag_contrepartie_defaut_avant_crm,
              0 as flag_chambre_compensation_avant_crm,
              null flag_banque_de_france_avant_crm,
              null as financement_investissement,
              'CBP' as direction_affectation_cp,
              null as centre_profit,
              null as contrepartie_code_naf_avant_crm,
              null as contrepartie_libelle_naf_avant_crm,
              secteur_rafras as contrepartie_secteur_rafras_brut_avant_crm,
              0 as flag_tiers_principal_nouveau,
			  null as type_tiers_principal_avant_crm_exclu_visu,
			  --
			  -- null as tiers_regroupe_avant_crm_libelle,
			  -- null as tiers_regroupe_avant_crm_secteur_eco,
			  -- null as tiers_regroupe_groupement_secteur_eco,
			  --
			  secteur_eco as contrepartie_secteur_eco_avant_crm_harmonise,
			  substr(secteur_rafras,1,2) as num_secteur_harmonise,
              expositions_brute_en_euros as ead_pre_ccf,
              expositions_brute_en_euros as ead_pre_ccf_corep,
			  expositions_brute_en_euros as expo_cnp_brute,
			  expositions_ponderees_m_euros * 1000000  as expo_cnp_ponderee
from db_prod_ri4_donnees_excels.template_cnp
where date_arrete = '${T0}' 
)
,
-- Besoin de recuperer les flag g7 uem ... des pays pour CNP
-- Le fichier CNP contient le code IS02
w_pays_conso as 
(
select  p.* ,
		row_number() over (partition by code_iso_2_sortie order by dt_deb_val desc) as num_ligne
from db_prod_ri2.sat_pays_caracteristiques_consolide p
)
,
w_pays_conso_2 as 
(
select  * 
from w_pays_conso
where num_ligne=1 
)
,
-- Fichier Excel n a pas les notes baloises
-- On les recupere de tbl_detaille_groupe_rafras
w_notes_baloises as 
(
select distinct contrepartie_code_avant_crm, contrepartie_note_baloise 
from db_prod_ri4.tbl_detaille_groupe_rafras 
where date_arrete='${T0}' 
	and company in ('SG_SOCIAL','FE') 
	and contrepartie_code_avant_crm is not null 
	and contrepartie_note_baloise  is not null 
)
,
-- Fichier Excel n a pas les tiers principaux
-- On les recupere de tbl_detaille_groupe_rafras
w_princip as 
(
select distinct contrepartie_code_avant_crm, 
				tiers_principal_avant_crm_etablissement,
				tiers_principal_avant_crm_code_tiers
from db_prod_ri4.tbl_detaille_groupe_rafras 
where date_arrete='${T0}' 
	and company in ('SG_SOCIAL','FE') 
	and contrepartie_code_avant_crm is not null 
	and tiers_principal_avant_crm_etablissement is not null
	and tiers_principal_avant_crm_code_tiers is not null
)
,	
-- Fichier Excel n a pas les champ tiers_regroupe_xxx
-- On les recupere de tbl_detaille_groupe_rafras
w_regroup as 
(
select distinct tiers_principal_avant_crm_etablissement, 
				tiers_principal_avant_crm_code_tiers,
				tiers_regroupe_avant_crm_etablissement,
				tiers_regroupe_avant_crm_code,
				tiers_regroupe_avant_crm_libelle,
				tiers_regroupe_avant_crm_secteur_eco,
				tiers_regroupe_groupement_secteur_eco
from db_prod_ri4.tbl_detaille_groupe_rafras 
where date_arrete='${T0}' 	
and tiers_principal_avant_crm_etablissement is not null
and tiers_principal_avant_crm_code_tiers is not null
)
,
-- ajout dans l extraction CNP les indicaturs vus au dessus
w_cnp_2 as 
(
select 	c.*,
        p.flag_economie_avancee as Flag_economie_avancee_sur_pays_harmonise,
        p.flag_zone_euro  as flag_zone_uem_sur_pays_harmonise,
        p.flag_g7  as Flag_g7_sur_pays_harmonise,
        n.contrepartie_note_baloise as contrepartie_note_baloise,
		r.tiers_principal_avant_crm_etablissement,
		r.tiers_principal_avant_crm_code_tiers as tiers_principal_avant_crm_code_tiers_2
from w_cnp c 
left join w_pays_conso_2 p
	on c.contrepartie_pays_rafras_avant_crm_harmonise = p.code_iso_2_sortie
left join w_notes_baloises n
	on regexp_replace(c.contrepartie_code_avant_crm_2, '^0+', '') = regexp_replace(n.contrepartie_code_avant_crm, '^0+', '')
left join w_princip r
	on regexp_replace(c.contrepartie_code_avant_crm_2, '^0+', '') = regexp_replace(r.contrepartie_code_avant_crm, '^0+', '')
)
,
w_cnp_3 as 
(
select c.*,
		r.tiers_regroupe_avant_crm_etablissement,
		r.tiers_regroupe_avant_crm_code,
		r.tiers_regroupe_avant_crm_libelle,
		r.tiers_regroupe_avant_crm_secteur_eco,
		r.tiers_regroupe_groupement_secteur_eco
from w_cnp_2 c 
left join w_regroup r
on 	c.tiers_principal_avant_crm_etablissement = r.tiers_principal_avant_crm_etablissement
	and c.tiers_principal_avant_crm_code_tiers_2 = r.tiers_principal_avant_crm_code_tiers
)
,
-- pour pouvoir faire union all
-- les colonnes de cnp doivent être dans le meme ordre que w_base
w_cnp_4 as 
(
select 
              date_arrete,
              flag_exclusion_rafras,
              flag_exclusion_rafras_bis,
              flag_contrepartie_intra_groupe_avant_crm ,
              company,
              contrepartie_code_avant_crm_2, 
              contrepartie_libelle_avant_crm_2, 
              tiers_principal_avant_crm_etablissement, 
              tiers_principal_avant_crm_libelle_2,
              tiers_principal_avant_crm_code_tiers_2,
              contrepartie_maison_mere_avant_crm_granrisk_company,
              contrepartie_maison_mere_code_avant_crm_granrisk_2,
              contrepartie_maison_mere_libelle_avant_crm_granrisk_2,
              contrepartie_siren_avant_crm_2,
              Flag_credit_export,
              contrepartie_secteur_rafras_avant_crm,
              contrepartie_secteur_rafras_avant_crm_harmonise,
              contrepartie_secteur_rafras_libelle_avant_crm_harmonise,
              appetence_sectorielle,
              appetence_sectorielle_harmonise,
              categorie_produit, 
              type_balois_produit_rgpt,
              categorie_instrument, 
              type_balois_contrepartie_avant_crm,
              contrepartie_pays_rafras_brut_avant_crm,
              contrepartie_pays_rafras_avant_crm,
              contrepartie_pays_rafras_avant_crm_harmonise,
              appetence_geographique,
              appetence_geographique_harmonise,
              contrepartie_pays_rafras_libelle_avant_crm_harmonise,
              Flag_economie_avancee_sur_pays_harmonise,
              flag_zone_uem_sur_pays_harmonise,
              Flag_g7_sur_pays_harmonise,
              type_contrat_libelle ,
              flag_contrepartie_defaut_avant_crm,
              flag_chambre_compensation_avant_crm,
              flag_banque_de_france_avant_crm,
              financement_investissement,
              direction_affectation_cp,
              centre_profit,
              contrepartie_note_baloise,
              contrepartie_code_naf_avant_crm,
              contrepartie_libelle_naf_avant_crm,
              contrepartie_secteur_rafras_brut_avant_crm,
              flag_tiers_principal_nouveau,
			  type_tiers_principal_avant_crm_exclu_visu,
			  --
			  tiers_regroupe_avant_crm_etablissement,
			  tiers_regroupe_avant_crm_code,
			  tiers_regroupe_avant_crm_libelle,
			  tiers_regroupe_avant_crm_secteur_eco,
			  tiers_regroupe_groupement_secteur_eco,
			  --
			  contrepartie_secteur_eco_avant_crm_harmonise,
			  num_secteur_harmonise,
              ead_pre_ccf,
              ead_pre_ccf_corep,
			  expo_cnp_brute,
			  expo_cnp_ponderee
from w_cnp_3
)
,
w_tout as 
(
select * from w_base
union all
select * from w_cnp_4
)
,
w_tout_2 as 
(
select t.* ,
		case when flag_exclusion_rafras_bis = 1 or flag_contrepartie_intra_groupe_avant_crm = 1 or Flag_credit_export = 1 
			     or financement_investissement not in ('Investissement','Financement')
				then 1 else 0 end as flag_exclusion_general,
		case when Flag_economie_avancee_sur_pays_harmonise <> '1' and contrepartie_pays_rafras_avant_crm_harmonise <> 'INT' 
				then 1 else 0 end as flag_reste_monde,
		case when tiers_regroupe_groupement_secteur_eco in ('Souverains hors France et hors Supra', 
															'Financiers',
															'Collectivités locales et assimilés'
															)
															then tiers_regroupe_groupement_secteur_eco
			when tiers_regroupe_groupement_secteur_eco in ('Corporate','Entreprises Secteur Public')
					and contrepartie_secteur_eco_avant_crm_harmonise not in
								(
								'Banque de France',
								'Chambre de compensation',
								'Souverains : Assimilés Souverains',
								'Souverains : Autre Souverains',
								'Souverains : Etat France',
								'Souverains : Supra',
								'Secteur financier : Assurances',
								'Secteur financier : Banques & services financiers',
								"Secteur financier : Fonds et véhicules d'investissement",
								'Organismes de logement social (OLS)',
								'Collectivités locales et assimilés',
								'Autres'
								)
															then tiers_regroupe_groupement_secteur_eco
															else 'Autres' end as tiers_regroupe_groupement_secteur_eco_bis
from w_tout t
)
-- TOP nominal groupe general
,
w_top_nominal_groupe as 
(
select  
		tiers_regroupe_avant_crm_etablissement,
		tiers_regroupe_avant_crm_code,
		tiers_regroupe_groupement_secteur_eco_bis,
		sum(ead_pre_ccf_corep) as ead_pre_ccf_corep
from w_tout_2
where flag_exclusion_general =0 
		and company not in  ('SG_SOCIAL','FE')
		and type_tiers_principal_avant_crm_exclu_visu <> 'MON1_CONSO'
		and tiers_regroupe_avant_crm_etablissement is not null
		and tiers_regroupe_avant_crm_code is not null
		and tiers_regroupe_groupement_secteur_eco_bis is not null
group by 
		tiers_regroupe_avant_crm_etablissement,
		tiers_regroupe_avant_crm_code,
		tiers_regroupe_groupement_secteur_eco_bis
)
,
w_top_nominal_groupe_2 as 
(
select t.*,
		row_number() over (partition by tiers_regroupe_groupement_secteur_eco_bis order by ead_pre_ccf_corep desc) as rang_top_nominal_groupe
from w_top_nominal_groupe t
)
,
w_tout_3 as 
(
select t.*,
		nvl(n.rang_top_nominal_groupe,999999999) as rang_top_nominal_groupe
from w_tout_2 t left join w_top_nominal_groupe_2 n
on t.tiers_regroupe_avant_crm_etablissement= n.tiers_regroupe_avant_crm_etablissement
and t.tiers_regroupe_avant_crm_code = n.tiers_regroupe_avant_crm_code	
and t.tiers_regroupe_groupement_secteur_eco_bis=n.tiers_regroupe_groupement_secteur_eco_bis	
)
,
-- TOP nominal groupe par company
,
w_top_nominal_company as 
(
select  
		company,
		tiers_regroupe_avant_crm_etablissement,
		tiers_regroupe_avant_crm_code,
		tiers_regroupe_groupement_secteur_eco_bis,
		sum(ead_pre_ccf_corep) as ead_pre_ccf_corep
from w_tout_2
where flag_exclusion_general =0 
		and company not in  ('SG_SOCIAL','FE')
		and type_tiers_principal_avant_crm_exclu_visu <> 'MON1_CONSO'
		and tiers_regroupe_avant_crm_etablissement is not null
		and tiers_regroupe_avant_crm_code is not null
		and tiers_regroupe_groupement_secteur_eco_bis is not null
group by 
		company,
		tiers_regroupe_avant_crm_etablissement,
		tiers_regroupe_avant_crm_code,
		tiers_regroupe_groupement_secteur_eco_bis
)
,
w_top_nominal_company_2 as 
(
select t.*,
		row_number() over (partition by company, tiers_regroupe_groupement_secteur_eco_bis order by ead_pre_ccf_corep desc) as rang_top_nominal_company
from w_top_nominal_company t
)
,
w_tout_4 as 
(
select t.*,
		nvl(n.rang_top_nominal_company,999999999) as rang_top_nominal_company
from w_tout_3 t left join w_top_nominal_company_2 n
on  t.company = n.company
and t.tiers_regroupe_avant_crm_etablissement= n.tiers_regroupe_avant_crm_etablissement
and t.tiers_regroupe_avant_crm_code = n.tiers_regroupe_avant_crm_code	
and t.tiers_regroupe_groupement_secteur_eco_bis=n.tiers_regroupe_groupement_secteur_eco_bis	
)
select * 
from w_tout_4


-- TOP nominal défaut
,
w_top_nominal_defaut as
(
select
        flag_contrepartie_defaut_avant_crm,
        tiers_regroupe_avant_crm_etablissement,
        tiers_regroupe_avant_crm_code,
        tiers_regroupe_groupement_secteur_eco_bis,
        sum(ead_pre_ccf_corep) as ead_pre_ccf_corep
from w_tout_2
where flag_exclusion_general = 0
        and type_tiers_principal_avant_crm_exclu_visu <> 'MON1_CONSO'
        and tiers_regroupe_avant_crm_etablissement is not null
        and tiers_regroupe_avant_crm_code is not null
        and tiers_regroupe_groupement_secteur_eco_bis is not null
        and flag_contrepartie_defaut_avant_crm is not null
group by
        flag_contrepartie_defaut_avant_crm,
        tiers_regroupe_avant_crm_etablissement,
        tiers_regroupe_avant_crm_code,
        tiers_regroupe_groupement_secteur_eco_bis
)
,
w_top_nominal_defaut_2 as
(
select
        t.*,
        row_number() over (
                partition by flag_contrepartie_defaut_avant_crm,
                             tiers_regroupe_groupement_secteur_eco_bis
                order by ead_pre_ccf_corep desc
        ) as rang_top_nominal_defaut
from w_top_nominal_defaut t
)
,
w_tout_4 as
(
select
        t.*,
        nvl(n.rang_top_nominal_defaut,999999999) as rang_top_nominal_defaut
from w_tout_3 t
left join w_top_nominal_defaut_2 n
on  t.flag_contrepartie_defaut_avant_crm = n.flag_contrepartie_defaut_avant_crm
and t.tiers_regroupe_avant_crm_etablissement = n.tiers_regroupe_avant_crm_etablissement
and t.tiers_regroupe_avant_crm_code = n.tiers_regroupe_avant_crm_code
and t.tiers_regroupe_groupement_secteur_eco_bis = n.tiers_regroupe_groupement_secteur_eco_bis
)
 
 