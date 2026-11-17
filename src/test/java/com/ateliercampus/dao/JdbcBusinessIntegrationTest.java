package com.ateliercampus.dao;

import com.ateliercampus.model.Atelier;
import com.ateliercampus.service.AtelierService;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.concurrent.*;
import static org.junit.jupiter.api.Assertions.*;

class JdbcBusinessIntegrationTest {
    @BeforeAll static void initializeDatabase() throws Exception {
        System.setProperty("ateliercampus.jdbc.url", "jdbc:h2:mem:ateliercampus-tests;DB_CLOSE_DELAY=-1;LOCK_TIMEOUT=10000");
        Database.initialize(JdbcBusinessIntegrationTest.class.getClassLoader());
    }
    private long atelier(String title, LocalDateTime date, int capacity) throws Exception {
        try(Connection c=Database.getConnection();PreparedStatement p=c.prepareStatement("INSERT INTO Atelier(titre,description,date_heure,capacite) VALUES(?,?,?,?)",Statement.RETURN_GENERATED_KEYS)){
            p.setString(1,title);p.setString(2,"Description de test");p.setTimestamp(3,Timestamp.valueOf(date));p.setInt(4,capacity);p.executeUpdate();try(ResultSet r=p.getGeneratedKeys()){r.next();return r.getLong(1);}
        }
    }
    private int count(long atelier) throws Exception {return new AtelierDao().countConfirmed(atelier);}

    @Test void inscriptionEtAnnulationReactivateLeMemeEnregistrement() throws Exception {
        long a=atelier("Atelier transactionnel",LocalDateTime.now().plusDays(2),1);InscriptionDao dao=new InscriptionDao();
        dao.inscrire(1,a);long original;try(Connection c=Database.getConnection();PreparedStatement p=c.prepareStatement("SELECT id FROM Inscription WHERE etudiant_id=1 AND atelier_id=?")){p.setLong(1,a);try(ResultSet r=p.executeQuery()){r.next();original=r.getLong(1);}}
        assertThrows(IllegalArgumentException.class,()->dao.inscrire(1,a));dao.annuler(1,original);assertEquals(0,count(a));dao.inscrire(1,a);
        try(Connection c=Database.getConnection();PreparedStatement p=c.prepareStatement("SELECT id,statut FROM Inscription WHERE etudiant_id=1 AND atelier_id=?")){p.setLong(1,a);try(ResultSet r=p.executeQuery()){r.next();assertEquals(original,r.getLong(1));assertEquals("CONFIRMEE",r.getString(2));}}
        assertEquals(1,count(a));
    }
    @Test void atelierCompletEtAtelierCommenceSontRefuses() throws Exception {
        long full=atelier("Atelier complet test",LocalDateTime.now().plusDays(2),1);InscriptionDao dao=new InscriptionDao();dao.inscrire(1,full);
        assertThrows(IllegalArgumentException.class,()->dao.inscrire(2,full));
        long past=atelier("Atelier passé test",LocalDateTime.now().minusMinutes(1),3);assertThrows(IllegalArgumentException.class,()->dao.inscrire(2,past));
    }
    @Test void etudiantNePeutPasAnnulerUneInscriptionDUnAutreEtudiant() throws Exception {
        long a=atelier("Atelier propriété test",LocalDateTime.now().plusDays(2),2);InscriptionDao dao=new InscriptionDao();dao.inscrire(1,a);long inscription;
        try(Connection c=Database.getConnection();PreparedStatement p=c.prepareStatement("SELECT id FROM Inscription WHERE etudiant_id=1 AND atelier_id=?")){p.setLong(1,a);try(ResultSet r=p.executeQuery()){r.next();inscription=r.getLong(1);}}
        assertThrows(IllegalArgumentException.class,()->dao.annuler(2,inscription));assertEquals(1,count(a));
    }
    @Test void deuxDemandesConcurentesNeDepassentPasLaCapacite() throws Exception {
        long a=atelier("Atelier concurrence",LocalDateTime.now().plusDays(2),1);InscriptionDao dao=new InscriptionDao();ExecutorService pool=Executors.newFixedThreadPool(2);CountDownLatch ready=new CountDownLatch(2),go=new CountDownLatch(1);
        Callable<Boolean> first=()->attempt(dao,1,a,ready,go),second=()->attempt(dao,2,a,ready,go);Future<Boolean> f1=pool.submit(first),f2=pool.submit(second);ready.await();go.countDown();int successes=(f1.get()?1:0)+(f2.get()?1:0);pool.shutdownNow();assertEquals(1,successes);assertEquals(1,count(a));
    }
    private boolean attempt(InscriptionDao dao,long student,long atelier,CountDownLatch ready,CountDownLatch go){ready.countDown();try{go.await();dao.inscrire(student,atelier);return true;}catch(Exception expected){return false;}}
    @Test void rechercheParametreeNeTraitePasLeTexteCommeSql() throws Exception {assertTrue(new AtelierDao().list("' OR 1=1 --").isEmpty());}
    @Test void suppressionEtReductionRespectentLesInscriptionsConfirmees() throws Exception {
        long a=atelier("Atelier protégé test",LocalDateTime.now().plusDays(2),2);new InscriptionDao().inscrire(1,a);new InscriptionDao().inscrire(2,a);Atelier atelier=new AtelierDao().find(a);atelier.setCapacite(1);
        assertThrows(IllegalArgumentException.class,()->new AtelierService().save(atelier));assertThrows(SQLException.class,()->new AtelierDao().delete(a));assertEquals(2,count(a));
    }
}
