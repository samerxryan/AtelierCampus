package com.ateliercampus.data;

import com.ateliercampus.model.Atelier;
import com.ateliercampus.model.Etudiant;
import com.ateliercampus.model.Inscription;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;

class DataStoreTest {

    private DataStore dataStore;

    @BeforeEach
    void setUp() {
        dataStore = DataStore.getInstance();
    }

    @Test
    @DisplayName("Vérifie que les 5 étudiants requis sont correctement initialisés")
    void testEtudiantsInitialises() {
        List<Etudiant> etudiants = dataStore.getEtudiants();
        assertThat(etudiants).hasSize(5);

        assertThat(dataStore.getEtudiantByEmail("ahmed@gmail.com")).isNotNull();
        assertThat(dataStore.getEtudiantByEmail("mohamed@gmail.com")).isNotNull();
        assertThat(dataStore.getEtudiantByEmail("sami@gmail.com")).isNotNull();
        assertThat(dataStore.getEtudiantByEmail("youssef@gmail.com")).isNotNull();
        assertThat(dataStore.getEtudiantByEmail("karim@gmail.com")).isNotNull();

        assertThat(dataStore.getEtudiantByEmail("ahmed@gmail.com").getNom()).isEqualTo("Ahmed Ben Ali");
    }

    @Test
    @DisplayName("Vérifie les 4 situations d'ateliers requises par le sujet")
    void testAteliersSituations() {
        List<Atelier> ateliers = dataStore.getAteliers();
        assertThat(ateliers).hasSize(4);

        // Atelier 1 : Futur avec places disponibles
        Atelier a1 = dataStore.getAtelierById(1L);
        assertThat(a1).isNotNull();
        assertThat(a1.isPasse()).isFalse();
        assertThat(dataStore.getPlacesRestantes(1L)).isGreaterThan(0);
        assertThat(dataStore.getCodeStatut(1L)).isEqualTo("disponible");

        // Atelier 2 : Autre atelier futur avec places disponibles
        Atelier a2 = dataStore.getAtelierById(2L);
        assertThat(a2).isNotNull();
        assertThat(a2.isPasse()).isFalse();
        assertThat(dataStore.getPlacesRestantes(2L)).isGreaterThan(0);
        assertThat(dataStore.getCodeStatut(2L)).isEqualTo("disponible");

        // Atelier 3 : Futur complet
        Atelier a3 = dataStore.getAtelierById(3L);
        assertThat(a3).isNotNull();
        assertThat(a3.isPasse()).isFalse();
        assertThat(dataStore.isComplet(3L)).isTrue();
        assertThat(dataStore.getPlacesRestantes(3L)).isZero();
        assertThat(dataStore.getCodeStatut(3L)).isEqualTo("complet");

        // Atelier 4 : Atelier déjà commencé / passé
        Atelier a4 = dataStore.getAtelierById(4L);
        assertThat(a4).isNotNull();
        assertThat(a4.isPasse()).isTrue();
        assertThat(dataStore.getCodeStatut(4L)).isEqualTo("passe");
    }

    @Test
    @DisplayName("Vérifie les inscriptions de référence : couples uniques et au moins une inscription annulée")
    void testInscriptionsReference() {
        List<Inscription> inscriptions = dataStore.getInscriptions();
        assertThat(inscriptions).isNotEmpty();

        // Vérification de la présence d'au moins une inscription annulée
        boolean hasAnnulee = inscriptions.stream().anyMatch(Inscription::isAnnulee);
        assertThat(hasAnnulee).isTrue();

        // Vérification de la présence d'au moins une inscription confirmée
        boolean hasConfirmee = inscriptions.stream().anyMatch(Inscription::isConfirmee);
        assertThat(hasConfirmee).isTrue();

        // Vérification de l'unicité du couple (étudiant, atelier)
        Set<String> couples = new HashSet<>();
        for (Inscription insc : inscriptions) {
            String key = insc.getEtudiant().getId() + "-" + insc.getAtelier().getId();
            assertThat(couples.add(key))
                    .as("Le couple étudiant %s et atelier %s doit être unique", 
                            insc.getEtudiant().getNom(), insc.getAtelier().getTitre())
                    .isTrue();
        }
    }

    @Test
    @DisplayName("Vérifie la robustesse de getAtelierById avec des chaînes invalides")
    void testGetAtelierByIdString() {
        assertThat(dataStore.getAtelierById("1")).isNotNull();
        assertThat(dataStore.getAtelierById("")).isNull();
        assertThat(dataStore.getAtelierById("   ")).isNull();
        assertThat(dataStore.getAtelierById("abc")).isNull();
        assertThat(dataStore.getAtelierById("9999")).isNull();
        assertThat(dataStore.getAtelierById((String) null)).isNull();
    }
}

