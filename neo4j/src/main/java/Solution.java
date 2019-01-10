import org.neo4j.driver.v1.Session;
import org.neo4j.driver.v1.StatementResult;

import static org.neo4j.driver.v1.Values.parameters;

public class Solution {
    private Session session;

    public Solution(Session session) {
        this.session = session;
    }

    public void runAllTests() {
        System.out.println(findActorByName("Emma Watson"));
        System.out.println(findMovieByTitleLike("Star Wars"));
        System.out.println(findRatedMoviesForUser("maheshksp"));
        System.out.println(findCommonMoviesForActors("Emma Watson", "Daniel Radcliffe"));
        System.out.println(findMovieRecommendationForUser("emileifrem"));
        System.out.println(4);
        System.out.println(findActorByName("Jan Kowalski"));
        System.out.println(findMovieByTitleLike("Nowy film"));
        System.out.println(findMoviesForActor("Jan Kowalski"));
        System.out.println(5);
        System.out.println(getActorData("Jan Kowalski"));
        System.out.println(6);
        System.out.println(findActorsActingInMoreThan(6));
        System.out.println(7);
        System.out.println(getAvgActsInForActorsActingInMoreThan(7));
        System.out.println(8);
        System.out.println(findActorsActAndDirMoreThan(5, 1));
        System.out.println(9);
        System.out.println(findFriendsRatingMovieAtLeast("maheshksp", 3));
        System.out.println(10);
        System.out.println(findPathsBetweenActors("Jake Gyllenhaal", "Bradley Cooper", 4));
        System.out.println(11);
        System.out.println("Average of 25 executions without index: " + measureQueryExecutionTime());
        addActorIndex();
        System.out.println("Average of 25 executions with index: " + measureQueryExecutionTime());
        dropActorIndex();
    }

    private String findActorByName(final String actorName) {
        StatementResult result = session.run("MATCH (p:Person{name:$name}) RETURN p.name", parameters("name", actorName));
        return result.list().toString();
    }

    private String findMovieByTitleLike(final String movieName) {
        StatementResult result = session.run("MATCH (m:Movie) WHERE m.title CONTAINS $title RETURN m.title", parameters("title", movieName));
        return result.list().toString();
    }

    private String findRatedMoviesForUser(final String userLogin) {
        StatementResult result = session.run("MATCH (u:User{login:$login})-[:RATED]->(m:Movie) RETURN m.title", parameters("login", userLogin));
        return result.list().toString();
    }

    private String findCommonMoviesForActors(String actorOne, String actorTwo) {
        StatementResult result = session.run
                ("MATCH (p1:Person{name:$act1})-[:ACTS_IN]->(m:Movie)<-[:ACTS_IN]-(p2:Person{name:$act2}) RETURN m.title", parameters("act1", actorOne, "act2", actorTwo));
        return result.list().toString();
    }

    private String findMovieRecommendationForUser(final String userLogin) {
        StatementResult result = session.run("MATCH (u:Person{login:$userLogin})-[:RATED]->(m:Movie)<-[:RATED]-(u2)-[:RATED]->(movies) return movies.title",
                parameters("userLogin", userLogin));
        return result.list().toString();
    }

    // zadanie 4
    public void addActorAndMovie(String actorName, String movieTitle) {
        session.run("CREATE(a:Person{name:$name}) RETURN a", parameters("name", actorName));
        session.run("CREATE(m:Movie{title:$title}) RETURN m", parameters("title", movieTitle));
        session.run("MATCH (p:Person{name:$name}),(m:Movie{title:$title}) CREATE (p)-[r:ACTS_IN]->(m)", parameters("name", actorName, "title", movieTitle));
    }

    // test
    private String findMoviesForActor(String actorName) {
        StatementResult result = session.run("MATCH (p:Person{name:$name})-[:ACTS_IN]->(m:Movie) RETURN m.title", parameters("name", actorName));
        return result.list().toString();
    }

