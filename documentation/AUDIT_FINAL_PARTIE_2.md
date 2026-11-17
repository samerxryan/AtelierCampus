# Audit final AtelierCampus Partie 2

**Exécution :** 17 novembre 2026, Windows 11, Microsoft OpenJDK 17.0.21, Maven Wrapper 3.9.14, Apache Tomcat 10.1.61, H2 2.3.232. Les vérifications HTTP ont ciblé exclusivement `http://localhost:8080/AtelierCampus`.

## Corrections de cohérence du rapport

- Le rapport attribuait à `database/data.sql` les étudiants, le gestionnaire et les inscriptions. Le SQL ne contient que les quatre ateliers et le marqueur d’initialisation; les six comptes et les inscriptions de démonstration sont créés par `Database.initialize` appelé depuis `AppContextListener`. Le texte a été corrigé.
- Le rapport disait que l’URL JDBC permettait de changer de moteur. Le code charge explicitement le pilote H2. La phrase a été corrigée pour décrire la configuration réelle (URL et identifiants H2 configurables, H2 comme pilote livré).
- Un diagramme ERD a été ajouté en PNG dans le PDF/DOCX et en SVG source éditable. Les clés et relations correspondent à `database/schema.sql`.
- Le rapport contient maintenant une page d’audit qui distingue les captures d’application réelles des sorties HTTP/JUnit. Il compte 8 pages.

## Résultats rejoués

| Vérification | Résultat réel |
|---|---|
| `mvnw clean test` | 30 réussis, 0 échec, 0 erreur, 0 ignoré. Détail ci-dessous. |
| `scripts/verification-locale.ps1` | Réussite : catalogue, recherche SQL paramétrée, XSS, accès protégé, identifiants erronés, CSRF absent/invalide (HTTP 403), inscription/annulation, propriété, GET sans mutation et contrôle des rôles. |
| `scripts/verification-crud-gestionnaire.ps1` | Réussite : création, modification et suppression réelles par HTTP d’un atelier de test temporaire; il est supprimé en fin de scénario. |
| `scripts/verification-redemarrage.ps1` | Réussite : Tomcat a été arrêté, son arrêt vérifié, puis relancé; l’étudiant a retrouvé son inscription `ANNULEE` depuis la base H2 fichier. |
| Validation ERD et captures du rapport | Réussie : les clés étrangères, cardinalités et dix images intégrées correspondent aux sources PNG; les pages 1 à 8 du PDF ont été rendues et inspectées. |

### Détail des 30 tests Maven

| Suite | Réussis | Échoués | Erreurs | Ignorés |
|---|---:|---:|---:|---:|
| `JdbcBusinessIntegrationTest` | 6 | 0 | 0 | 0 |
| `DataStoreTest` | 4 | 0 | 0 | 0 |
| `ValidationTest` | 15 | 0 | 0 | 0 |
| `TraitementServletTest` | 5 | 0 | 0 | 0 |
| **Total** | **30** | **0** | **0** | **0** |

Les 6 tests JDBC couvrent la réservation/annulation/réactivation (même clé d’inscription), le refus d’un atelier complet ou commencé, la protection du propriétaire, la concurrence de deux réservations sur une place, le paramétrage SQL et les restrictions de capacité/suppression. Les 24 autres tests portent sur le magasin mémoire historique, la validation des entrées et le servlet de Partie 1; ils ne sont pas présentés comme tests des contrôleurs P2.

## Captures et limites

- Les captures d’interface présentes aux pages 6–8 du rapport sont des captures du navigateur sur l’application Tomcat locale. Les deux nouvelles images de sécurité sont `documentation/captures/08_audit_final/01_sql_injection_sans_resultat.png` et `02_xss_texte_echappe.png`.
- Les scénarios CSRF ont réellement renvoyé HTTP 403, et le scénario de concurrence a réussi par assertions JUnit. Aucune capture navigateur de ces deux résultats n’a été prise; leur source de preuve est précisée dans le rapport et dans `RESULTATS_TESTS.md`.
- La persistance après redémarrage a été confirmée par le script HTTP après le vrai stop/start de Tomcat. Aucune capture d’écran de la page étudiant après ce redémarrage n’a été prise. Le résultat fonctionnel est exécuté et réussi; seule la capture visuelle demandée manque.
- Aucun test fonctionnel listé n’a échoué ou été ignoré. Les éléments « non exécutés » dans ce contrôle sont les trois captures navigateur CSRF, concurrence et post-redémarrage, et non les vérifications fonctionnelles correspondantes.
