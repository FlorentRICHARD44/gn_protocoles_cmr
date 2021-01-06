CMR Cistude
-----------

Module CMR de la Société Herpétologique de France pour la Cistude d'Europe.

Elements spécifiques
====================

Description générique
'''''''''''''''''''''

- Utilisation de la popup d'avertissement à l'entrée du sous-module
- Utilisation des sitegroup

sitegroup
'''''''''

- Nommé en "Aire d'étude"
- Seulement en Polygon
- Calcul automatique des communes et département
- Création de visit en lot pour tous les sites

site
''''

- Nommé en "Piège"
- Représente des pièges ou bien des captures manuelles
- seulement en Point

visit
'''''

- Un champ "session", qui utilise la nomenclature "Session" (CMR_CISTUDE_SESSION). Un minimum d'utilisateurs doit donc avoir accès à l'administration de la nomenclature pour ajouter des sessions.


individu
''''''''

- Le sexe est renseigné sur l'individu. Si non déterminé pendant la capture, le renseigner à "Indéterminé", puis si déterminé lors d'une recapture suivante, il faut éditer l'individu.

observation
'''''''''''

- Utilisation de plusieurs groupes de champs, dont certains avec des champs Oui/Non (pour les analyses).


Initialisation SQL
==================

Le fichier d'Initialisation SQL contient:

- ajout d'une nomenclature "Session" (pour les visites), avec 2 valeurs de test pré-définies
- ajout de la vue pour lister les observations. Elle est nommée pour un module "cmr_cistude"; pensez donc à renommer cette vue si vous souhaitez donner un autre code au module.
