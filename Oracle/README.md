1. Tabele  
Wycieczki (id_wycieczki, nazwa, kraj, data, opis, liczba_miejsc)  
Osoby(id_osoby, imie, nazwisko, pesel,kontakt)  
Rezerwacje(nr_rezerwacji, id_wycieczki, id_osoby, status)  
Pole status w tabeli Rezerwacje może przyjmować jedną z 4 wartości  
N – Nowa  
P – Potwierdzona  
Z – Potwierdzona i zapłacona  
A – Anulowana  
  
  
2. Tworzenie widoków. Należy przygotować kilka widoków ułatwiających dostęp do danych  
a) wycieczki_osoby(kraj,data, nazwa_wycieczki, imie, nazwisko,status_rezerwacji)  
b) wycieczki_osoby_potwierdzone (kraj,data, nazwa_wycieczki, imie, nazwisko,status_rezerwacji)  
c) wycieczki_przyszle (kraj,data, nazwa_wycieczki, imie, nazwisko,status_rezerwacji)  
d) wycieczki_miejsca(kraj,data, nazwa_wycieczki,liczba_miejsc, liczba_wolnych_miejsc)  
e) dostępne_wyciezki(kraj,data, nazwa_wycieczki,liczba_miejsc, liczba_wolnych_miejsc)  
f) rezerwacje_do_ anulowania – lista niepotwierdzonych rezerwacji które powinne zostać anulowane, rezerwacje przygotowywane są do anulowania na tydzień przed wyjazdem)  
  
  
3. Tworzenie procedur/funkcji pobierających dane. Podobnie jak w poprzednim przykładzie należy
przygotować kilka procedur ułatwiających dostęp do danych  
a) uczestnicy_wycieczki (id_wycieczki), procedura ma zwracać podobny zestaw danych jak
widok wycieczki_osoby  
b) rezerwacje_osoby(id_osoby), procedura ma zwracać podobny zestaw danych jak widok
wycieczki_osoby  
c) przyszle_rezerwacje_osoby(id_osoby)  
d) dostepne_wycieczki(kraj, data_od, data_do)  
Procedury/funkcje powinny zwracać tabelę/zbiór wynikowy  
Należy zwrócić uwagę na kontrolę parametrów (np. jeśli parametrem jest id_wycieczki to należy
sprawdzić czy taka wycieczka istnieje)  
  
  
4. Tworzenie procedur modyfikujących dane. Należy przygotować zestaw procedur pozwalających
na modyfikację danych oraz kontrolę poprawności ich wprowadzania  
a) dodaj_rezerwacje(id_wycieczki, id_osoby), procedura powinna kontrolować czy wycieczka
jeszcze się nie odbyła, i czy sa wolne miejsca  
b) zmien_status_rezerwacji(id_rezerwacji, status), procedura kontrolować czy możliwa jest
zmiana statusu, np. zmiana statusu już anulowanej wycieczki (przywrócenie do stanu
aktywnego nie zawsze jest możliwe)  
c) zmien_liczbe_miejsc(id_wycieczki, liczba_miejsc), nie wszystkie zmiany liczby miejsc są
dozwolone, nie można zmniejszyć liczby miesc na wartość poniżej liczby zarezerwowanych
miejsc  
Należy rozważyć użycie transakcji
Należy zwrócić uwagę na kontrolę parametrów (np. jeśli parametrem jest id_wycieczki to należy
sprawdzić czy taka wycieczka istnieje, jeśli robimy rezerwację to należy sprawdzać czy są wolne
miejsca)  
  

5. Dodajemy tabelę dziennikującą zmiany statusu rezerwacji
rezerwacje_log(id, id_rezerwacji, data, status)  
Należy zmienić warstwę procedur modyfikujących dane tak aby dopisywały informację do
dziennika  
6. Zmiana struktury bazy danych, w tabeli wycieczki dodajemy redundantne pole
liczba_wolnych_miejsc  
Należy zmodyfikować zestaw widoków. Proponuję dodać kolejne widoki (np. z sufiksem 2), które
pobierają informację o wolnych miejscach z nowo dodanego pola.  
Należy napisać procedurę przelicz która zaktualizuje wartość liczby wolnych miejsc dla już
istniejących danych  
Należy zmodyfikować warstwę procedur pobierających dane, podobnie jak w przypadku
widoków.  
Należy zmodyfikować procedury wprowadzające dane tak aby korzystały/aktualizowały pole
liczba _wolnych_miejsc w tabeli wycieczki  
Najlepiej to zrobić tworząc nowe wersje (np. z sufiksem 2)  
  
  

7. Zmiana strategii zapisywania do dziennika rezerwacji. Realizacja przy pomocy triggerów  
Należy wprowadzić zmianę która spowoduje że zapis do dziennika rezerwacji będzie realizowany
przy pomocy trigerów:  
triger obsługujący dodanie rezerwacji  
triger obsługujący zmianę statusu  
triger zabraniający usunięcia rezerwacji  
Oczywiście po wprowadzeniu tej zmiany należy uaktualnić procedury modyfikujące dane.  
Najlepiej to zrobić tworząc nowe wersje (np. z sufiksem 3)  

8. Zmiana strategii obsługi redundantnego pola liczba_wolnych_miejsc . realizacja przy pomocy
trigerów  
triger obsługujący dodanie rezerwacji  
triger obsługujący zmianę statusu  
triger obsługujący zmianę liczby miejsc na poziomie wycieczki  
Oczywiście po wprowadzeniu tej zmiany należy uaktualnić procedury modyfikujące dane.  
Najlepiej to zrobić tworząc nowe wersje (np. z sufiksem 3)
