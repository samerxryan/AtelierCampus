package com.ateliercampus.dao;

import java.io.*;
import java.nio.file.*;
import java.sql.*;
import org.h2.tools.RunScript;
import org.mindrot.jbcrypt.BCrypt;

/** Configuration JDBC H2 fichier; les variables d’environnement peuvent remplacer les valeurs par défaut. */
public final class Database {
    private static final String URL = System.getProperty("ateliercampus.jdbc.url", System.getenv().getOrDefault("ATELIERCAMPUS_JDBC_URL",
            "jdbc:h2:file:" + Path.of(System.getProperty("user.home"), ".ateliercampus", "ateliercampus").toAbsolutePath()));
    private static final String USER = System.getenv().getOrDefault("ATELIERCAMPUS_DB_USER", "sa");
    private static final String PASSWORD = System.getenv().getOrDefault("ATELIERCAMPUS_DB_PASSWORD", "");
    private Database() {}
    public static Connection getConnection() throws SQLException { try { Class.forName("org.h2.Driver"); } catch (ClassNotFoundException e) { throw new SQLException("Pilote H2 indisponible.", e); } return DriverManager.getConnection(URL, USER, PASSWORD); }
    public static String getUrl() { return URL; }
    public static void initialize(ClassLoader loader) throws Exception {
        Path parent = Path.of(System.getProperty("user.home"), ".ateliercampus"); Files.createDirectories(parent);
        try (Connection c = getConnection()) {
            try (InputStream in = loader.getResourceAsStream("database/schema.sql")) { if (in == null) throw new FileNotFoundException("database/schema.sql"); RunScript.execute(c, new InputStreamReader(in, java.nio.charset.StandardCharsets.UTF_8)); }
            try (Statement s = c.createStatement()) { s.execute("CREATE TABLE IF NOT EXISTS Initialisation_Donnees (cle INTEGER PRIMARY KEY CHECK (cle=1))"); s.execute("INSERT INTO Initialisation_Donnees(cle) SELECT 1 WHERE NOT EXISTS (SELECT 1 FROM Initialisation_Donnees WHERE cle=1) AND EXISTS (SELECT 1 FROM Atelier)"); }
            try (InputStream in = loader.getResourceAsStream("database/data.sql")) { if (in == null) throw new FileNotFoundException("database/data.sql"); RunScript.execute(c, new InputStreamReader(in, java.nio.charset.StandardCharsets.UTF_8)); }
            try (Statement s = c.createStatement(); ResultSet r = s.executeQuery("SELECT COUNT(*) FROM Etudiant")) { r.next(); if (r.getInt(1)==0) {
                try (PreparedStatement p=c.prepareStatement("INSERT INTO Etudiant(nom,email,mot_de_passe,role) VALUES(?,?,?,?)")) {
                    String[][] users={{"Ahmed Ben Ali","ahmed@gmail.com","ETUDIANT"},{"Mohamed Trabelsi","mohamed@gmail.com","ETUDIANT"},{"Sami Mansour","sami@gmail.com","ETUDIANT"},{"Youssef Amri","youssef@gmail.com","ETUDIANT"},{"Karim Saidi","karim@gmail.com","ETUDIANT"},{"Gestionnaire AtelierCampus","gestionnaire@ateliercampus.local","GESTIONNAIRE"}};
                    for(String[] u:users){p.setString(1,u[0]);p.setString(2,u[1]);p.setString(3,BCrypt.hashpw(u[2].equals("ETUDIANT")?"Etudiant2026!":"Gestionnaire2026!",BCrypt.gensalt(12)));p.setString(4,u[2]);p.addBatch();} p.executeBatch();
                }
                try (Statement st=c.createStatement()) { st.execute("INSERT INTO Inscription(etudiant_id,atelier_id,date_inscription,statut) SELECT 1,1,CURRENT_TIMESTAMP,'CONFIRMEE' WHERE NOT EXISTS(SELECT 1 FROM Inscription)"); st.execute("INSERT INTO Inscription(etudiant_id,atelier_id,date_inscription,statut) SELECT 2,1,CURRENT_TIMESTAMP,'ANNULEE' WHERE NOT EXISTS(SELECT 1 FROM Inscription WHERE etudiant_id=2 AND atelier_id=1)"); st.execute("INSERT INTO Inscription(etudiant_id,atelier_id,date_inscription,statut) SELECT 3,3,CURRENT_TIMESTAMP,'CONFIRMEE' WHERE NOT EXISTS(SELECT 1 FROM Inscription WHERE etudiant_id=3 AND atelier_id=3)"); st.execute("INSERT INTO Inscription(etudiant_id,atelier_id,date_inscription,statut) SELECT 4,3,CURRENT_TIMESTAMP,'CONFIRMEE' WHERE NOT EXISTS(SELECT 1 FROM Inscription WHERE etudiant_id=4 AND atelier_id=3)"); st.execute("INSERT INTO Inscription(etudiant_id,atelier_id,date_inscription,statut) SELECT 5,3,CURRENT_TIMESTAMP,'CONFIRMEE' WHERE NOT EXISTS(SELECT 1 FROM Inscription WHERE etudiant_id=5 AND atelier_id=3)"); }
            }}
        }
    }
}
