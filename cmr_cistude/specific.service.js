/**
 * Fonction d'initialisation du formulaire de site group
 * @param FormGroup form  Le formulaire de sitegroup
 */
 export function initSitegroup(form) {
  return {};
}

/**
 * Fonction d'initialisation du formulaire de site.
 * @param FormGroup form le formulaire de site 
 * @param SiteGroup sitegroup le sitegroup pour lequel est créé le site.
 */
export function initSite(form, sitegroup) {
  let piege = form.get('piege_type');
  let date_pose = form.get('date_pose');
  let date_retrait = form.get('date_retrait');
  // Active/Désactive les dates en fonction du type de piège.
  piege.valueChanges.subscribe( value => {
    if (["Verveux simple","Verveux double","Nasse","Cage-piège"].indexOf(value) > -1) {
      date_pose.enable();
      date_retrait.enable();
    } else {
      date_pose.disable();
      date_pose.setValue(undefined);
      date_retrait.disable();
      date_retrait.setValue(undefined);
    }
  });
  return {};
}

/**
 * Fonction d'initialisation du formulaire de visite.
 * @param FormGroup form le formulaire de visite.
 * @param Site site le site pour lequel la visite est créée. Reste à undefined si la visite est créée en lot.
 */
export function initVisit(form, site) {
  return {
    date: (new Date()).toISOString(),
    id_dataset: null
  };
}

/**
 * Fonction d'initialisation du formulaire d'observation
 * @param FormGroup form Le premier formulaire
 * @param Array formGroups la liste des formulaires en group (collapse)
 * @param Visit visit la visite pour laquelle est créée l'observation.
 * @param Individual individual  l'individu observé
 * @param Observation observation  dernière observation de l'individu 
 */
export function initObservation(form, formGroups, visit, individual, lastObservation) {
  if (individual.sexe != 'Femelle') {
    form.get('etat_femelle').disable();
  }
  for (let fg of formGroups) {
    if (fg['form'].get('analyse_comp_type_prelevement')) {
      fg['form'].get('analyse_comp_type_prelevement').valueChanges.subscribe(
        value => {
          if (!value || value.indexOf('Autre') == -1) {
            fg['form'].get('analyse_comp_type_prelevement_autre').disable();
          } else {
            fg['form'].get('analyse_comp_type_prelevement_autre').enable();
          }
        }
      );
    }
  }
  return {
    date_capture: visit.date,
    date_relache: visit.date,
    typage_gen_date_prelevement: visit.date,
    analyse_comp_date_prelevement: visit.date,
    typage_gen_ouinon: 'Non',
    analyse_comp_ouinon: 'Non',
    developpement_stade: lastObservation.developpement_stade,
    age: lastObservation.age,
    particular_signs: lastObservation.particular_signs,
    longueur_dossiere_mm: lastObservation.longueur_dossiere_mm
  };
}

/**
 * Fonction d'initialisation du formulaire d'individu'
 * @param FormGroup form  Le formulaire de l'individu
 */
export function initIndividual(form) {
    return {};
}

/**
 * Fonction de controle du submit du formulaire d'individu'
 * @param Array individu initialisé
 * @param Array individu modifié
 */
export function onSubmitIndividual(initIndividual, updateIndividual) {
  if(initIndividual.sexe != updateIndividual.sexe){
    return {
      status : "warning",
      message: "Voulez-vous vraiment changer le sexe de cet individu ?"
    };
  }else{
    return {
      status : "success",
      message: ""
    };
  }
}

/**
 * Fonction permettant de filtrer les sites à afficher sur la carte
 * @param Array sites 
 */
export function filterMapSite(sites){
  //return sites
  return sites.map(feature => {
    feature["disabled"] = !feature.properties.date_retrait ? false : true
    return feature
  })
  //return sites.filter(feature => !feature.properties.date_retrait)
} 


/**
 * Fonction permettant de filtrer les sites à afficher sur la carte
 * @param Site site 
 */
 export function initCopySite(site){
  delete site.date_pose
  delete site.date_retrait
  return site
} 


