package com.ateliercampus.model;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;
import java.util.Objects;

/**
 * Modèle représentant une inscription d'un étudiant à un atelier.
 * Conforme au modèle minimal commun : id, étudiant, atelier, dateInscription, statut CONFIRMEE ou ANNULEE.
 * Le couple étudiant/atelier est unique.
 */
public class Inscription implements Serializable {
    private static final long serialVersionUID = 1L;

    public enum Statut {
        CONFIRMEE,
        ANNULEE
    }

    private Long id;
    private Etudiant etudiant;
    private Atelier atelier;
    private LocalDateTime dateInscription;
    private Statut statut;

    public Inscription() {
    }

    public Inscription(Long id, Etudiant etudiant, Atelier atelier, LocalDateTime dateInscription, Statut statut) {
        this.id = id;
        this.etudiant = etudiant;
        this.atelier = atelier;
        this.dateInscription = dateInscription;
        this.statut = statut;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Etudiant getEtudiant() {
        return etudiant;
    }

    public void setEtudiant(Etudiant etudiant) {
        this.etudiant = etudiant;
    }

    public Atelier getAtelier() {
        return atelier;
    }

    public void setAtelier(Atelier atelier) {
        this.atelier = atelier;
    }

    public LocalDateTime getDateInscription() {
        return dateInscription;
    }

    public void setDateInscription(LocalDateTime dateInscription) {
        this.dateInscription = dateInscription;
    }

    public Statut getStatut() {
        return statut;
    }

    public void setStatut(Statut statut) {
        this.statut = statut;
    }

    public String getDateInscriptionFormattee() {
        if (dateInscription == null) return "";
        return dateInscription.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm", Locale.FRENCH));
    }

    public boolean isConfirmee() {
        return Statut.CONFIRMEE.equals(statut);
    }

    public boolean isAnnulee() {
        return Statut.ANNULEE.equals(statut);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Inscription that = (Inscription) o;
        return Objects.equals(id, that.id) ||
                (Objects.equals(etudiant, that.etudiant) && Objects.equals(atelier, that.atelier));
    }

    @Override
    public int hashCode() {
        return Objects.hash(etudiant, atelier);
    }

    @Override
    public String toString() {
        return "Inscription{" +
                "id=" + id +
                ", etudiant=" + (etudiant != null ? etudiant.getNom() : "null") +
                ", atelier=" + (atelier != null ? atelier.getTitre() : "null") +
                ", statut=" + statut +
                '}';
    }
}

