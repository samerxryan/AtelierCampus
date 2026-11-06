package com.ateliercampus.util;

import com.ateliercampus.data.DataStore;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;

import static org.assertj.core.api.Assertions.assertThat;

class ValidationTest {

    private DataStore dataStore;

    @BeforeEach
    void setUp() {
        dataStore = DataStore.getInstance();
    }

    @Test
    @DisplayName("Scénario 1 : Saisie valide d'inscription")
    void testScenario1_SaisieValide() {
        ValidationResult result = ValidationUtil.validateDemandeInscription(
                "Test Student",
                "test@example.com",
                "1",
                dataStore
        );

        assertThat(result.isValid()).isTrue();
        assertThat(result.hasErrors()).isFalse();
        assertThat(result.getErreurs()).isEmpty();
    }

    @ParameterizedTest
    @ValueSource(strings = {
            "invalid-email",
            "test@",
            "@example.com",
            "test@.com",
            "test@com",
            "plainaddress",
            "test @example.com"
    })
    @DisplayName("Scénario 2 : Format d'email invalide rejeté avec message clair")
    void testScenario2_EmailInvalide(String invalidEmail) {
        ValidationResult result = ValidationUtil.validateDemandeInscription(
                "Test Student",
                invalidEmail,
                "1",
                dataStore
        );

        assertThat(result.isValid()).isFalse();
        assertThat(result.hasErrors()).isTrue();
        assertThat(result.getErreurs())
                .anyMatch(err -> err.toLowerCase().contains("email"));
    }

    @ParameterizedTest
    @ValueSource(strings = {"", "   ", "\t", "\n"})
    @DisplayName("Scénario 3 : Nom vide ou avec espaces uniquement rejeté")
    void testScenario3_NomVide(String emptyNom) {
        ValidationResult result = ValidationUtil.validateDemandeInscription(
                emptyNom,
                "test@example.com",
                "1",
                dataStore
        );

        assertThat(result.isValid()).isFalse();
        assertThat(result.hasErrors()).isTrue();
        assertThat(result.getErreurs())
                .anyMatch(err -> err.toLowerCase().contains("nom"));
    }

    @Test
    @DisplayName("Scénario 4 : Atelier inconnu (ex: ID 9999) rejeté de façon contrôlée")
    void testScenario4_AtelierInconnu() {
        ValidationResult result = ValidationUtil.validateDemandeInscription(
                "Test Student",
                "test@example.com",
                "9999",
                dataStore
        );

        assertThat(result.isValid()).isFalse();
        assertThat(result.hasErrors()).isTrue();
        assertThat(result.getErreurs())
                .anyMatch(err -> err.contains("9999") && err.toLowerCase().contains("n'existe pas"));
    }

    @Test
    @DisplayName("Scénario 5 : Protection XSS - Neutralisation des balises script et HTML")
    void testScenario5_ProtectionXSS() {
        String xssPayload = "<script>alert('XSS')</script>";
        String escaped = ValidationUtil.escapeHtml(xssPayload);

        assertThat(escaped)
                .doesNotContain("<script>")
                .doesNotContain("</script>")
                .contains("&lt;script&gt;alert(&#x27;XSS&#x27;)&lt;&#x2F;script&gt;");

        // Même si la chaîne contient un script XSS, la validation ne crash pas
        ValidationResult result = ValidationUtil.validateDemandeInscription(
                xssPayload,
                "test@example.com",
                "1",
                dataStore
        );
        // Le nom a plus de 2 caractères, la structure est intacte et l'affichage sera protégé par c:out / escapeHtml
        assertThat(result).isNotNull();
    }

    @Test
    @DisplayName("Vérifie le rejet d'un identifiant d'atelier non numérique ou manquant")
    void testAtelierIdInvalide() {
        ValidationResult res1 = ValidationUtil.validateDemandeInscription("Test", "t@e.com", "abc", dataStore);
        assertThat(res1.isValid()).isFalse();
        assertThat(res1.getErreurs()).anyMatch(err -> err.contains("numérique"));

        ValidationResult res2 = ValidationUtil.validateDemandeInscription("Test", "t@e.com", null, dataStore);
        assertThat(res2.isValid()).isFalse();

        ValidationResult res3 = ValidationUtil.validateDemandeInscription("Test", "t@e.com", "-1", dataStore);
        assertThat(res3.isValid()).isFalse();
    }
}