    // zadanie 5
    public void setActorBirthData(String actorName, int birthDay, int birthMonth, int birthYear, String birthPlace) {
        session.run("MATCH (p:Person{name:$name}) SET p.birthday=date({day:$day, month:$month, year:$year}), p.birthplace=$place"
                , parameters("name", actorName, "day", birthDay, "month", birthMonth, "year", birthYear, "place", birthPlace));
    }

    // test
    private String getActorData(String actorName) {
        StatementResult result = session.run("MATCH (p:Person{name:$name}) RETURN p.name, p.birthday, p.birthplace", parameters("name", actorName));
        return result.list().toString();
    }

    // zadanie 6
    private String findActorsActingInMoreThan(int number) {
        StatementResult result = session.run("MATCH (p:Person)-[:ACTS_IN]->(m:Movie) WITH p,COUNT(m) AS cnt WHERE cnt>=$num RETURN COLLECT(p.name)", parameters("num", number));
        return result.list().toString();
    }

    // zadanie 7
    private String getAvgActsInForActorsActingInMoreThan(int number) {
        StatementResult result = session.run("MATCH (p:Person)-[:ACTS_IN]->(m:Movie) WITH p,COUNT(m) AS cnt WHERE cnt>=$num RETURN AVG(cnt)", parameters("num", number));
        return result.list().toString();
    }

    // zadanie 8
    private String findActorsActAndDirMoreThan(int acted, int directed) {
        StatementResult result = session.run(
                "MATCH (dir:Movie)<-[:DIRECTED]-(p:Person)-[:ACTS_IN]->(act:Movie) WITH p, COUNT(DISTINCT dir) AS cntdir, COUNT(DISTINCT act) AS cntact " +
                        "WHERE cntact>=$actnum AND cntdir>=$dirnum RETURN p.name, cntact, cntdir ORDER BY cntact DESC, cntdir DESC", parameters("actnum", acted, "dirnum", directed));
        return result.list().toString();
    }

    // zadanie 9
    private String findFriendsRatingMovieAtLeast(String userLogin, int stars) {
        StatementResult result = session.run("MATCH (u:User{login:$login})-[:FRIEND]-(f:User)-[r:RATED]->(m:Movie) WHERE r.stars>=$stars RETURN f.name, m.title, r.stars",
                parameters("login", userLogin, "stars", stars));
        return result.list().toString();
    }

    // zadanie 10
    private String findPathsBetweenActors(String actorOne, String actorTwo, int maxLength) {
        //TODO
        StatementResult result = session.run("MATCH path=(p1:Person{name:$act1})-[*1..4]-(p2:Person{name:$act2}) RETURN path",
                parameters("act1", actorOne, "act2", actorTwo, "len", maxLength));
        return result.list().toString();
    }

    // zadanie 11
    private void addActorIndex() {
        session.run("CREATE INDEX ON :Actor(name)");
    }

    private void dropActorIndex() {
        session.run("DROP INDEX ON :Actor(name)");
    }

    private String findShortestPath(String actorOne, String actorTwo) {
        StatementResult result = session.run("MATCH p = shortestPath((p1:Person{name:$act1})-[*]-(p2:Person{name:$act2})) RETURN p"
                , parameters("act1", actorOne, "act2", actorTwo));
        return result.list().toString();
    }

    private double measureQueryExecutionTime() {
        long startTime = System.nanoTime();
        for (int i = 0; i < 5; i++) {
            findShortestPath("Jake Gyllenhaal", "Bradley Cooper");
            findShortestPath("Keanu Reeves", "Vin Diesel");
            findShortestPath("Leonardo DiCaprio", "Helena Bonham Carter");
            findShortestPath("Hugh Jackman", "Scarlett Johansson");
            findShortestPath("Charlize Theron", "Rosamund Pike");
        }
        long endTime = System.nanoTime();
        return (endTime - startTime) / 1000000000.0 / 25;
    }

}