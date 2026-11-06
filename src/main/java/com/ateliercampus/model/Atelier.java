package com.ateliercampus.model;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;
import java.util.Objects;

/**
 * Modèle représentant un atelier de cybersécurité.
 * Conforme au modèle minimal commun : id, titre, description, dateHeure, capacite strictement positive.
 */
public class Atelier implements Serializable {
    private static final long serialVersionUID = 1L;

    public static final DateTimeFormatter FORMATTER_FR = 
            DateTimeFormatter.ofPattern("EEEE d MMMM yyyy 'à' HH'h'mm", Locale.FRENCH);
    public static final DateTimeFormatter FORMATTER_COURT = 
            DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm", Locale.FRENCH);

    private Long id;
    private String titre;
    private String descriptionCourte;
    private String description;
    private LocalDateTime dateHeure;
    private int capacite; // Strictement positive
    private String animateur;
    private String salle;
    private String niveau;

    public Atelier() {
    }

    public Atelier(Long id, String titre, String descriptionCourte, String description, 
                   LocalDateTime dateHeure, int capacite, String animateur, String salle, String niveau) {
        if (capacite <= 0) {
            throw new IllegalArgumentException("La capacité d'un atelier doit être strictement positive.");
        }
        this.id = id;
        this.titre = titre;
        this.descriptionCourte = descriptionCourte;
        this.description = description;
        this.dateHeure = dateHeure;
        this.capacite = capacite;
        this.animateur = animateur;
        this.salle = salle;
        this.niveau = niveau;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitre() {
        return titre;
    }

    public void setTitre(String titre) {
        this.titre = titre;
    }

    public String getDescriptionCourte() {
        return descriptionCourte;
    }

    public void setDescriptionCourte(String descriptionCourte) {
        this.descriptionCourte = descriptionCourte;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public LocalDateTime getDateHeure() {
        return dateHeure;
    }

    public void setDateHeure(LocalDateTime dateHeure) {
        this.dateHeure = dateHeure;
    }

    public int getCapacite() {
        return capacite;
    }

    public void setCapacite(int capacite) {
        if (capacite <= 0) {
            throw new IllegalArgumentException("La capacité d'un atelier doit être strictement positive.");
        }
        this.capacite = capacite;
    }

    public String getAnimateur() {
        return animateur;
    }

    public void setAnimateur(String animateur) {
        this.animateur = animateur;
    }

    public String getSalle() {
        return salle;
    }

    public void setSalle(String salle) {
        this.salle = salle;
    }

    public String getNiveau() {
        return niveau;
    }

    public void setNiveau(String niveau) {
        this.niveau = niveau;
    }

    /**
     * Retourne la date formatée en français (ex: "vendredi 20 novembre 2026 à 14h00").
     */
    public String getDateHeureFormattee() {
        if (dateHeure == null) return "";
        String s = dateHeure.format(FORMATTER_FR);
        return Character.toUpperCase(s.charAt(0)) + s.substring(1);
    }

    /**
     * Retourne la date au format court (ex: "20/11/2026 14:00").
     */
    public String getDateHeureCourte() {
        if (dateHeure == null) return "";
        return dateHeure.format(FORMATTER_COURT);
    }

    /**
     * Indique si l'atelier a déjà commencé par rapport au temps actuel.
     */
    public boolean isPasse() {
        if (dateHeure == null) return false;
        return dateHeure.isBefore(LocalDateTime.now());
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Atelier atelier = (Atelier) o;
        return Objects.equals(id, atelier.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

    @Override
    public String toString() {
        return "Atelier{" +
                "id=" + id +
                ", titre='" + titre + '\'' +
                ", dateHeure=" + dateHeure +
                ", capacite=" + capacite +
                '}';
    }
}

