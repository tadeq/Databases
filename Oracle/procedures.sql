CREATE OR REPLACE PROCEDURE uczestnicy_wycieczki(id_wyc IN number, uczestnicy OUT SYS_REFCURSOR)
IS
  ids NUMBER;
  BEGIN
    SELECT COUNT(*) INTO ids FROM WYCIECZKI WHERE ID_WYCIECZKI = id_wyc;
    IF (ids = 0)
    THEN
      RAISE_APPLICATION_ERROR(-20001, 'Nie ma wycieczki z takim ID');
    END IF;
    OPEN uczestnicy FOR
    SELECT w.ID_WYCIECZKI, w.NAZWA, w.KRAJ, w.DATA, w.IMIE, w.NAZWISKO, w.STATUS
    FROM WYCIECZKI_OSOBY w
    WHERE id_wyc = w.ID_WYCIECZKI;
  END;

CREATE OR REPLACE PROCEDURE rezerwacje_osoby(id_o IN number, rez_os OUT SYS_REFCURSOR)
IS
  ids NUMBER;
  BEGIN
    SELECT COUNT(*) INTO ids FROM OSOBY WHERE id_o = ID_OSOBY;
    IF (ids = 0)
    THEN
      RAISE_APPLICATION_ERROR(-20001, 'Nie ma osoby z takim ID');
    END IF;
    OPEN rez_os FOR
    SELECT w.ID_WYCIECZKI, w.NAZWA, w.KRAJ, w.DATA, o.IMIE, o.NAZWISKO, r.STATUS
    FROM WYCIECZKI w
           JOIN REZERWACJE r ON w.ID_WYCIECZKI = r.ID_WYCIECZKI
           JOIN OSOBY o ON r.ID_OSOBY = o.ID_OSOBY
    WHERE id_o = o.ID_OSOBY;
  END;

CREATE OR REPLACE PROCEDURE przyszle_rezerwacje_osoby(id_o IN number, rez OUT SYS_REFCURSOR)
IS
  ids NUMBER;
  BEGIN
    SELECT COUNT(*) INTO ids FROM OSOBY WHERE id_o = ID_OSOBY;
    IF (ids = 0)
    THEN
      RAISE_APPLICATION_ERROR(-20001, 'Nie ma osoby z takim ID');
    END IF;
    OPEN rez FOR
    SELECT w.ID_WYCIECZKI, w.NAZWA, w.KRAJ, w.DATA, o.IMIE, o.NAZWISKO, r.STATUS
    FROM WYCIECZKI w
           JOIN REZERWACJE r ON w.ID_WYCIECZKI = r.ID_WYCIECZKI
           JOIN OSOBY o ON r.ID_OSOBY = o.ID_OSOBY
    WHERE id_o = o.ID_OSOBY
      AND SYSDATE < w.DATA;
  end;

CREATE OR REPLACE PROCEDURE dostepne_wycieczki_(kraj IN  varchar2, data_od IN date, data_do IN date,
                                                wyc  OUT SYS_REFCURSOR)
IS
  BEGIN
    OPEN wyc FOR
    SELECT KRAJ, DATA, NAZWA, LICZBA_MIEJSC, LICZBA_WOLNYCH_MIEJSC
    FROM DOSTEPNE_WYCIECZKI
    WHERE KRAJ = kraj
      AND DATA BETWEEN data_od AND data_do;
  end;

