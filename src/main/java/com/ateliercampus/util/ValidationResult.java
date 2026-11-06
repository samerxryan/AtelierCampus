package com.ateliercampus.util;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Objet encapsulant le résultat de validation d'un formulaire.
 * Contient les messages d'erreurs éventuels et l'état de validité.
 */
public class ValidationResult implements Serializable {
    private static final long serialVersionUID = 1L;

    private final List<String> erreurs = new ArrayList<>();

    public void addError(String message) {
        if (message != null && !message.trim().isEmpty()) {
            erreurs.add(message.trim());
        }
    }

    public boolean isValid() {
        return erreurs.isEmpty();
    }

    public boolean hasErrors() {
        return !erreurs.isEmpty();
    }

    public List<String> getErreurs() {
        return Collections.unmodifiableList(erreurs);
    }

    public String getPremierMessage() {
        return erreurs.isEmpty() ? "" : erreurs.get(0);
    }
}

