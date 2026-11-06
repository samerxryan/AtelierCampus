package com.ateliercampus.web;

import com.ateliercampus.data.DataStore;
import com.ateliercampus.model.Atelier;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

class TraitementServletTest {

    private TraitementServlet servlet;
    private HttpServletRequest request;
    private HttpServletResponse response;
    private ServletContext servletContext;
    private ServletConfig servletConfig;
    private RequestDispatcher dispatcher;

    @BeforeEach
    void setUp() throws Exception {
        servlet = new TraitementServlet();
        request = mock(HttpServletRequest.class);
        response = mock(HttpServletResponse.class);
        servletContext = mock(ServletContext.class);
        servletConfig = mock(ServletConfig.class);
        dispatcher = mock(RequestDispatcher.class);

        when(servletConfig.getServletContext()).thenReturn(servletContext);
        when(servletContext.getAttribute("dataStore")).thenReturn(DataStore.getInstance());
        when(request.getRequestDispatcher(anyString())).thenReturn(dispatcher);

        servlet.init(servletConfig);
    }

    @Test
    @DisplayName("GET sur /traitement doit rediriger vers le catalogue")
    void testDoGetRedirectsToCatalogue() throws Exception {
        when(request.getContextPath()).thenReturn("/AtelierCampus");

        servlet.doGet(request, response);

        verify(response).sendRedirect("/AtelierCampus/catalogue.jsp");
        verify(dispatcher, never()).forward(any(), any());
    }

    @Test
    @DisplayName("POST avec données valides forwarde vers recapitulatif.jsp avec la notice de simulation")
    void testDoPostValidForwardToRecapitulatif() throws Exception {
        when(request.getParameter("nom")).thenReturn("Ahmed Ben Ali");
        when(request.getParameter("email")).thenReturn("ahmed@gmail.com");
        when(request.getParameter("atelierId")).thenReturn("1");

        servlet.doPost(request, response);

        verify(request).setAttribute(eq("etudiantNom"), eq("Ahmed Ben Ali"));
        verify(request).setAttribute(eq("etudiantEmail"), eq("ahmed@gmail.com"));
        verify(request).setAttribute(eq("atelier"), any(Atelier.class));
        verify(request).setAttribute(eq("simulationNotice"), eq("Demande simulée, non enregistrée."));

        verify(request).getRequestDispatcher("/recapitulatif.jsp");
        verify(dispatcher).forward(request, response);
    }

    @Test
    @DisplayName("POST avec email invalide forwarde vers inscription.jsp avec conservation des saisies")
    void testDoPostInvalidEmailForwardToInscription() throws Exception {
        when(request.getParameter("nom")).thenReturn("Ahmed Ben Ali");
        when(request.getParameter("email")).thenReturn("invalide-email");
        when(request.getParameter("atelierId")).thenReturn("1");

        servlet.doPost(request, response);

        verify(request).setAttribute(eq("nom"), eq("Ahmed Ben Ali"));
        verify(request).setAttribute(eq("email"), eq("invalide-email"));
        verify(request).setAttribute(eq("atelierId"), eq("1"));
        verify(request).setAttribute(eq("erreurs"), any(List.class));

        verify(request).getRequestDispatcher("/inscription.jsp");
        verify(dispatcher).forward(request, response);
    }

    @Test
    @DisplayName("POST avec nom vide forwarde vers inscription.jsp avec message d'erreur")
    void testDoPostEmptyNomForwardToInscription() throws Exception {
        when(request.getParameter("nom")).thenReturn("");
        when(request.getParameter("email")).thenReturn("test@gmail.com");
        when(request.getParameter("atelierId")).thenReturn("1");

        servlet.doPost(request, response);

        verify(request).setAttribute(eq("nom"), eq(""));
        verify(request).setAttribute(eq("email"), eq("test@gmail.com"));
        verify(request).setAttribute(eq("erreurs"), any(List.class));

        verify(request).getRequestDispatcher("/inscription.jsp");
        verify(dispatcher).forward(request, response);
    }

    @Test
    @DisplayName("POST avec atelier inconnu (9999) forwarde vers inscription.jsp avec message d'erreur")
    void testDoPostUnknownWorkshopForwardToInscription() throws Exception {
        when(request.getParameter("nom")).thenReturn("Test Student");
        when(request.getParameter("email")).thenReturn("test@gmail.com");
        when(request.getParameter("atelierId")).thenReturn("9999");

        servlet.doPost(request, response);

        verify(request).setAttribute(eq("atelierId"), eq("9999"));
        verify(request).setAttribute(eq("erreurs"), any(List.class));

        verify(request).getRequestDispatcher("/inscription.jsp");
        verify(dispatcher).forward(request, response);
    }
}