CREATE OR REPLACE PROCEDURE dodaj_rezerwacje(id_wyc IN number, id_os IN NUMBER)
IS
  wolne_miejsca NUMBER;
  ids           NUMBER;
  data          DATE;
  BEGIN
    SELECT COUNT(*) INTO ids FROM OSOBY WHERE id_os = ID_OSOBY;
    IF (ids = 0)
    THEN
      RAISE_APPLICATION_ERROR(-20001, 'Nie ma osoby z takim ID');
    END IF;
    SELECT COUNT(*) INTO ids FROM WYCIECZKI WHERE id_wyc = ID_WYCIECZKI;
    IF (ids = 0)
    THEN
      RAISE_APPLICATION_ERROR(-20001, 'Nie ma wycieczki z takim ID');
    END IF;
    SELECT w.LICZBA_MIEJSC - COUNT(*) AS LICZBA_WOLNYCH_MIEJSC
        INTO wolne_miejsca
    FROM WYCIECZKI w
           LEFT JOIN REZERWACJE r on w.ID_WYCIECZKI = r.ID_WYCIECZKI
    WHERE r.STATUS in ('P', 'Z', 'N')
      AND w.ID_WYCIECZKI = id_wyc
    GROUP BY w.LICZBA_MIEJSC;
    IF (ids = 0)
    THEN
      RAISE_APPLICATION_ERROR(-20001, 'Brak wolnych miejsc');
    END IF;
    SELECT w.DATA INTO data FROM WYCIECZKI w WHERE id_wyc = w.ID_WYCIECZKI;
    IF data < SYSDATE
    THEN
      RAISE_APPLICATION_ERROR(-20001, 'Wycieczka już się odbyła');
    end if;
    INSERT INTO REZERWACJE (ID_WYCIECZKI, ID_OSOBY, STATUS) VALUES (id_wyc, id_os, 'N');
    COMMIT;
  end;


CREATE OR REPLACE PROCEDURE zmien_status_rezerwacji(id_rez IN number, stat IN CHAR)
IS
  miejsca      NUMBER;
  ids          NUMBER;
  id_wycieczki NUMBER;
  BEGIN
    SELECT COUNT(*) INTO ids FROM REZERWACJE WHERE id_rez = NR_REZERWACJI;
    IF (ids = 0)
    THEN
      RAISE_APPLICATION_ERROR(-20001, 'Nie ma takiej rezerwacji');
    END IF;
    SELECT r.ID_WYCIECZKI INTO id_wycieczki FROM REZERWACJE r WHERE id_rez = r.NR_REZERWACJI;
    SELECT w.LICZBA_MIEJSC - COUNT(*) AS LICZBA_WOLNYCH_MIEJSC
        INTO miejsca
    FROM WYCIECZKI w
           JOIN REZERWACJE r on w.ID_WYCIECZKI = r.ID_WYCIECZKI
    WHERE r.STATUS in ('P', 'Z', 'N')
    GROUP BY w.LICZBA_MIEJSC;
    IF miejsca < 1
    THEN
      RAISE_APPLICATION_ERROR(-20001, 'Brak miejsc na tą wycieczkę');
    end if;
    UPDATE REZERWACJE SET STATUS = stat WHERE NR_REZERWACJI = id_rez;
    INSERT INTO REZERWACJE_LOG (NR_REZERWACJI, DATA, STATUS) VALUES (id_rez, SYSDATE, stat);
    COMMIT;
  end;


CREATE OR REPLACE PROCEDURE zmien_liczbe_miejsc(id_wyc IN number, miejsca IN NUMBER)
IS
  ids        NUMBER;
  rezerwacje NUMBER;
  BEGIN
    SELECT COUNT(*) INTO ids FROM WYCIECZKI WHERE id_wyc = ID_WYCIECZKI;
    IF (ids = 0)
    THEN
      RAISE_APPLICATION_ERROR(-20001, 'Nie ma wycieczki z takim ID');
    END IF;
    SELECT COUNT(*) INTO rezerwacje
    FROM REZERWACJE r
           JOIN WYCIECZKI w ON r.ID_WYCIECZKI = w.ID_WYCIECZKI
    WHERE w.ID_WYCIECZKI = id_wyc;
    IF miejsca < rezerwacje
    THEN
      RAISE_APPLICATION_ERROR(-20001, 'Nie można zmniejszyć liczby miejsc poniżej ilości rezerwacji');
    end if;
    UPDATE WYCIECZKI SET LICZBA_MIEJSC = miejsca WHERE ID_WYCIECZKI = id_wyc;
    COMMIT;
  end;


