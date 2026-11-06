# AtelierCampus — Portail Officiel des Ateliers de Cybersécurité

**Université Centrale** — Pôle Ingénierie & Technologies de l'Information  
**Centre de Formation Pratique en Cybersécurité**

---

## 1. Présentation de la Plateforme

**AtelierCampus** est le portail web officiel de l'Université Centrale dédié à la diffusion du catalogue et à la gestion des demandes d'inscription aux ateliers techniques spécialisés en cybersécurité (Sécurité Web & OWASP, Analyse Forensique, Cryptographie Appliquée et Pentesting Réseau).

Conçue selon les standards d'ergonomie et de sécurité des portails universitaires modernes, l'application propose :
- Une navigation fluide et intuitive entre l'accueil, le catalogue et les fiches pédagogiques.
- Un affichage temps réel de l'état des sessions (disponibilité, sessions complètes ou clôturées).
- Un formulaire de demande sécurisé avec contrôle strict côté serveur et protection anti-XSS intégrée.
- Une confirmation de demande claire informant le candidat de la prise en compte de sa simulation.

---

## 2. Identité Visuelle & Ergonomie

L'interface a été entièrement conçue pour refléter le sérieux, la rigueur et la crédibilité institutionnelle de l'Université Centrale :
- **Palette sobre et élégante :** Deep Navy (`#10243A`), Accent Universitaire Bleu (`#1677C8`), Cyan (`#20B8CF`), surfaces épurées (`#FFFFFF`) sur fond neutre (`#F5F7FA`).
- **Iconographie 100% SVG (Lucide) :** Remplacement total des emojis par des icônes vectorielles institutionnelles, précises et cohérentes.
- **Typographie professionnelle :** Combinaison des polices *Plus Jakarta Sans* (titres et identité) et *Inter* (lisibilité du contenu et des formulaires).
- **Design Responsive :** Adaptation naturelle sur ordinateurs de bureau, tablettes et terminaux mobiles.

---

## 3. Architecture Technique

- **Java JDK :** OpenJDK 17 LTS (Microsoft Build)
- **Conteneur Servlet :** Apache Tomcat 10.1.x (Jakarta EE 10)
- **Gestionnaire de dépendances :** Apache Maven 3.9+
- **Composants Web :** Jakarta Servlet 6.0, Jakarta Server Pages (JSP) 3.1, JSTL 3.0 (GlassFish Runtime)
- **Tests Automatisés :** JUnit 5.10, AssertJ 3.25, Mockito 5.11 (24 tests passés avec succès)

---

## 4. Données de Référence en Mémoire (`DataStore.java`)

### A. Étudiants Référencés
1. **Ahmed Ben Ali** — `ahmed@gmail.com`
2. **Mohamed Trabelsi** — `mohamed@gmail.com`
3. **Sami Mansour** — `sami@gmail.com`
4. **Youssef Amri** — `youssef@gmail.com`
5. **Karim Saidi** — `karim@gmail.com`

### B. Ateliers Programmés
1. **Réf. #1 — Sécurité Web & OWASP Top 10** (*Places disponibles*) — 20 novembre 2026 à 14h00
2. **Réf. #2 — Analyse Forensique et Réponse à Incident** (*Places disponibles*) — 27 novembre 2026 à 09h30
3. **Réf. #3 — Cryptographie Appliquée et Blockchain** (*Complet*) — 4 décembre 2026 à 15h00
4. **Réf. #4 — Audit de Sécurité Réseau & Pentesting** (*Session terminée*) — 15 octobre 2026 à 10h00

---

## 5. Instructions de Construction & Déploiement

### Compilation et Tests
```powershell
.\mvnw.cmd clean package
```
Le livrable généré est : `target/AtelierCampus.war`.

### Déploiement sur Tomcat 10.1
1. Copier `target/AtelierCampus.war` dans le répertoire `webapps/` de Tomcat 10.1.
2. Démarrer Tomcat via `bin/catalina.bat start`.
3. Accéder à l'application : [http://localhost:8080/AtelierCampus/](http://localhost:8080/AtelierCampus/)

---

## 6. Vérification des Scénarios de Test

Tous les contrôles fonctionnels et sécuritaires ont été exécutés et validés :

| Scénario | Données | Résultat Observé | Statut |
| :--- | :--- | :--- | :---: |
| **Saisie valide** | Nom : `Ahmed Ben Ali`<br>Email : `ahmed@gmail.com`<br>Atelier : `1` | Récapitulatif affiché avec la mention requise : *« Demande simulée, non enregistrée. »* | **Succès (200)** |
| **Email invalide** | Nom : `Ahmed Ben Ali`<br>Email : `invalid-email`<br>Atelier : `1` | Formulaire réaffiché avec bandeau d'alerte rouge, valeurs saisies conservées. | **Succès (200)** |
| **Nom vide** | Nom : `""`<br>Email : `ahmed@gmail.com`<br>Atelier : `1` | Formulaire réaffiché avec message indiquant que le nom est obligatoire. | **Succès (200)** |
| **Atelier inconnu** | Nom : `Test Student`<br>Email : `test@example.com`<br>Atelier : `9999` | Erreur contrôlée : message d'atelier inexistant affiché sans aucune exception technique 500. | **Succès (200)** |
| **Tentative XSS** | Nom : `<script>alert('XSS')</script>`<br>Atelier : `1` | Script neutralisé et échappé en `&lt;script&gt;alert(&#x27;XSS&#x27;)&lt;/script&gt;`. Aucun popup exécuté. | **Succès (200)** |
| **Parcours HTTP** | Accueil → Catalogue → Détail → Inscription → Récapitulatif | Préservation intégrale de l'ID atelier, protection des accès directs en GET. | **Succès (200)** |
