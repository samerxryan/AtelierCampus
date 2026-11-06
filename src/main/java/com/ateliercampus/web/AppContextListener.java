package com.ateliercampus.web;

import com.ateliercampus.data.DataStore;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

/**
 * Initialisateur du contexte applicatif pour AtelierCampus.
 * Met à disposition l'instance unique du DataStore dans le scope application
 * afin de permettre son accès transparent depuis les expressions EL (${dataStore...}).
 */
@WebListener
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        DataStore dataStore = DataStore.getInstance();
        sce.getServletContext().setAttribute("dataStore", dataStore);
        sce.getServletContext().log("AtelierCampus initialisé avec succès : " + 
                dataStore.getAteliers().size() + " ateliers et " + 
                dataStore.getEtudiants().size() + " étudiants enregistrés en mémoire.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        sce.getServletContext().removeAttribute("dataStore");
    }
}

