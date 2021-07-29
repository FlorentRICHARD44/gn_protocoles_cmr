-- Add Nomemclature type for Visit Session
INSERT INTO ref_nomenclatures.bib_nomenclatures_types (mnemonique, label_default, definition_default, label_fr, source, statut, meta_create_date) VALUES
('CMR_CISTUDE_SESSION','Session','Session pour les CMR Cistude', 'Session','CMR','Validé', now());
-- Add 2 items for tests.
DO
$$
DECLARE
	session_item RECORD;
BEGIN
	SELECT * INTO session_item FROM ref_nomenclatures.bib_nomenclatures_types WHERE mnemonique = 'CMR_CISTUDE_SESSION' ;
	INSERT INTO ref_nomenclatures.t_nomenclatures (id_type, cd_nomenclature, mnemonique, label_default, label_fr, statut, active) VALUES (session_item.id_type, 'CMR_CISTUDE_SESSION_TEST_1', 'CMR_TEST_1', '(TEST) CMR Session 1', '(TEST) CMR Session 1', 'Validé', TRUE), (session_item.id_type, 'CMR_CISTUDE_SESSION_TEST_2', 'CMR_TEST_2', '(TEST) CMR Session 2', '(TEST) CMR Session 2', 'Validé', TRUE);
END$$;


-- View: gn_cmr.v_cmr_sitegroup_observations_test_cmr

