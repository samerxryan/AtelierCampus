<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- 
    Composant de traitement des demandes d'inscription.
    Conforme aux spécifications JEE : délègue de manière sécurisée au servlet de contrôle TraitementServlet.
    Empêche tout accès direct en GET non autorisé.
--%>
<%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        request.getRequestDispatcher("/traitement").forward(request, response);
    } else {
        response.sendRedirect(request.getContextPath() + "/catalogue.jsp");
    }
%>

