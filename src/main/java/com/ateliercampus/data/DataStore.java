package com.ateliercampus.data;

import com.ateliercampus.model.Atelier;
import com.ateliercampus.model.Etudiant;
import com.ateliercampus.model.Inscription;
import com.ateliercampus.model.Inscription.Statut;

import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Entrepôt central des données en mémoire pour AtelierCampus (Partie 1).
 * Toutes les données de référence sont conservées en mémoire via des collections Java.
 * Aucune base de données relationnelle n'est utilisée conformément aux exigences de la Partie 1.
 */
public class DataStore {

    private static final DataStore INSTANCE = new DataStore();

    private final Map<Long, Etudiant> etudiants = new ConcurrentHashMap<>();
    private final Map<Long, Atelier> ateliers = new ConcurrentHashMap<>();
    private final List<Inscription> inscriptions = Collections.synchronizedList(new ArrayList<>());

    private DataStore() {
        initData();
    }

    public static DataStore getInstance() {
        return INSTANCE;
    }

    /**
     * Initialisation des données de référence (étudiants, ateliers et inscriptions fictives).
     */
    private void initData() {
        // 1. Initialisation des 5 étudiants fictifs requis
        Etudiant e1 = new Etudiant(1L, "Ahmed Ben Ali", "ahmed@gmail.com");
        Etudiant e2 = new Etudiant(2L, "Mohamed Trabelsi", "mohamed@gmail.com");
        Etudiant e3 = new Etudiant(3L, "Sami Mansour", "sami@gmail.com");
        Etudiant e4 = new Etudiant(4L, "Youssef Amri", "youssef@gmail.com");
        Etudiant e5 = new Etudiant(5L, "Karim Saidi", "karim@gmail.com");

        etudiants.put(e1.getId(), e1);
        etudiants.put(e2.getId(), e2);
        etudiants.put(e3.getId(), e3);
        etudiants.put(e4.getId(), e4);
        etudiants.put(e5.getId(), e5);

        // 2. Initialisation des 4 ateliers fictifs
        // Atelier 1 : Futur disponible
        Atelier a1 = new Atelier(
                1L,
                "Sécurité Web & OWASP Top 10",
                "Sensibilisation aux vulnérabilités web majeures (XSS, CSRF, injections) et contre-mesures.",
                "Cet atelier pratique explore en profondeur les vulnérabilités du Top 10 OWASP. " +
                        "Au programme : analyse des failles par injection, mise en place de politiques de validation stricte, " +
                        "protection contre les attaques Cross-Site Scripting (XSS), gestion sécurisée des sessions HTTP, " +
                        "et manipulation d'outils d'audit web. Des laboratoires pratiques permettront aux participants " +
                        "d'expérimenter attaques et remédiations sur un environnement dédié.",
                LocalDateTime.of(2026, 11, 20, 14, 0),
                25,
                "Dr Riadh Bouslimi",
                "Lab Cyber A-102",
                "Intermédiaire"
        );

        // Atelier 2 : Futur disponible
        Atelier a2 = new Atelier(
                2L,
                "Analyse Forensique et Réponse à Incident",
                "Acquisition de preuves numériques, analyse de mémoire vive et investigation post-attaque.",
                "Face à une compromission, la promptitude et la rigueur de l'analyse forensique sont capitales. " +
                        "Cet atelier guide les étudiants dans l'extraction de journaux d'événements, l'investigation " +
                        "de dumps mémoire (Volatility), la détection de charges virales persistantes et la rédaction " +
                        "d'un rapport d'incident conforme aux standards CERT.",
                LocalDateTime.of(2026, 11, 27, 9, 30),
                20,
                "Ing. Hichem Ben Salem",
                "Salle Réseau B-204",
                "Avancé"
        );

        // Atelier 3 : Futur complet (capacité de 3 places, occupées par 3 inscriptions confirmées)
        Atelier a3 = new Atelier(
                3L,
                "Cryptographie Appliquée et Blockchain",
                "Chiffrement asymétrique, protocoles à divulgation nulle et mécanismes de consensus distribué.",
                "Approfondissement des primitives cryptographiques modernes : RSA, courbes elliptiques, hachage " +
                        "résistant aux collisions et signature électronique. Analyse pratique des protocoles TLS 1.3, " +
                        "des smart contracts Ethereum et des vulnérabilités classiques de gestion de clés privées.",
                LocalDateTime.of(2026, 12, 4, 15, 0),
                3,
                "Prof. Sonia Ghrabi",
                "Amphi Conférence 3",
                "Tous niveaux"
        );

        // Atelier 4 : Atelier déjà commencé / passé
        Atelier a4 = new Atelier(
                4L,
                "Audit de Sécurité Réseau & Pentesting",
                "Reconnaissance réseau, scan de ports, cartographie de vulnérabilités et exploitation contrôlée.",
                "Session d'initiation et de perfectionnement aux tests d'intrusion réseau : découverte d'hôtes avec Nmap, " +
                        "analyse des protocoles SMB/Active Directory, utilisation de scanners de vulnérabilités et application " +
                        "des règles déontologiques du pentest éthique.",
                LocalDateTime.of(2026, 10, 15, 10, 0),
                15,
                "Dr Riadh Bouslimi",
                "Lab Cyber A-101",
                "Intermédiaire"
        );

        ateliers.put(a1.getId(), a1);
        ateliers.put(a2.getId(), a2);
        ateliers.put(a3.getId(), a3);
        ateliers.put(a4.getId(), a4);

        // 3. Inscriptions de référence
        // Inscriptions confirmées sur l'Atelier 1 (place dispo)
        inscriptions.add(new Inscription(1L, e1, a1, LocalDateTime.of(2026, 10, 25, 11, 20), Statut.CONFIRMEE));
        
        // Inscription annulée sur l'Atelier 1 (démontre au moins une inscription ANNULEE)
        inscriptions.add(new Inscription(2L, e2, a1, LocalDateTime.of(2026, 10, 26, 16, 45), Statut.ANNULEE));

        // Inscriptions confirmées sur l'Atelier 3 (futur COMPLET : 3 places, 3 inscriptions confirmées)
        inscriptions.add(new Inscription(3L, e3, a3, LocalDateTime.of(2026, 10, 28, 9, 10), Statut.CONFIRMEE));
        inscriptions.add(new Inscription(4L, e4, a3, LocalDateTime.of(2026, 10, 29, 14, 0), Statut.CONFIRMEE));
        inscriptions.add(new Inscription(5L, e5, a3, LocalDateTime.of(2026, 10, 30, 17, 30), Statut.CONFIRMEE));

        // Inscription sur l'Atelier 4 (passé)
        inscriptions.add(new Inscription(6L, e2, a4, LocalDateTime.of(2026, 10, 10, 8, 0), Statut.CONFIRMEE));
    }

