<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    </main>

    <footer class="site-footer">
        <div class="footer-inner-grid">
            <div class="footer-col-main">
                <div class="footer-brand-title">Atelier<span style="color: var(--accent-cyan);">Campus</span></div>
                <p class="footer-brand-desc">
                    Plateforme officielle de l'Université Centrale dédiée au perfectionnement technique en cybersécurité. 
                    Des ateliers pratiques encadrés par des spécialistes pour développer des compétences avancées en défense 
                    des systèmes d'information et audit de sécurité.
                </p>
            </div>

            <div class="footer-col-nav">
                <div class="footer-heading-col">Navigation</div>
                <ul class="footer-nav-links">
                    <li><a href="${pageContext.request.contextPath}/index.jsp">Accueil</a></li>
                    <li><a href="${pageContext.request.contextPath}/catalogue.jsp">Catalogue des ateliers</a></li>
                    <li><a href="${pageContext.request.contextPath}/catalogue.jsp">Calendrier des sessions</a></li>
                </ul>
            </div>

            <div class="footer-col-contact">
                <div class="footer-heading-col">Université Centrale</div>
                <ul class="footer-contact-info">
                    <li class="footer-contact-row">
                        <span class="footer-contact-icon">
                            <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/>
                                <circle cx="12" cy="10" r="3"/>
                            </svg>
                        </span>
                        <span>Campus Universitaire • Tunis, Tunisie</span>
                    </li>
                    <li class="footer-contact-row">
                        <span class="footer-contact-icon">
                            <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <rect width="20" height="16" x="2" y="4" rx="2"/>
                                <path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/>
                            </svg>
                        </span>
                        <span>contact@universitecentrale.tn</span>
                    </li>
                    <li class="footer-contact-row">
                        <span class="footer-contact-icon">
                            <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                            </svg>
                        </span>
                        <span>Pôle Cybersécurité &amp; Systèmes Embarqués</span>
                    </li>
                </ul>
            </div>
        </div>

        <div class="footer-bottom-bar">
            <div class="footer-bottom-wrap">
                <p>&copy; 2026 Université Centrale • Département Génie Informatique &amp; Cybersécurité. Tous droits réservés.</p>
                <div class="footer-legal-links">
                    <a href="${pageContext.request.contextPath}/catalogue.jsp">Règlement des ateliers</a>
                    <span>•</span>
                    <a href="${pageContext.request.contextPath}/catalogue.jsp">Protection des données</a>
                </div>
            </div>
        </div>
    </footer>
</body>
</html>
