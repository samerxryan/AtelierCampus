# Résultats des tests — AtelierCampus Partie 2

**Environnement :** Windows 11, Microsoft OpenJDK 17.0.21, Maven 3.9.14, Apache Tomcat 10.1.61, H2 2.3.232. Tests de sécurité exécutés uniquement contre `http://localhost:8080/AtelierCampus`. Audit rejoué le 17 novembre 2026 (heure de Tunis).

Les 30 tests Maven (24 tests conservés de Partie 1 et 6 tests JDBC métier/intégration) ont réussi. Les scénarios Web ont également été exécutés sur Tomcat avec `scripts/verification-locale.ps1`; la persistance a été contrôlée après un arrêt et redémarrage réel de Tomcat avec `scripts/verification-redemarrage.ps1`.

| ID | Objectif | Conditions et procédure | Résultat attendu | Résultat observé | Statut | Capture |
|---|---|---|---|---|---|---|
| T01 | Connexion étudiant | Compte de démonstration, formulaire local | Session étudiant ouverte | Redirection vers Mes inscriptions | RÉUSSI | `03_authentification/01_connexion.png`, `05_inscriptions/01_mes_inscriptions.png` |
| T02 | Connexion gestionnaire | Compte gestionnaire de développement | Tableau de gestion accessible | Tableau affiché | RÉUSSI | `06_gestionnaire/01_tableau_gestionnaire.png` |
| T03 | Identifiants invalides | Adresse absente et mot de passe incorrect | Message d’erreur, aucune session | Message « invalide » observé | RÉUSSI | Aucun (test HTTP automatisé) |
| T04 | Catalogue public | GET sans session | Catalogue visible | HTTP 200 et quatre ateliers | RÉUSSI | `04_catalogue/01_catalogue_public.png` |
| T05 | Recherche par titre | Recherche « Forensique » | Atelier correspondant uniquement | Résultat attendu observé | RÉUSSI | Aucun (test HTTP automatisé) |
| T06 | Détail atelier | Consultation des ateliers #1, #3 et #4 | Date, capacité et disponibilité affichées | Détail disponible, complet et commencé affiché | RÉUSSI | `04_catalogue/02_atelier_complet.png`, `04_catalogue/03_atelier_commence.png` |
| T07 | Inscription valide | Étudiant connecté, atelier #1 | Confirmation et place consommée | Statut CONFIRMEE et places mises à jour | RÉUSSI | `05_inscriptions/02_inscription_confirmee.png`, `05_inscriptions/03_places_actualisees.png` |
| T08 | Persistance après redémarrage | Inscription annulée, arrêt puis redémarrage Tomcat | Enregistrement toujours présent | Atelier et statut ANNULEE retrouvés après le redémarrage réel | RÉUSSI | Aucun (preuve de réponse dans le script; capture navigateur non disponible) |
| T09 | Doublon | Nouvelle demande de la même paire | Demande refusée | Exception métier attendue; unicité DB active | RÉUSSI | Aucun (JUnit) |
| T10 | Atelier complet | Demande sur une capacité déjà atteinte | Demande refusée | Refus métier observé | RÉUSSI | `04_catalogue/02_atelier_complet.png`, JUnit |
| T11 | Atelier commencé | Demande après l’heure de début | Demande refusée | Refus métier observé | RÉUSSI | `04_catalogue/03_atelier_commence.png`, JUnit |
| T12 | Annulation | Étudiant annule sa confirmation | Statut ANNULEE | Statut observé dans l’historique | RÉUSSI | `05_inscriptions/04_annulation_places_restituees.png` |
| T13 | Restitution capacité | Annulation avant début | Une place redevient disponible | Places disponibles revenues à 24 | RÉUSSI | `05_inscriptions/04_annulation_places_restituees.png` |
| T14 | Réactivation | Réinscription après annulation | Même inscription remise à CONFIRMEE | Même clé primaire conservée par le DAO | RÉUSSI | `05_inscriptions/05_inscription_reactivee.png`, JUnit |
| T15 | Création atelier | Gestionnaire crée un atelier futur | Atelier ajouté | Atelier visible dans le tableau | RÉUSSI | `06_gestionnaire/03_atelier_cree.png` |
| T16 | Modification atelier | Gestionnaire modifie l’atelier de test | Nouvelles valeurs persistées | Nouveau titre visible | RÉUSSI | `06_gestionnaire/05_atelier_modifie.png` |
| T17 | Suppression autorisée | Gestionnaire supprime l’atelier sans confirmations | Atelier retiré | Atelier absent de la liste | RÉUSSI | Aucune (suppression vérifiée dans la liste après action) |
| T18 | Capacité minimale | Réduction sous le nombre confirmé | Modification refusée | Service lève IllegalArgumentException; DAO recontrôle sous verrou | RÉUSSI | Aucun (JUnit) |
| T19 | Suppression avec confirmations | Suppression d’un atelier occupé | Suppression refusée | Exception SQL et rollback observés | RÉUSSI | Aucun (JUnit) |
| T20 | Participants | Gestionnaire consulte l’atelier #3 | Noms et statuts présentés | Trois inscriptions confirmées affichées | RÉUSSI | `06_gestionnaire/06_liste_participants.png` |
| T21 | Injection SQL | Charge SQL dans la recherche paramétrée | Aucun contournement | Recherche vide, aucune erreur; DAO retourne liste vide | RÉUSSI | `08_audit_final/01_sql_injection_sans_resultat.png` (navigateur réel), JUnit |
| T22 | XSS | Recherche contenant une balise script | Valeur inerte et échappée | Valeur affichée comme texte, aucun script injecté | RÉUSSI | `08_audit_final/02_xss_texte_echappe.png` (navigateur réel) |
| T23 | CSRF absent | POST connexion sans champ `csrf` | HTTP 403 | Requête rejetée avec HTTP 403 | RÉUSSI | Aucun (résultat HTTP automatisé; pas de capture navigateur) |
| T24 | CSRF invalide | POST avec jeton erroné | HTTP 403 | Requête rejetée avec HTTP 403 | RÉUSSI | Aucun (résultat HTTP automatisé; pas de capture navigateur) |
| T25 | Accès anonyme protégé | GET Mes inscriptions et gestionnaire | Redirection vers connexion | Formulaire de connexion affiché | RÉUSSI | `07_securite/01_acces_gestionnaire_refuse.png` |
| T26 | Étudiant vers gestionnaire | Session étudiant puis GET gestion | HTTP 403 | Refus serveur observé | RÉUSSI | Aucun (HTTP automatisé) |
| T27 | Modification d’autrui | Annulation avec un ID d’un autre étudiant | Refus, statut tiers inchangé | DAO filtré par propriétaire; refus et compteur inchangé | RÉUSSI | Aucun (HTTP/JUnit) |
| T28 | GET modificateur | GET sur l’action d’inscription | Aucune mutation, méthode refusée | HTTP 404; état inchangé | RÉUSSI | Aucun (HTTP automatisé) |
| T29 | Déconnexion | Déconnexion POST puis accès protégé | Session invalidée | Retour public; nouvelle protection active | RÉUSSI | `03_authentification/02_deconnexion_catalogue_public.png` |
| T30 | Concurrence dernière place | Deux threads synchronisés, une place restante | Une seule confirmation | Un succès, un refus, compteur égal à 1 | RÉUSSI | Aucun (assertions JUnit; pas de capture navigateur) |