    public List<Etudiant> getEtudiants() {
        return new ArrayList<>(etudiants.values());
    }

    public Etudiant getEtudiantById(Long id) {
        if (id == null) return null;
        return etudiants.get(id);
    }

    public Etudiant getEtudiantByEmail(String email) {
        if (email == null) return null;
        for (Etudiant e : etudiants.values()) {
            if (email.trim().equalsIgnoreCase(e.getEmail())) {
                return e;
            }
        }
        return null;
    }

    public List<Atelier> getAteliers() {
        List<Atelier> list = new ArrayList<>(ateliers.values());
        list.sort(Comparator.comparing(Atelier::getId));
        return list;
    }

    public Atelier getAtelierById(Long id) {
        if (id == null) return null;
        return ateliers.get(id);
    }

    /**
     * Recherche un atelier par son identifiant sous forme de chaîne de caractères.
     * Retourne null en cas d'identifiant manquant, invalide ou inexistant.
     */
    public Atelier getAtelierById(String idStr) {
        if (idStr == null || idStr.trim().isEmpty()) return null;
        try {
            return getAtelierById(Long.parseLong(idStr.trim()));
        } catch (NumberFormatException e) {
            return null;
        }
    }

    public List<Inscription> getInscriptions() {
        return new ArrayList<>(inscriptions);
    }

    public List<Inscription> getInscriptionsByAtelier(Long atelierId) {
        if (atelierId == null) return Collections.emptyList();
        List<Inscription> result = new ArrayList<>();
        synchronized (inscriptions) {
            for (Inscription insc : inscriptions) {
                if (insc.getAtelier() != null && Objects.equals(insc.getAtelier().getId(), atelierId)) {
                    result.add(insc);
                }
            }
        }
        return result;
    }

    public int getNombreInscriptionsConfirmees(Long atelierId) {
        if (atelierId == null) return 0;
        int count = 0;
        synchronized (inscriptions) {
            for (Inscription insc : inscriptions) {
                if (insc.getAtelier() != null &&
                        Objects.equals(insc.getAtelier().getId(), atelierId) &&
                        insc.isConfirmee()) {
                    count++;
                }
            }
        }
        return count;
    }

    public int getNombreInscriptionsConfirmees(String idStr) {
        Atelier a = getAtelierById(idStr);
        return a != null ? getNombreInscriptionsConfirmees(a.getId()) : 0;
    }

    public int getPlacesRestantes(Long atelierId) {
        Atelier atelier = getAtelierById(atelierId);
        if (atelier == null) return 0;
        int confirmees = getNombreInscriptionsConfirmees(atelierId);
        return Math.max(0, atelier.getCapacite() - confirmees);
    }

    public int getPlacesRestantes(String idStr) {
        Atelier a = getAtelierById(idStr);
        return a != null ? getPlacesRestantes(a.getId()) : 0;
    }

    public boolean isComplet(Long atelierId) {
        return getPlacesRestantes(atelierId) <= 0;
    }

    public boolean isComplet(String idStr) {
        Atelier a = getAtelierById(idStr);
        return a != null && isComplet(a.getId());
    }

    public String getStatutDisponibilite(Long atelierId) {
        Atelier atelier = getAtelierById(atelierId);
        if (atelier == null) return "Inconnu";
        if (atelier.isPasse()) {
            return "Session terminée";
        }
        if (isComplet(atelierId)) {
            return "Complet";
        }
        int restantes = getPlacesRestantes(atelierId);
        return "Places disponibles (" + restantes + " restante" + (restantes > 1 ? "s" : "") + ")";
    }

    public String getStatutDisponibilite(String idStr) {
        Atelier a = getAtelierById(idStr);
        return a != null ? getStatutDisponibilite(a.getId()) : "Inconnu";
    }

    public String getCodeStatut(Long atelierId) {
        Atelier atelier = getAtelierById(atelierId);
        if (atelier == null) return "inconnu";
        if (atelier.isPasse()) return "passe";
        if (isComplet(atelierId)) return "complet";
        return "disponible";
    }

    public String getCodeStatut(String idStr) {
        Atelier a = getAtelierById(idStr);
        return a != null ? getCodeStatut(a.getId()) : "inconnu";
    }
}