CREATE OR REPLACE PROCEDURE przelicz
IS
  CURSOR wyc IS SELECT *
                FROM WYCIECZKI;
  zarezerwowane NUMBER;
  BEGIN
    FOR wycieczka in wyc LOOP
      SELECT COUNT(NR_REZERWACJI) INTO zarezerwowane
      FROM REZERWACJE r
      WHERE r.ID_WYCIECZKI = wycieczka.ID_WYCIECZKI AND r.STATUS<>'A';
      UPDATE WYCIECZKI
      SET LICZBA_WOLNYCH_MIEJSC = LICZBA_MIEJSC - zarezerwowane
      WHERE ID_WYCIECZKI = wycieczka.ID_WYCIECZKI;
    end loop;
    COMMIT;
  end;


CREATE OR REPLACE PROCEDURE dostepne_wycieczki__2(kraj IN  varchar2, data_od IN date, data_do IN date,
                                                  wyc  OUT SYS_REFCURSOR)
IS
  BEGIN
    OPEN wyc FOR
    SELECT KRAJ, DATA, NAZWA, LICZBA_MIEJSC, LICZBA_WOLNYCH_MIEJSC
    FROM DOSTEPNE_WYCIECZKI_2
    WHERE KRAJ = kraj
      AND DATA BETWEEN data_od AND data_do;
  end;

CREATE OR REPLACE PROCEDURE dodaj_rezerwacje_2(id_wyc IN number, id_os IN NUMBER)
IS
  wolne_miejsca NUMBER;
  ids           NUMBER;
  data          DATE;
  BEGIN
    SELECT COUNT(*) INTO ids FROM OSOBY WHERE id_os = ID_OSOBY;
    IF (ids = 0)
    THEN
      RAISE_APPLICATION_ERROR(-20001, 'Nie ma osoby z takim ID');
    END IF;
    SELECT COUNT(*) INTO ids FROM WYCIECZKI WHERE id_wyc = ID_WYCIECZKI;
    IF (ids = 0)
    THEN
      RAISE_APPLICATION_ERROR(-20001, 'Nie ma wycieczki z takim ID');
    END IF;
    SELECT w.LICZBA_WOLNYCH_MIEJSC
        INTO wolne_miejsca FROM WYCIECZKI w WHERE w.ID_WYCIECZKI = id_wyc;
    IF (ids = 0)
    THEN
      RAISE_APPLICATION_ERROR(-20001, 'Brak wolnych miejsc');
    END IF;
    SELECT w.DATA INTO data FROM WYCIECZKI w WHERE id_wyc = w.ID_WYCIECZKI;
    IF data < SYSDATE
    THEN
      RAISE_APPLICATION_ERROR(-20001, 'Wycieczka już się odbyła');
    end if;
    INSERT INTO REZERWACJE (ID_WYCIECZKI, ID_OSOBY, STATUS) VALUES (id_wyc, id_os, 'N');
    UPDATE WYCIECZKI SET LICZBA_WOLNYCH_MIEJSC = LICZBA_WOLNYCH_MIEJSC - 1 WHERE ID_WYCIECZKI = id_wyc;
    COMMIT;
  end;


