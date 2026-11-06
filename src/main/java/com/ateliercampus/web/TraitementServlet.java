package com.ateliercampus.web;

import com.ateliercampus.data.DataStore;
import com.ateliercampus.model.Atelier;
import com.ateliercampus.util.ValidationResult;
import com.ateliercampus.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

/**
 * Contrôleur de traitement des demandes d'inscription aux ateliers.
 * Gère la validation serveur, la protection contre les injections XSS,
 * le réaffichage en cas d'erreur et la génération du récapitulatif de simulation.
 */
@WebServlet(name = "TraitementServlet", urlPatterns = {"/traitement", "/traitement.jsp"})
public class TraitementServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // L'accès direct en GET au traitement n'est pas permis ; redirection sécurisée vers le catalogue
        response.sendRedirect(request.getContextPath() + "/catalogue.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Encodage strict en UTF-8 pour supporter les accents et caractères spéciaux
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String nom = request.getParameter("nom");
        String email = request.getParameter("email");
        String atelierIdStr = request.getParameter("atelierId");

        DataStore dataStore = (DataStore) getServletContext().getAttribute("dataStore");
        if (dataStore == null) {
            dataStore = DataStore.getInstance();
            getServletContext().setAttribute("dataStore", dataStore);
        }

        // Validation stricte côté serveur
        ValidationResult validation = ValidationUtil.validateDemandeInscription(nom, email, atelierIdStr, dataStore);

        if (validation.hasErrors()) {
            // En cas d'erreur de validation : retour au formulaire avec conservation des données saisies
            request.setAttribute("erreurs", validation.getErreurs());
            request.setAttribute("nom", nom);
            request.setAttribute("email", email);
            request.setAttribute("atelierId", atelierIdStr);

            // Tente de récupérer l'atelier si l'identifiant était valide
            if (atelierIdStr != null) {
                try {
                    long id = Long.parseLong(atelierIdStr.trim());
                    Atelier atelier = dataStore.getAtelierById(id);
                    if (atelier != null) {
                        request.setAttribute("atelier", atelier);
                    }
                } catch (NumberFormatException ignored) {
                    // ID non numérique déjà consigné dans les erreurs
                }
            }

            request.getRequestDispatcher("/inscription.jsp").forward(request, response);
            return;
        }

        // Succès de la validation : préparation de la simulation (aucune persistance en base)
        long id = Long.parseLong(atelierIdStr.trim());
        Atelier atelier = dataStore.getAtelierById(id);

        request.setAttribute("etudiantNom", nom);
        request.setAttribute("etudiantEmail", email);
        request.setAttribute("atelier", atelier);
        request.setAttribute("dateDemande", 
                LocalDateTime.now().format(DateTimeFormatter.ofPattern("EEEE d MMMM yyyy 'à' HH'h'mm", Locale.FRENCH)));
        request.setAttribute("simulationNotice", "Demande simulée, non enregistrée.");

        // Redirection interne vers la vue récapitulative
        request.getRequestDispatcher("/recapitulatif.jsp").forward(request, response);
    }
}

