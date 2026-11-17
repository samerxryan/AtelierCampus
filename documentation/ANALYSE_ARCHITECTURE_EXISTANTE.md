# Analyse de l’architecture existante — AtelierCampus

## Périmètre et méthode

Analyse fondée sur les sources présentes dans `src/`, le `pom.xml`, `web.xml`, le README et les documents de conception du dépôt local. Le dépôt est sur la branche `feature/partie-2-servlets-jdbc`, créée depuis `main` propre ; trois livrables locaux non suivis par Git existaient avant l’intervention et sont conservés.

## Vue d’ensemble

AtelierCampus est une application web de démonstration des demandes d’inscription aux ateliers de cybersécurité. La version existante correspond au périmètre Partie 1 : elle sert un catalogue et des détails depuis des JSP, valide une demande simulée dans `TraitementServlet`, puis affiche un récapitulatif. Aucune inscription n’est persistée.

## Technologies et versions constatées

| Élément | Version constatée |
|---|---|
| Java local | Microsoft OpenJDK 17.0.21 |
| Construction | Maven Wrapper 3.9.14 |
| Application | WAR Maven, artefact `AtelierCampus.war` |
| API Web | Jakarta Servlet 6.0 et JSP 3.1 |
| Conteneur ciblé | Tomcat 10.1 (indiqué dans le POM et le README) |
| JSTL | Jakarta JSTL 3.0 |
| Tests existants | JUnit 5, Mockito, AssertJ |

## Architecture et packages actuels

```text
com.ateliercampus.data       DataStore singleton (données fictives en mémoire)
com.ateliercampus.model      Atelier, Etudiant, Inscription
com.ateliercampus.util       ValidationUtil, ValidationResult
com.ateliercampus.web        TraitementServlet, AppContextListener
src/main/webapp              JSP, fragments d’en-tête/pied, CSS, web.xml
```

Les modèles portent les quatre ateliers initiaux, cinq étudiants et six inscriptions représentatives. `Atelier` conserve aussi des champs de présentation (animateur, salle, niveau) et des descriptions courtes/longues. `DataStore` calcule le nombre de confirmations et les places disponibles.

## Parcours actuel

`catalogue.jsp` lit les ateliers depuis `${dataStore}`. Le visiteur suit les liens vers `detail.jsp?id=…`, puis `inscription.jsp?id=…`. Le formulaire poste vers `TraitementServlet`, lequel valide nom, email et identifiant d’atelier via `ValidationUtil`. En cas d’erreur, le servlet fait un forward vers le formulaire avec les valeurs conservées ; sinon il transmet les données au JSP récapitulatif. Le résultat est explicitement présenté comme une simulation non enregistrée.

## Présentation et validation

Le CSS unique `css/style.css` définit une identité visuelle institutionnelle bleu marine/bleu, des composants de catalogue et des mises en page adaptatives. Les vues utilisent JSTL `c:out` à plusieurs endroits pour l’échappement. La validation métier actuellement couverte porte sur nom, email et existence de l’atelier. Le `web.xml` configure les erreurs et la session/cookie. L’inscription simulée n’a ni authentification, ni jeton CSRF, ni contrôle de capacité bloquant.

## État de la persistance

Aucune base de données, configuration JDBC, couche DAO ou script SQL n’existe. `DataStore` initialise toutes les données en mémoire au lancement ; elles sont perdues au redémarrage. Le code des vues interroge directement ce magasin via EL. L’architecture est donc un MVC partiel, caractéristique de la première livraison, et ne répond pas encore à la séparation model/dao/service/controller demandée en Partie 2.

## État Git et livrables existants

Le dépôt contient un commit initial sur `main`, sans modification suivie en cours d’analyse. Le répertoire comporte également un WAR compilé dans `target/`, huit captures de Partie 1, un rapport de conception Markdown et un PDF de conception. Trois fichiers locaux non suivis (archive P1, PDF P1 et reçu de dépôt) sont préservés.

## Limites et exigences manquantes pour la Partie 2

- Remplacer les lectures et écritures en mémoire par JDBC et une base relationnelle persistante.
- Ajouter tables, contraintes, scripts de création et données initiales.
- Séparer DAO, service métier et contrôleurs Servlet ; ne plus exposer le magasin aux JSP.
- Ajouter comptes, hachage des mots de passe, connexion/déconnexion et rôles.
- Implémenter inscriptions, annulations, historique étudiant et administration gestionnaire.
- Appliquer contrôles de propriété, CSRF et autorisation côté serveur.
- Gérer capacité et date avec transaction et verrouillage empêchant la sur-réservation.
- Documenter puis exécuter les tests fonctionnels et de sécurité demandés.

## Stratégie et compatibilité

Conserver le WAR, Java 17, le namespace `jakarta.*`, Tomcat 10.1, Maven, les modèles existants autant que possible et l’identité visuelle actuelle. Utiliser une base relationnelle embarquée H2 en mode fichier pour une installation reproductible sans serveur de base externe, JDBC standard avec `PreparedStatement`, DAO et service transactionnel. Les vues seront migrées vers des contrôleurs et JSTL/EL. Les bibliothèques complémentaires seront limitées au pilote H2 et au hachage BCrypt. La partie 3 Spring Boot/JPA reste hors périmètre.
