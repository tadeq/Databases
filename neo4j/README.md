1. Zainstalować [serwer neo4j](https://neo4j.com/download-center/#releases) lokalnie 
2. Wgrać [bazę](https://neo4j.com/developer/movie-database/)
3. Zaimplementować metody z klasy Solution (z katalogu src, można od początku stworzyć projekt,
    można zmienić użytkowników w zapytaniach). Można korzystać też z JDBC

Dodatkowo:

4. Stworzyć dwa nowe węzły reprezentujące film oraz aktora, następnie stworzyć relacje ich
    łączącą (np. ACTS_IN)
5. Ustawić zapytaniem pozostałe właściwości nowo dodanego węzła reprezentującego aktora (np.
    Birthplace, birthdate)
6. Zapytanie o aktorów którzy grali w co najmniej 6 filmach (użyć _collect_ i _length_ )
7. Policzyć średnią wystąpień w filmach dla grupy aktorów, którzy wystąpili co najmniej 7 filmach
8. Wyświetlić aktorów, którzy zagrali w co najmniej pięciu filmach i wyreżyserowali co najmniej
    jeden film (z użyciem WITH), posortować ich wg liczby wystąpień w filmach
9. Zapytanie o znajomych wybranego usera którzy ocenili film na co najmniej trzy gwiazdki
    (wyświetlić znajomego, tytuł, liczbę gwiazdek)
10. Zapytanie o ścieżki między wybranymi aktorami (np.2), w ścieżkach mają nie znajdować się filmy
    (funkcja filter(), [x IN xs WHERE predicate | extraction])
11. Porównać czas wykonania zapytania o wybranego aktora bez oraz z indeksem w bazie
    nałożonym na atrybut name (DROP INDEX i CREATE INDEX oraz użyć komendy EXPLAIN lub
    PROFILE), dokonać porównania dla zapytania shortestPath pomiędzy dwoma wybranymi
    aktorami.
