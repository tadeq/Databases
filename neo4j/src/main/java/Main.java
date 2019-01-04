import org.neo4j.driver.v1.*;

public class Main {
    public static void main(String[] args) {
        Driver driver = GraphDatabase.driver("bolt://localhost", AuthTokens.basic("neo4j", "student"));
        Session session = driver.session();
        Solution solution = new Solution(session);
        //solution.addActorAndMovie("Jan Kowalski","Nowy film"); // zadanie 4
        //solution.setActorBirthData("Jan Kowalski",1,10,1995,"Kraków"); //zadanie 5
        solution.runAllTests();
        session.close();
        driver.close();
    }
}