CREATE OR REPLACE PROCEDURE zmien_status_rezerwacji_2(id_rez IN number, stat IN CHAR)
IS
  miejsca    NUMBER;
  ids        NUMBER;
  id_wyc     NUMBER;
  old_status NUMBER;
  BEGIN
    SELECT COUNT(*) INTO ids FROM REZERWACJE WHERE id_rez = NR_REZERWACJI;
    IF (ids = 0)
    THEN
      RAISE_APPLICATION_ERROR(-20001, 'Nie ma takiej rezerwacji');
    END IF;
    SELECT r.ID_WYCIECZKI INTO id_wyc FROM REZERWACJE r WHERE id_rez = r.NR_REZERWACJI;
    SELECT w.LICZBA_WOLNYCH_MIEJSC
        INTO miejsca
    FROM WYCIECZKI w
           LEFT JOIN REZERWACJE r on w.ID_WYCIECZKI = r.ID_WYCIECZKI
    WHERE r.STATUS in ('P', 'Z', 'N');
    IF miejsca < 1
    THEN
      RAISE_APPLICATION_ERROR(-20001, 'Brak miejsc na tą wycieczkę');
    end if;
    SELECT STATUS INTO old_status FROM REZERWACJE WHERE NR_REZERWACJI = id_rez;
    IF old_status in ('P', 'Z', 'N') AND stat = 'A'
    THEN
      UPDATE WYCIECZKI SET LICZBA_WOLNYCH_MIEJSC = LICZBA_WOLNYCH_MIEJSC + 1 WHERE ID_WYCIECZKI = id_wyc;
    ELSIF old_status = 'A' AND stat in ('P', 'Z', 'N')
      THEN
        UPDATE WYCIECZKI SET LICZBA_WOLNYCH_MIEJSC = LICZBA_WOLNYCH_MIEJSC - 1 WHERE ID_WYCIECZKI = id_wyc;
    end if;
    UPDATE REZERWACJE SET STATUS = stat WHERE NR_REZERWACJI = id_rez;
    INSERT INTO REZERWACJE_LOG (NR_REZERWACJI, DATA, STATUS) VALUES (id_rez, SYSDATE, stat);
    COMMIT;
  end;


CREATE OR REPLACE PROCEDURE zmien_liczbe_miejsc_2(id_wyc IN number, miejsca IN NUMBER)
IS
  ids        NUMBER;
  rezerwacje NUMBER;
  BEGIN
    SELECT COUNT(*) INTO ids FROM WYCIECZKI WHERE id_wyc = ID_WYCIECZKI;
    IF (ids = 0)
    THEN
      RAISE_APPLICATION_ERROR(-20001, 'Nie ma wycieczki z takim ID');
    END IF;
    SELECT w.LICZBA_MIEJSC - w.LICZBA_WOLNYCH_MIEJSC INTO rezerwacje
    FROM WYCIECZKI w
    WHERE w.ID_WYCIECZKI = id_wyc;
    IF miejsca < rezerwacje
    THEN
      RAISE_APPLICATION_ERROR(-20001, 'Nie można zmniejszyć liczby miejsc poniżej ilości rezerwacji');
    end if;
    UPDATE WYCIECZKI SET LICZBA_WOLNYCH_MIEJSC = miejsca - rezerwacje WHERE ID_WYCIECZKI = id_wyc;
    UPDATE WYCIECZKI SET LICZBA_MIEJSC = miejsca WHERE ID_WYCIECZKI = id_wyc;
    COMMIT;
  end;

CREATE OR REPLACE PROCEDURE dodaj_rezerwacje_3(id_wyc IN number, id_os IN NUMBER)
IS
  wolne_miejsca NUMBER;
  ids           NUMBER;
  data          DATE;
  BEGIN
    SELECT COUNT(*) INTO ids FROM OSOBY WHERE id_os = ID_OSOBY;
    IF (ids = 0)
    THEN
      RAISE_APPLICATION_ERROR(-20001, 'Nie ma osoby z takim ID');
    END IF;
    SELECT COUNT(*) INTO ids FROM WYCIECZKI WHERE id_wyc = ID_WYCIECZKI;
    IF (ids = 0)
    THEN
      RAISE_APPLICATION_ERROR(-20001, 'Nie ma wycieczki z takim ID');
    END IF;
    SELECT w.LICZBA_WOLNYCH_MIEJSC
        INTO wolne_miejsca FROM WYCIECZKI w WHERE w.ID_WYCIECZKI = id_wyc;
    IF (ids = 0)
    THEN
      RAISE_APPLICATION_ERROR(-20001, 'Brak wolnych miejsc');
    END IF;
    SELECT w.DATA INTO data FROM WYCIECZKI w WHERE id_wyc = w.ID_WYCIECZKI;
    IF data < SYSDATE
    THEN
      RAISE_APPLICATION_ERROR(-20001, 'Wycieczka już się odbyła');
    end if;
    INSERT INTO REZERWACJE (ID_WYCIECZKI, ID_OSOBY, STATUS) VALUES (id_wyc, id_os, 'N');
    COMMIT;
  end;


