# Base de données AtelierCampus

Le projet embarque H2 2.x en mode fichier. Au premier démarrage, le listener exécute `schema.sql` puis `data.sql` depuis le classpath. Les données durables résident par défaut dans `${user.home}/.ateliercampus/ateliercampus`; le dossier est créé automatiquement.

Les scripts reproductibles sont `schema.sql` et `data.sql`. Pour les exécuter manuellement, lancer le Shell H2 avec le pilote fourni par Maven puis ouvrir une connexion JDBC vers le fichier indiqué. Le schéma possède des clés étrangères, des identifiants générés, les contraintes de statut et capacité, ainsi que l'unicité du couple étudiant/atelier.

La configuration peut être remplacée par les variables `ATELIERCAMPUS_JDBC_URL`, `ATELIERCAMPUS_DB_USER` et `ATELIERCAMPUS_DB_PASSWORD`. L'exemple non sensible est dans `../config/database.example.properties`. En déploiement de démonstration, conserver les comptes de développement isolés; ne pas réutiliser ces identifiants en production.

Comptes de développement uniquement (mots de passe hachés BCrypt dans la base) :
- Étudiant : `ahmed@gmail.com` / `Etudiant2026!`
- Gestionnaire : `gestionnaire@ateliercampus.local` / `Gestionnaire2026!`

Les comptes sont créés par l'initialiseur au premier démarrage. Le script SQL apporte les ateliers de démonstration ; l'initialiseur insère les comptes et inscriptions de démonstration de façon idempotente.
