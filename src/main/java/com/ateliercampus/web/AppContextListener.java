package com.ateliercampus.web;

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
        try { com.ateliercampus.dao.Database.initialize(getClass().getClassLoader());
            sce.getServletContext().log("AtelierCampus JDBC initialisé : " + com.ateliercampus.dao.Database.getUrl());
        } catch (Exception e) { throw new IllegalStateException("Initialisation de la base AtelierCampus impossible.", e); }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        sce.getServletContext().log("AtelierCampus arrêté.");
    }
}