## Rejeu d’audit du 17 novembre 2026

Les résultats Surefire reconstruits depuis `target/surefire-reports/TEST-*.xml` sont :

| Suite | Tests | Réussis | Échoués | Erreurs | Ignorés |
|---|---:|---:|---:|---:|---:|
| `JdbcBusinessIntegrationTest` | 6 | 6 | 0 | 0 | 0 |
| `DataStoreTest` | 4 | 4 | 0 | 0 | 0 |
| `ValidationTest` | 15 | 15 | 0 | 0 | 0 |
| `TraitementServletTest` | 5 | 5 | 0 | 0 | 0 |
| **Total Maven** | **30** | **30** | **0** | **0** | **0** |

Le rejeu de `verification-locale.ps1` a réussi : recherche ordinaire et charge SQL, échappement XSS, protection anonyme, identifiants invalides, CSRF absent/invalide (403), inscription, annulation, contrôle de propriété, rejet des actions GET et contrôle de rôle. `verification-crud-gestionnaire.ps1` a créé, modifié puis supprimé un atelier temporaire par HTTP. `verification-redemarrage.ps1` a arrêté Tomcat, confirmé son indisponibilité, l’a relancé et a retrouvé l’inscription ANNULEE dans H2.

Les captures SQL Injection et XSS du dossier `08_audit_final` sont de véritables captures du navigateur affichant l’application locale. Les scénarios CSRF, concurrence, CRUD et persistance sont établis par les statuts HTTP, assertions JUnit et contrôles d’état des scripts; ils ne sont pas illustrés par des captures navigateur. Aucun résultat de test n’a été reconstruit à partir d’une maquette.

## Portée et limites des preuves

Les captures incluses sont des PNG issus du navigateur ouvert sur l’application locale. Les tests de DAO et de concurrence sont vérifiés par assertions JUnit; leurs résultats ne sont pas remplacés par des captures fabriquées. Le rapport académique n’intègre que des vues réelles enregistrées sous `documentation/captures/`. Les scripts de vérification s’exécutent sur le serveur local et ne ciblent aucun système externe.
