package com.ateliercampus.model;

import java.io.Serializable;
import java.util.Objects;

/**
 * Modèle représentant un étudiant inscrit ou candidat aux ateliers.
 * Conforme au modèle minimal commun : id, nom non vide, email valide et unique.
 */
public class Etudiant implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private String nom;
    private String email;

    public Etudiant() {
    }

    public Etudiant(Long id, String nom, String email) {
        this.id = id;
        this.nom = nom;
        this.email = email;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Etudiant etudiant = (Etudiant) o;
        return Objects.equals(id, etudiant.id) || Objects.equals(email, etudiant.email);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, email);
    }

    @Override
    public String toString() {
        return "Etudiant{" +
                "id=" + id +
                ", nom='" + nom + '\'' +
                ", email='" + email + '\'' +
                '}';
    }
}

