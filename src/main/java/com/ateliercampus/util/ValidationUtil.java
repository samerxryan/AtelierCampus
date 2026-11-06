package com.ateliercampus.util;

import com.ateliercampus.data.DataStore;
import com.ateliercampus.model.Atelier;

import java.util.regex.Pattern;

/**
 * Utilitaire de validation et de sécurité pour les saisies utilisateur.
 * Implémente une vérification stricte côté serveur sans faire confiance aux contrôles clients.
 */
public final class ValidationUtil {

    // Motif strict pour la validation du format de l'email
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$"
    );

    private ValidationUtil() {
        // Empêche l'instanciation
    }

    /**
     * Valide l'ensemble des données d'une demande d'inscription.
     *
     * @param nom       Nom complet soumis par l'étudiant
     * @param email     Email soumis
     * @param atelierId Identifiant de l'atelier
     * @param dataStore Magasin de données pour vérifier l'existence de l'atelier
     * @return ValidationResult contenant la liste des erreurs éventuelles
     */
    public static ValidationResult validateDemandeInscription(String nom, String email, String atelierId, DataStore dataStore) {
        ValidationResult result = new ValidationResult();

        // 1. Validation du nom de l'étudiant
        if (nom == null || nom.trim().isEmpty()) {
            result.addError("Le nom de l'étudiant est obligatoire et ne peut pas être vide.");
        } else if (nom.trim().length() < 2) {
            result.addError("Le nom de l'étudiant doit comporter au moins 2 caractères.");
        } else if (nom.trim().length() > 100) {
            result.addError("Le nom de l'étudiant ne peut pas dépasser 100 caractères.");
        }

        // 2. Validation de l'email
        if (email == null || email.trim().isEmpty()) {
            result.addError("L'adresse email est obligatoire.");
        } else if (!EMAIL_PATTERN.matcher(email.trim()).matches()) {
            result.addError("Le format de l'adresse email est invalide. Exemple attendu : etudiant@exemple.com");
        } else if (email.trim().length() > 120) {
            result.addError("L'adresse email ne peut pas dépasser 120 caractères.");
        }

        // 3. Validation de l'identifiant de l'atelier
        if (atelierId == null || atelierId.trim().isEmpty()) {
            result.addError("L'identifiant de l'atelier est requis.");
        } else {
            try {
                long id = Long.parseLong(atelierId.trim());
                if (id <= 0) {
                    result.addError("L'identifiant de l'atelier doit être un entier strictement positif.");
                } else if (dataStore == null || dataStore.getAtelierById(id) == null) {
                    result.addError("L'atelier spécifié (ID: " + escapeHtml(atelierId.trim()) + ") n'existe pas dans le catalogue.");
                }
            } catch (NumberFormatException e) {
                result.addError("L'identifiant de l'atelier doit être une valeur numérique entière valide.");
            }
        }

        return result;
    }

    /**
     * Échappe les caractères sensibles HTML pour neutraliser toute tentative d'injection XSS.
     * Utilisé comme protection de défense en profondeur en complément de JSTL c:out.
     */
    public static String escapeHtml(String input) {
        if (input == null) return "";
        return input.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#x27;")
                    .replace("/", "&#x2F;");
    }
}