CREATE OR REPLACE PROCEDURE zmien_status_rezerwacji_3(id_rez IN number, stat IN CHAR)
IS
  miejsca    NUMBER;
  ids        NUMBER;
  id_wyc     NUMBER;
  old_status NUMBER;
  BEGIN
    SELECT COUNT(*) INTO ids FROM REZERWACJE WHERE id_rez = NR_REZERWACJI;
    IF (ids = 0)
    THEN
      RAISE_APPLICATION_ERROR(-20001, 'Nie ma takiej rezerwacji');
    END IF;
    SELECT r.ID_WYCIECZKI INTO id_wyc FROM REZERWACJE r WHERE id_rez = r.NR_REZERWACJI;
    SELECT w.LICZBA_WOLNYCH_MIEJSC
        INTO miejsca
    FROM WYCIECZKI w
           LEFT JOIN REZERWACJE r on w.ID_WYCIECZKI = r.ID_WYCIECZKI
    WHERE r.STATUS in ('P', 'Z', 'N');
    IF miejsca < 1
    THEN
      RAISE_APPLICATION_ERROR(-20001, 'Brak miejsc na tą wycieczkę');
    end if;
    SELECT STATUS INTO old_status FROM REZERWACJE WHERE NR_REZERWACJI = id_rez;
    IF old_status in ('P', 'Z', 'N') AND stat = 'A'
    THEN
      UPDATE WYCIECZKI SET LICZBA_WOLNYCH_MIEJSC = LICZBA_WOLNYCH_MIEJSC + 1 WHERE ID_WYCIECZKI = id_wyc;
    ELSIF old_status = 'A' AND stat in ('P', 'Z', 'N')
      THEN
        UPDATE WYCIECZKI SET LICZBA_WOLNYCH_MIEJSC = LICZBA_WOLNYCH_MIEJSC - 1 WHERE ID_WYCIECZKI = id_wyc;
    end if;
    UPDATE REZERWACJE SET STATUS = stat WHERE NR_REZERWACJI = id_rez;
    COMMIT;
  end;


CREATE OR REPLACE PROCEDURE zmien_liczbe_miejsc_3(id_wyc IN number, miejsca IN NUMBER)
IS
  ids        NUMBER;
  rezerwacje NUMBER;
  BEGIN
    SELECT COUNT(*) INTO ids FROM WYCIECZKI WHERE id_wyc = ID_WYCIECZKI;
    IF (ids = 0)
    THEN
      RAISE_APPLICATION_ERROR(-20001, 'Nie ma wycieczki z takim ID');
    END IF;
    SELECT w.LICZBA_MIEJSC - w.LICZBA_WOLNYCH_MIEJSC INTO rezerwacje
    FROM WYCIECZKI w
    WHERE w.ID_WYCIECZKI = id_wyc;
    IF miejsca < rezerwacje
    THEN
      RAISE_APPLICATION_ERROR(-20001, 'Nie można zmniejszyć liczby miejsc poniżej ilości rezerwacji');
    end if;
    UPDATE WYCIECZKI SET LICZBA_MIEJSC = miejsca WHERE ID_WYCIECZKI = id_wyc;
    COMMIT;
  end;