-- DROP VIEW gn_cmr.v_cmr_sitegroup_observations_test_cmr;
-- DROP VIEW gn_cmr.v_cmr_sitegroup_observations_test_cmr;
DROP VIEW IF EXISTS gn_cmr.v_cmr_sitegroup_observations_cmr_cistude;
CREATE OR REPLACE VIEW gn_cmr.v_cmr_sitegroup_observations_cmr_cistude
 AS
 WITH visit_observers AS (
         SELECT v_1.id_visit,
            string_agg((r.prenom_role::text || ' '::text) || r.nom_role::text, ', '::text) AS v_observers
           FROM gn_cmr.t_visit v_1
             JOIN gn_cmr.cor_visit_observer vo_1 ON vo_1.id_visit = v_1.id_visit
             JOIN utilisateurs.t_roles r ON r.id_role = vo_1.id_observer
          GROUP BY v_1.id_visit
        )
 SELECT v.date::date AS "visit_date",
    sg.name AS "aire_d_etude",
    s.name AS "piege",
	  s.geom as "geom",
    s.data #>> '{piege_type}'::text[] AS "type_de_piege",
    NULLIF(s.data #>> '{habitat}'::text[], 'null'::text) AS "habitat",
    NULLIF(s.data #>> '{conductivité}'::text[], 'null'::text) AS "conductivite",
    NULLIF((s.data -> 'date_pose'::text)::text, 'null'::text)::date AS "date_de_pose",
    NULLIF((s.data -> 'date_retrait'::text)::text, 'null'::text)::date AS "date_de_retrait",
    v.data #>> '{session}'::text[] AS "session",
    ds.dataset_name AS "jeu_de_donnees",
    vo.v_observers AS "operateurs",
        CASE
            WHEN v.observation IS TRUE THEN 'Oui'::text
            ELSE 'Non'::text
        END AS "observation",
    i.identifier AS "numero_affecte_a_l_animal",
    i.rfid AS "rfid",
    i.marker AS "type_de_marquage",
    i.data #>> '{sexe}'::text[] AS "sexe",
    o.data #>> '{type}'::text[] AS "type_observation",
    o.data #>> '{individual_state}'::text[] AS "etat_individu",
    o.data #>> '{etat_femelle}'::text[] AS "etat_femelle",
    o.data #>> '{developpement_stade}'::text[] AS "stade_de_developpement",
    (o.data #>> '{age}'::text[])::integer AS "nombre_de_stries_de_croissance",
    o.data #>> '{particular_signs}'::text[] AS "signes_particulier",
    (o.data #>> '{poids_g}'::text[])::integer AS "poids_g",
    (o.data #>> '{longueur_dossiere_mm}'::text[])::integer AS "longueur_dossiere_mm",
    (o.data #>> '{largeur_dossiere_mm}'::text[])::integer AS "largeur_dossiere_mm",
    (o.data #>> '{longueur_plastron_mm}'::text[])::integer AS "longueur_plastron_mm",
    (o.data #>> '{largeur_avant_plastron_mm}'::text[])::integer AS "largeur_avant_plastron_mm",
    (o.data #>> '{largeur_arriere_plastron_mm}'::text[])::integer AS "largeur_arriere_plastron_mm",
    o.data #>> '{mesures_complementaire}'::text[] AS "mesures_complementaires",
    NULLIF((o.data -> 'date_capture'::text)::text, 'null'::text)::date AS "date_de_capture",
    NULLIF((o.data -> 'date_relache'::text)::text, 'null'::text)::date AS "date_de_relache",
    o.data #>> '{conditions_manipulation}'::text[] AS "conditions_de_manipulation",
    o.data #>> '{typage_gen_ouinon}'::text[] AS "typage_genetique",
    NULLIF(o.data #>> '{typage_gen_date_prelevement}'::text[], 'null'::text)::date AS "tg_date_prelevement",
    regexp_replace(o.data #>> '{typage_gen_type_prelevement}'::text[], '[\[\]"]'::text, ''::text, 'g'::text) AS "tg_type_prelevement",
    o.data #>> '{typage_gen_analyse_par}'::text[] AS "tg_analyse_par",
    regexp_replace(o.data #>> '{typage_gen_type_analyse}'::text[], '[\[\]"]'::text, ''::text, 'g'::text) AS "tg_type_analyse",
    o.data #>> '{typage_gen_resultat}'::text[] AS "tg_resultat",
    o.data #>> '{analyse_comp_ouinon}'::text[] AS "analyse_complementaire",
    NULLIF((o.data -> 'analyse_comp_date_prelevement'::text)::text, 'null'::text)::date AS "ac_date_prelevement",
    regexp_replace(o.data #>> '{analyse_comp_type_prelevement}'::text[], '[\[\]"]'::text, ''::text, 'g'::text) AS "ac_type_prelevement",
    o.data #>> '{analyse_comp_type_prelevement_autre}'::text[] AS "ac_type_autre_prelevement",
    o.data #>> '{analyse_comp_objectif}'::text[] AS "ac_objectif",
    o.data #>> '{analyse_comp_analyse_par}'::text[] AS "ac_analyse_par",
    regexp_replace(o.data #>> '{analyse_comp_type_analyse}'::text[], '[\[\]"]'::text, ''::text, 'g'::text) AS "ac_type",
    o.data #>> '{analyse_comp_resultats}'::text[] AS "acresultat",
	sg.id_sitegroup as "id_sitegroup"
   FROM gn_cmr.t_site s
     LEFT JOIN gn_cmr.t_sitegroup sg ON sg.id_sitegroup = s.id_sitegroup
     LEFT JOIN gn_cmr.t_visit v ON v.id_site = s.id_site
     LEFT JOIN visit_observers vo ON vo.id_visit = v.id_visit
     LEFT JOIN gn_meta.t_datasets ds ON ds.id_dataset = v.id_dataset
     LEFT JOIN gn_cmr.t_observation o ON o.id_visit = v.id_visit
     LEFT JOIN gn_cmr.t_individual i ON i.id_individual = o.id_individual
  ORDER BY v.date, i.identifier;


ALTER TABLE gn_cmr.v_cmr_sitegroup_observations_cmr_cistude
    OWNER TO geonatadmin;


CREATE OR REPLACE VIEW gn_cmr.v_synthese_cmr_cistude
 AS
WITH source AS (
  SELECT t_sources.id_source
    FROM gn_synthese.t_sources
  WHERE t_sources.name_source::text = concat('CMR_', upper('cmr_cistude'::text))
  LIMIT 1
),/*last_observation_by_individual AS (
  select id_individual, id_observation, id_visit from (
    SELECT i.id_individual, o.id_observation, v.id_visit, v.date,
    row_number() over (partition by i.id_individual order by v.date desc) as row_num
    FROM gn_cmr.t_visit v
    INNER JOIN gn_cmr.t_observation o
      ON o.id_visit = v.id_visit
    INNER JOIN gn_cmr.t_individual i
      ON o.id_individual = i.id_individual
    ORDER BY i.id_individual desc
  ) as t
	WHERE row_num = 1
 ),*/ observers AS (
  SELECT array_agg(r.id_role) AS ids_observers,
    string_agg(concat(r.nom_role, ' ', r.prenom_role), ' ; '::text) AS observers,
    cvo.id_visit
  FROM gn_cmr.cor_visit_observer cvo
    JOIN utilisateurs.t_roles r ON r.id_role = cvo.id_observer
  GROUP BY cvo.id_visit
)
 SELECT o.uuid_observation AS unique_id_sinp,
 	s.uuid_site AS unique_id_sinp_grp,
 	source.id_source,
    o.id_observation AS entity_source_pk_value,
	v.id_dataset,
    ref_nomenclatures.get_id_nomenclature('NAT_OBJ_GEO'::character varying, 'St'::character varying) AS id_nomenclature_geo_object_nature,
    null as id_nomenclature_grp_typ,
	null as id_nomenclature_tech_collect_campanule,
    ref_nomenclatures.get_id_nomenclature('IND'::character varying, 'OBJ_DENBR'::character varying) AS id_nomenclature_obj_count,
    ref_nomenclatures.get_id_nomenclature('TYP_DENBR'::character varying, 'Es'::character varying) AS id_nomenclature_type_count,
    ref_nomenclatures.get_id_nomenclature('STATUT_OBS'::character varying, 'Pr'::character varying) AS id_nomenclature_observation_status,
    ref_nomenclatures.get_id_nomenclature('STATUT_SOURCE'::character varying, 'Te'::character varying) AS id_nomenclature_source_status,
    ref_nomenclatures.get_id_nomenclature('TYP_INF_GEO'::character varying, '1'::character varying) AS id_nomenclature_info_geo_type,
    1 AS count_min,
    1 AS count_max,
    o.id_observation,
    t.cd_nom,
    t.nom_complet AS nom_cite,
    alt.altitude_min,
    alt.altitude_max,
    s.geom as the_geom_4326,
    s.geom as the_geom_point,
	ST_Transform(s.geom, gn_commons.get_default_parameter('local_srid',NULL)::integer ) AS the_geom_local,
    v.date as date_min,
    v.date as date_max,
    obs.observers,
    o.id_digitiser,
    s.id_module,
    s.comments AS comment_context,
    o.comments AS comment_description,
    obs.ids_observers,
    v.id_site,
    v.id_visit
   FROM gn_cmr.t_individual i
   INNER JOIN gn_cmr.t_observation o ON o.id_individual = i.id_individual
   INNER JOIN gn_cmr.t_visit v ON o.id_visit = v.id_visit
   INNER JOIN gn_cmr.t_site s ON s.id_site = v.id_site
   --INNER JOIN gn_cmr.t_observation o ON o.id_observation = l.id_observation
   JOIN taxonomie.taxref t ON t.cd_nom = 77396
   JOIN source ON true
   JOIN observers obs ON obs.id_visit = v.id_visit
   LEFT JOIN LATERAL ref_geo.fct_get_altitude_intersection(s.geom) alt(altitude_min, altitude_max) ON true
   
