# Plan d’implémentation — Partie 2

| Phase / exigence professeur | Composants prévus | Persistance / sécurité | Vérification prévue | Preuve prévue |
|---|---|---|---|---|
| Base relationnelle et contraintes | `database/schema.sql`, `data.sql`, `DatabaseInitializer` | H2 fichier; PK générées, FK, unicité email et couple, statuts, capacité positive, index | Initialisation vierge, contrôle du jeu de données | `02_base_de_donnees` |
| Architecture MVC | packages `model`, `dao`, `service`, `controller`; JSP limitées à l’affichage | JDBC dans les DAO; règles dans services | compilation et parcours de vues | `01_architecture` |
| Catalogue public, recherche, détail | `CatalogueServlet`, `AtelierDao`, JSP existantes adaptées | recherche paramétrée, JSTL `c:out` | catalogue/recherche/détail, charge SQLi | `04_catalogue`, `07_securite` |
| Authentification et session | `AuthServlet`, filtre d’accès, modèle `Role` | BCrypt, rotation session, timeout, invalidation | comptes étudiant/gestionnaire, erreur login, logout | `03_authentification` |
| Inscription, annulation, historique | `InscriptionServlet`, `InscriptionService`, `InscriptionDao` | CSRF, contrôle propriétaire, transaction + verrou `FOR UPDATE` | capacité, date, doublon, annulation, réactivation, concurrence | `05_inscriptions`, `08_tests` |
| Administration | `GestionnaireServlet`, `AtelierService`, DAO | rôle vérifié serveur, CSRF sur POST | création, modification, refus capacité, suppression, participants | `06_gestionnaire` |
| Résultats de tests | `documentation/RESULTATS_TESTS.md` | tous les tests exécutés localement uniquement | scénario par scénario; non exécutés explicitement signalés | `08_tests` |
| Rapport, README, archive | `rapport/`, `README.md`, ZIP P2 | pas de secrets; identifiants réservés au développement | inspection cohérence, ouverture des livrables | captures réelles seulement |

## Décision de conception

La configuration actuelle cible un WAR Jakarta EE déployé sur Tomcat 10.1. H2 en fichier permet d’offrir un démarrage autonome sans présumer qu’un serveur MySQL/PostgreSQL est installé. Le pilote reste interchangeable par configuration JDBC. Les scripts SQL doivent être compatibles avec H2 2.x. La transaction d’inscription verrouille la ligne atelier avant le comptage, puis insère ou réactive l’unique inscription étudiant/atelier.

## Ordre d’exécution

1. Ajouter le schéma, les données de démonstration et l’initialisation idempotente.
2. Ajouter DAO JDBC, services, hachage de mots de passe et couche d’authentification.
3. Ajouter contrôleurs publics, étudiant et gestionnaire, ainsi que filtres CSRF/autorisation.
4. Adapter les vues existantes en conservant CSS et parcours visuel.
5. Compiler, démarrer Tomcat local si disponible, puis vérifier les scénarios réalisables.
6. Produire résultats de tests, captures navigateur réelles si l’application peut être lancée, rapport et archive reproductible.
