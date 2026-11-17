# AtelierCampus — Partie 2

Application de gestion des inscriptions aux ateliers de cybersécurité de l’Université Centrale. Cette version remplace la simulation JSP de Partie 1 par une application MVC Servlets/JSP, une persistance JDBC relationnelle, l’authentification et le contrôle des règles métier.

## Technologies

- Java 17, Maven 3.9+
- Apache Tomcat 10.1.x (Jakarta Servlet 6.0, JSP 3.1)
- H2 2.3 en mode fichier, JDBC, JSTL 3.0
- jBCrypt 0.4 (BCrypt, coût 12)
- JUnit 5.10, Mockito 5, AssertJ (tests hérités de Partie 1)

## Prérequis

JDK 17 et accès à Maven (ou au Maven Wrapper fourni). Tomcat 10.1 est requis pour exécuter le WAR. Aucun serveur SQL externe n’est nécessaire. Le projet a été compilé et déployé en local sous Windows 11 avec OpenJDK 17.0.21 et Tomcat 10.1.61.

## Architecture

```text
src/main/java/com/ateliercampus/
  model/       Atelier, Etudiant, Inscription
  dao/         Database, AtelierDao, EtudiantDao, InscriptionDao
  service/     AtelierService, InscriptionService, AuthentificationService
  controller/ AtelierCampusServlet (contrôleur HTTP)
  web/         AppContextListener, SecuriteFilter
src/main/webapp/WEB-INF/vues/   JSP de présentation JSTL/EL
 database/                      schema.sql, data.sql
 documentation/                 analyse, plan, résultats, captures
 rapport/                       rapport DOCX/PDF
```

Les vues sont servies sous `/catalogue`, `/atelier?id=…`, `/connexion`, `/mes-inscriptions` et `/gestion/*`. Les accès SQL passent par les DAO. La couche service valide les dates, les capacités et les statuts.

## Installation de la base

Au premier déploiement, le listener exécute `database/schema.sql` puis `database/data.sql`. La base H2 est créée automatiquement sous `${user.home}/.ateliercampus/ateliercampus`. Les données d’atelier existantes ne sont pas remplacées lors d’un redémarrage. Les identifiants sont générés par H2.

Les variables suivantes permettent de remplacer la connexion H2 par défaut :

```powershell
$env:ATELIERCAMPUS_JDBC_URL = 'jdbc:h2:file:C:/chemin/ateliercampus'
$env:ATELIERCAMPUS_DB_USER = 'sa'
$env:ATELIERCAMPUS_DB_PASSWORD = ''
```

Le fichier [database.example.properties](config/database.example.properties) illustre ces paramètres sans secret réel. Les scripts sont également fournis à la racine `database/`.

## Compilation et déploiement

```powershell
.\mvnw.cmd clean package
```

Copier `target/AtelierCampus.war` dans `TOMCAT_HOME/webapps/`, démarrer Tomcat (`bin/catalina.bat start`) et ouvrir `http://localhost:8080/AtelierCampus/catalogue`.

Pour exécuter les tests unitaires existants :

```powershell
.\mvnw.cmd test
```

## Comptes de démonstration — développement uniquement

Ces comptes sont créés au premier démarrage et servent aux démonstrations locales. Ne pas les utiliser en production.

- Étudiant : `ahmed@gmail.com` / `Etudiant2026!`
- Gestionnaire : `gestionnaire@ateliercampus.local` / `Gestionnaire2026!`

La base ne contient que les condensats BCrypt, jamais les mots de passe en clair.

## Fonctionnalités

**Visiteur :** catalogue public, recherche paramétrée par titre, détail, nombre de confirmations et places disponibles. Les ateliers complets et déjà commencés sont signalés.

**Étudiant :** connexion, déconnexion, consultation de son historique, inscription avant le début, annulation avant le début et réactivation d’une inscription annulée. Un étudiant ne peut modifier que ses propres inscriptions.

**Gestionnaire :** tableau de bord, création, modification, suppression si aucune inscription confirmée n’existe, consultation des participants et statuts. Les contrôles de rôle sont réalisés côté serveur.

## Sécurité mise en œuvre

BCrypt (coût 12), invalidation/renouvellement de session à la connexion, délai de session de 30 minutes, cookie HttpOnly/SameSite Strict, PreparedStatement, échappement JSTL `c:out`/`fn:escapeXml`, jeton CSRF aléatoire sur chaque POST, autorisation serveur par rôle et requête d’annulation filtrée par propriétaire. L’inscription verrouille l’atelier avec `SELECT … FOR UPDATE`, contrôle la capacité et enregistre dans une transaction.

## Données de démonstration et limites

Le catalogue comprend quatre ateliers (deux futurs disponibles, un futur complet, un déjà commencé), cinq étudiants, un gestionnaire et une inscription annulée. H2 fichier facilite une démonstration locale mono-instance. Pour un déploiement distribué, prévoir un serveur relationnel administré et une gestion de secrets appropriée. Le CRUD des ateliers est volontairement limité aux champs demandés dans Partie 2 ; les informations animateur/salle/niveau de Partie 1 ne sont pas encore persistées.

## Documentation du dépôt

- `documentation/ANALYSE_ARCHITECTURE_EXISTANTE.md` — constat avant mise à niveau.
- `documentation/PLAN_IMPLEMENTATION_P2.md` — correspondance exigences et composants.
- `documentation/RESULTATS_TESTS.md` — tests exécutés et limites.
- `documentation/AUDIT_FINAL_PARTIE_2.md` — audit de cohérence, résultats rejoués et limites des preuves.
- `documentation/erd_ateliercampus.svg` / `.png` — diagramme ERD basé sur le schéma SQL.
- `documentation/captures/` — captures réelles de l’application locale.
- `database/README.md` — choix, scripts et accès de développement.
- `rapport/Rapport_Partie_2_AtelierCampus.docx` et `.pdf` — rapport académique.
