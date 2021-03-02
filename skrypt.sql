DROP DATABASE IF EXISTS TEST;
CREATE DATABASE TEST
USE TEST;

 -- KLIENCI -->
DROP TABLE IF EXISTS klienci;
CREATE TABLE klienci (
  Id_klienta INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  Login varchar(100) DEFAULT NULL,
  Haslo varchar(100) DEFAULT NULL,
  Nazwisko varchar(100) DEFAULT NULL,
  Imie varchar(100) DEFAULT NULL,
  Adres varchar(100) DEFAULT NULL,
  Telefon int DEFAULT NULL,
  Adres_mail varchar(100) DEFAULT NULL
) 

-- PRACOWNICY -->
DROP TABLE IF EXISTS pracownicy;
CREATE TABLE pracownicy (
  Id_pracownika INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  Login varchar(100) DEFAULT NULL,
  Haslo varchar(100) DEFAULT NULL,
  Nazwisko varchar(100) DEFAULT NULL,
  Imie varchar(100) DEFAULT NULL,
  Miejscowosc varchar(100) DEFAULT NULL,
  Tel_kontaktowy int DEFAULT NULL,
  Adres_mail varchar(100) DEFAULT NULL) 

-- HISTORIA PRACOWNIKA -->
DROP TABLE IF EXISTS historia_pracownika;
CREATE TABLE historia_pracownika (
  Id_pracownika int,
  Data_zatrudnienia date DEFAULT NULL,
  Wynagrodzenia int DEFAULT NULL,
    FOREIGN KEY("Id_pracownika") REFERENCES "pracownicy"("Id_pracownika") ON DELETE SET NULL
);

-- TOWARY -->
DROP TABLE IF EXISTS towary;
CREATE TABLE towary (
  Id_towaru INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  Nazwa varchar(100) DEFAULT NULL,
  Cena int DEFAULT NULL,
  Cena_z_VAT int DEFAULT NULL
)

-- TRANSAKCJE -->
DROP TABLE IF EXISTS transakcje;
CREATE TABLE transakcje (
  Nr_transakcji INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  Id_klienta int DEFAULT NULL,
  Id_pracownika int DEFAULT NULL,
  Data_zamowienia date DEFAULT NULL,
  Data_odbioru date DEFAULT NULL,
  Sposob_odbioru varchar(100) DEFAULT NULL,
  Transport varchar(100) DEFAULT NULL,
    FOREIGN KEY("Id_pracownika") REFERENCES "pracownicy"("Id_pracownika"),
	FOREIGN KEY("Id_klienta") REFERENCES "klienci"("Id_klienta")
) 

-- LOGS -->
DROP TABLE IF EXISTS Logi;
CREATE TABLE Logi (
Log_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
Zrodlo VARCHAR(100),
Rodzaj VARCHAR(20),
Beforek VARCHAR(100),
Afterek VARCHAR(100)
);

-- SZCZEGÓŁY TRANSAKCJI -->
DROP TABLE IF EXISTS szczegoly_transakcji;
CREATE TABLE szczegoly_transakcji (
  Nr_transakcji int DEFAULT NULL,
  Ilosc int DEFAULT NULL,
  Rabat int DEFAULT NULL,
  Gwarancja int DEFAULT NULL,
  Id_towaru int DEFAULT NULL,
    FOREIGN KEY("Id_towaru") REFERENCES "towary"("Id_towaru") ON DELETE SET NULL,
	FOREIGN KEY("Nr_transakcji") REFERENCES "transakcje"("Nr_transakcji") ON DELETE SET NULL);

-- FAKTURA SPRZEDAZY -->
DROP TABLE IF EXISTS faktura_sprzedazy;
CREATE TABLE faktura_sprzedazy (
  Data_wystawienia DATE DEFAULT NULL,
  Sposoby_zaplaty VARCHAR(100),
  Nazwa_towaru VARCHAR(100),
  Cena MONEY,
  Id_pracownika INT NOT NULL,
  Id_klienta INT NOT NULL,
    FOREIGN KEY("Id_pracownika") REFERENCES "pracownicy"("Id_pracownika"),
	FOREIGN KEY("Id_klienta") REFERENCES "klienci"("Id_klienta")
) 

INSERT INTO towary VALUES ('T-Shirt',10,12),('Czapka',20,25),('Marynarka',1000,1230),('Młotek',50,63);
INSERT INTO klienci VALUES ('wiktjasin','haslo','Jasinski','Wiktor','Studzianki 1 Krakow',601390423,'wiktorjasinski@gmail.com'),('bolsok','haslo','Sokolowski','Bolek','Prochnika Adama 16 Lodz',727395150,'boleksokolowski@gmail.com'),('grabczci','haslo','Grabowski','Lukasz','Lagiewnicka 9 Lodz',671705475,'lukaszgrabowski@gmail.com'),('mikos','haslo','Mikolajczyk','Mikolaj','Pogodna Biala podlaska',123456789,'123456789'),('adrian','haslo','Nieweglowski','Adrian','Pyszna 12 Lublin',123123123,'123123123');
INSERT INTO pracownicy VALUES ('kowalczuk.j@gmail.com','1hfdmlds@','Kowalczuk','Jan','Lublin',507093782,'kowalczuk.j@gmail.com'),('wieczorek16','haslo','Wieczorek','Wlodzimierz','Warszawa',796593202,'wladzimierzwieczorek@gmail.com'),('tytusromek','haslo','Kaminski','Tytus','Poznan',724644030,'kaminskitytus@gmail.com'),('leosia55','haslo','Nowicka','Leokadia','Olsztyn',697925986,'697925986'),('nowakn','haslo','Nadziejaa','Nowak','Wrocław',679807986,'nadziejan@gmail.com');
INSERT INTO transakcje VALUES (1,2,'2020-06-09','2020-06-13','Bezposredni','Kurier'),(1,3,'2020-06-14','2020-06-14','Bezposredni','Odbior na miejscu'),(2,1,'2020-06-02','2020-06-02','Samochodem','Własny zakres');
INSERT INTO szczegoly_transakcji VALUES (1,10,0,1,1),(3,25,0,1,3),(3,5,15,2,1);
INSERT INTO historia_pracownika VALUES (1,'2020-06-02',5000),(2,'2020-06-01',5000),(3,'2020-06-01',4000),(4,'2020-06-01',3000),(5,'2015-03-21',2500);

--exec sp_addmessage -- BŁĄD GDY KLIENT O PODANYM ID NIE ISTNIEJE W BAZIE
--@msgnum = 70000,
--@severity = 10,
--@msgtext = 'Klient z podanym ID nie istnieje. Zmien wartosc parametru @KlientId lub utwórz klienta najpierw',
--@with_log = 'true';

--exec sp_addmessage -- BŁĄD GDY PRACOWNIK O PODANYM ID NIE ISTNIEJE W BAZIE
--@msgnum = 70001,
--@severity = 10,
--@msgtext = 'Pracownik z podanym ID nie istnieje. Zmien wartosc parametru @PracownikId lub utwórz pracownika najpierw',
--@with_log = 'true';

--exec sp_addmessage -- BŁĄD DATY - ZAMOWIENIE W PRZYSZLOSCI
--@msgnum = 70002,
--@severity = 10,
--@msgtext = 'Nie można zamówić z datą w przyszłości.',
--@with_log = 'true';

--exec sp_addmessage -- BŁĄD DATY - ODBIOR ZAMOWIENIA PRZED JEGO ZALOZENIEM
--@msgnum = 70003,
--@severity = 10,
--@msgtext = 'Nie można odebrac towaru przed zlozeniem zamowienia',
--@with_log = 'true';

--exec sp_addmessage -- BŁĄD PARAMETRU - NIE MOZNA ZAAKTUALIZOWAC TEGO REKORDU
--@msgnum = 70004,
--@severity = 10,
--@msgtext = 'Nie istnieje transakcja o podanym ID, NIE MOZNA ZAAKTUALIZOWAC',
--@with_log = 'true';
--GO

--exec sp_addmessage -- ŻADNE REKORDY NIE ULEGŁY ZMIANIE
--@msgnum = 70011,
--@severity = 10,
--@msgtext = 'TRIGGER HAS NOT DO ANY CHANGES',
--@with_log = 'true';
--GO

SET NOCOUNT, XACT_ABORT ON; --USUWANIE PROCEDURY makeTransaction
IF EXISTS (SELECT * FROM sys.procedures WHERE name= 'makeTransaction' AND type='P')
DROP PROCEDURE makeTransaction
GO
 
CREATE PROCEDURE makeTransaction
    @KlientId INT,
    @PracownikId INT,  
    @DataZamowienia DATE,  
    @DataOdbioru DATE,  
    @SposobOdbioru VARCHAR(100),
	@transporT VARCHAR(100)
AS  
BEGIN  TRY -- ROZPOCZĘCIE INSTRUKCJI ,,TRY"
SET NOCOUNT ON -- NIE ZWRACAJ INFORMACJI O ZMODYFIKOWANYCH REKORDACH

 -- SPRAWDZANIE CZY UZYTKOWNIK PODAŁ DATĘ ZAMÓWIENIA W PARAMETRZE
    IF @DataZamowienia = '' OR @DataZamowienia = NULL
	BEGIN
	SET @DataZamowienia= GETDATE();
	END

-- SPRAWDZANIE CZY UZYTKOWNIK PODAL DATE ODBIORU W PARAMETRZE
	IF @DataOdbioru = '' OR @DataOdbioru= NULL
    BEGIN  
	SET @DataOdbioru = GETDATE();
	END

	-- SPRAWDZANIE CZY KLIENT Z PODANYM ID ISTNIEJE W BAZIE
	IF NOT EXISTS(SELECT Id_klienta FROM klienci WHERE Id_klienta=@KlientId)
	BEGIN
	RAISERROR(70000, 16, 1)	
	END
	
	-- SPRAWDZENIE CZY PRACOWNIK Z PODANYM ID ISTNIEJE W BAZIE
	IF NOT EXISTS(SELECT Id_pracownika FROM pracownicy  WHERE Id_pracownika=@PracownikId)
	BEGIN
	RAISERROR(70001, 16, 1)
	END

	-- SPRAWDZANIE CZY DATA ZAMOWIENIA NIE JEST DALEJ W PRZYSZLOSCI NIZ DZIEN DZISIEJSZY
	IF @DataZamowienia>GETDATE()
	BEGIN
	RAISERROR(70002, 16, 1)	
	END

	-- SPRAWDZANIE CZY DATA ODBIORU NIE JEST PRZED DATA ZAMOWIENIA
	IF @DataZamowienia>@DataOdbioru
	BEGIN
	RAISERROR(70003, 16, 1)	
	END

	BEGIN TRANSACTION; -- ROZPOCZĘCIE TRANSAKCJI

INSERT INTO transakcje VALUES (@KlientId,@PracownikId,@DataZamowienia,@DataOdbioru,@SposobOdbioru,@transporT);

		COMMIT TRANSACTION; --COMMITOWANIE TRANSAKCJI
    END TRY -- KONIEC BLOKU ,,TRY"
 BEGIN CATCH -- ROZPOCZECIE BLOKU ,,CATCH"

       IF @@TRANCOUNT > 0 -- WARUNEK JEŻELI ILOŚĆ PRZERWANYCH TRANSAKCJI JEST WIĘKSZA OD 0
       BEGIN
          ROLLBACK TRANSACTION -- TO ROLLBACKUJ TRANSAKCJE
       END;
	   
       	DECLARE @cErrMsg NVARCHAR(2048) -- DEKLARACJA ZMIENNEJ DO PRZECHOWYWANIA WIADOMOŚCI O BŁĘDZIE
		SET @cErrMsg= ERROR_MESSAGE() -- POBIERANIE ZGŁOSZONEGO WCZEŚNIEJ BŁĘDU(JEŚLI WYSTĄPIŁ OCZYWIŚCIE)
		RAISERROR (@cErrMsg, 16, 1) WITH NOWAIT, SETERROR -- WYWOŁYWANIE KOMUNIKATU O TYM BŁĘDZIE

    END CATCH; -- KONIEC INSTRUKCJI CATCH

SET NOCOUNT, XACT_ABORT OFF; -- PRZYWROC INFORMOWANIE O ZMODYFIKOWANYCH REKORDACH
GO



SET NOCOUNT, XACT_ABORT ON;
IF EXISTS (SELECT * FROM sys.procedures WHERE name= 'showTransaction' AND type='P')
DROP PROCEDURE showTransaction
GO
-- WYSWIETLANIE TRANSKACJI
CREATE PROCEDURE showTransaction
AS  
BEGIN 
SET NOCOUNT ON -- NIE ZWRACAJ INFORMACJI O ZMODYFIKOWANYCH REKORDACH
BEGIN TRANSACTION; -- ROZPOCZĘCIE TRANSAKCJI

SELECT tr.Nr_transakcji, CONCAT (kl.Imie,' "',kl.Login,'" ',kl.Nazwisko) AS 'KLIENT', CONCAT (pr.Imie,' "',pr.Login,'" ',pr.Nazwisko) AS 'PRACOWNIK', tr.Data_zamowienia, tr.Data_odbioru, tr.Sposob_odbioru, tr.Transport  FROM transakcje tr JOIN klienci kl ON kl.Id_klienta=tr.Id_klienta JOIN pracownicy pr ON pr.Id_pracownika=tr.Id_pracownika

COMMIT TRANSACTION;--COMMITOWANIE TRANSAKCJI
END
SET NOCOUNT ON;
GO-- PRZYWROC INFORMOWANIE O ZMODYFIKOWANYCH REKORDACH




SET NOCOUNT, XACT_ABORT ON;
IF EXISTS (SELECT * FROM sys.procedures WHERE name= 'updateTransaction' AND type='P')
DROP PROCEDURE updateTransaction
GO
CREATE PROCEDURE updateTransaction
    @KlientId INT,
    @PracownikId INT,  
    @DataZamowienia DATE,  
    @DataOdbioru DATE,  
    @SposobOdbioru VARCHAR(100),
	@transporT VARCHAR(100),
	@updateID INT
AS  
BEGIN  TRY -- ROZPOCZĘCIE INSTRUKCJI ,,TRY"
SET NOCOUNT ON -- NIE ZWRACAJ INFORMACJI O ZMODYFIKOWANYCH REKORDACH

 -- SPRAWDZANIE CZY UZYTKOWNIK PODAŁ DATĘ ZAMÓWIENIA W PARAMETRZE
    IF @DataZamowienia = '' OR @DataZamowienia = NULL
	BEGIN
	SET @DataZamowienia= GETDATE();
	END

-- SPRAWDZANIE CZY UZYTKOWNIK PODAL DATE ODBIORU W PARAMETRZE
	IF @DataOdbioru = '' OR @DataOdbioru= NULL
    BEGIN  
	SET @DataOdbioru = GETDATE();
	END

	-- SPRAWDZANIE CZY KLIENT Z PODANYM ID ISTNIEJE W BAZIE
	IF NOT EXISTS(SELECT Id_klienta FROM klienci WHERE Id_klienta=@KlientId)
	BEGIN
	RAISERROR(70000, 16, 1)	
	END
	
	-- SPRAWDZENIE CZY PRACOWNIK Z PODANYM ID ISTNIEJE W BAZIE
	IF NOT EXISTS(SELECT Id_pracownika FROM pracownicy  WHERE Id_pracownika=@PracownikId)
	BEGIN
	RAISERROR(70001, 16, 1)
	END

	-- SPRAWDZANIE CZY DATA ZAMOWIENIA NIE JEST DALEJ W PRZYSZLOSCI NIZ DZIEN DZISIEJSZY
	IF @DataZamowienia>GETDATE()
	BEGIN
	RAISERROR(70002, 16, 1)	
	END

	-- SPRAWDZANIE CZY DATA ODBIORU NIE JEST PRZED DATA ZAMOWIENIA
	IF @DataZamowienia>@DataOdbioru
	BEGIN
	RAISERROR(70003, 16, 1)	
	END
	
	--Nie istnieje transakcja o podanym ID, NIE MOZNA ZAAKTUALIZOWAC
	IF (@updateID=''OR @updateID=NULL OR NOT EXISTS(SELECT * FROM klienci WHERE Id_klienta=@updateID))
	BEGIN
	RAISERROR(70004, 16, 1)
	END

	BEGIN TRANSACTION; -- ROZPOCZĘCIE TRANSAKCJI


UPDATE transakcje SET Id_klienta=@KlientId, Id_pracownika=@PracownikId, Data_zamowienia=@DataZamowienia, Data_odbioru=@DataOdbioru, Sposob_odbioru=@SposobOdbioru, Transport=@transporT WHERE Nr_transakcji=@updateID

		COMMIT TRANSACTION; --COMMITOWANIE TRANSAKCJI
    END TRY -- KONIEC BLOKU ,,TRY"
 BEGIN CATCH -- ROZPOCZECIE BLOKU ,,CATCH"

       IF @@TRANCOUNT > 0 -- WARUNEK JEŻELI ILOŚĆ PRZERWANYCH TRANSAKCJI JEST WIĘKSZA OD 0
       BEGIN
          ROLLBACK TRANSACTION -- TO ROLLBACKUJ TRANSAKCJE
       END;
	   
       	DECLARE @cErrMsg NVARCHAR(2048) -- DEKLARACJA ZMIENNEJ DO PRZECHOWYWANIA WIADOMOŚCI O BŁĘDZIE
		SET @cErrMsg= ERROR_MESSAGE() -- POBIERANIE ZGŁOSZONEGO WCZEŚNIEJ BŁĘDU(JEŚLI WYSTĄPIŁ OCZYWIŚCIE)
		RAISERROR (@cErrMsg, 16, 1) WITH NOWAIT, SETERROR -- WYWOŁYWANIE KOMUNIKATU O TYM BŁĘDZIE

    END CATCH; -- KONIEC INSTRUKCJI CATCH

SET NOCOUNT, XACT_ABORT OFF; -- PRZYWROC INFORMOWANIE O ZMODYFIKOWANYCH REKORDACH
GO

SET NOCOUNT, XACT_ABORT ON;
IF EXISTS (SELECT * FROM sys.procedures WHERE name= 'deleteTransaction' AND type='P')
DROP PROCEDURE deleteTransaction
GO
-- USUWANIE TRANSKACJI
CREATE PROCEDURE deleteTransaction(
@TransID INT)
AS  
BEGIN 
SET NOCOUNT ON -- NIE ZWRACAJ INFORMACJI O ZMODYFIKOWANYCH REKORDACH
BEGIN TRANSACTION; -- ROZPOCZĘCIE TRANSAKCJI
DELETE transakcje WHERE Nr_transakcji=@TransID;
COMMIT TRANSACTION;--COMMITOWANIE TRANSAKCJI
END
SET NOCOUNT ON;
GO-- PRZYWROC INFORMOWANIE O ZMODYFIKOWANYCH REKORDACH


-- TRIGGERY 
IF EXISTS (SELECT * FROM sys.triggers WHERE NAME= 'EmpHistory' AND type='TR' AND is_instead_of_trigger=	1)
	DROP TRIGGER EmpHistory
GO

CREATE TRIGGER EmpHistory
ON pracownicy -- NA TABELI PRACOWNICY
INSTEAD OF INSERT,DELETE -- INSERTA i DELETA
AS 
	IF (@@ROWCOUNT=0) -- ANY ROW AFFECTED CASE
		BEGIN
	RAISERROR(70011,16,1)
	RETURN
		END
	SET NOCOUNT ON
	if not exists(Select * FROM deleted) -- SPRAWDZANIE RODZAJU OPERACJI
		BEGIN -- INSERT
	INSERT INTO pracownicy VALUES ((SELECT Login FROM inserted), (SELECT Haslo FROM inserted), (SELECT Nazwisko FROM inserted), (SELECT Imie FROM inserted), (SELECT Miejscowosc FROM inserted), (SELECT Tel_kontaktowy FROM inserted), (SELECT Adres_mail FROM inserted))
	INSERT INTO historia_pracownika VALUES((SELECT TOP 1 Id_pracownika FROM pracownicy ORDER BY Id_pracownika DESC),GETDATE(),2100);
	INSERT INTO Logi VALUES('[INSERT TRIGGER] - pracownicy','INSERT','',(SELECT CONCAT(Id_pracownika,'',Imie,'',Nazwisko) FROM inserted))
		END
	ELSE
		BEGIN -- DELETE
		DELETE historia_pracownika WHERE historia_pracownika.Id_pracownika=(SELECT Id_pracownika FROM deleted)
		DELETE pracownicy WHERE pracownicy.Id_pracownika=(SELECT Id_pracownika FROM deleted)
		INSERT INTO Logi VALUES('[DELETE TRIGGER] - pracownicy','DELETE',(SELECT CONCAT(Id_pracownika,'',Imie,'',Nazwisko) FROM deleted),'');
		END
	GO

	SELECT * FROM transakcje
	SELECT * FROm szczegoly_transakcji
	-- TRIGGERY 
IF EXISTS (SELECT * FROM sys.triggers WHERE NAME= 'LogTrans' AND type='TR' AND is_instead_of_trigger=	1)
	DROP TRIGGER LogTrans
GO

CREATE TRIGGER LogTrans
ON transakcje -- NA TRANSAKCJACH
INSTEAD OF UPDATE
AS
SET NOCOUNT OFF
		BEGIN
		INSERT INTO Logi VALUES('[UPDATE TRIGGER] - transakcje','UPDATE',(SELECT CONCAT('CUST:',Id_klienta,' EMP:',Id_pracownika,' FROM:',Data_zamowienia,' ON TRANS NR:',Nr_transakcji)FROM deleted), (SELECT CONCAT('CUST:',Id_klienta,' EMP:',Id_pracownika,' FROM:',Data_zamowienia,' ON TRANS NR:',Nr_transakcji)FROM inserted));
		UPDATE transakcje SET Id_klienta=(SELECT Id_klienta FROM inserted), Id_pracownika=(SELECT Id_pracownika FROM inserted), Data_zamowienia=(SELECT Data_zamowienia FROM inserted), Data_odbioru=(SELECT Data_odbioru FROM inserted), Sposob_odbioru=(SELECT Sposob_odbioru FROM inserted), Transport=(SELECT Transport FROM inserted) WHERE Nr_transakcji=(SELECT Nr_transakcji FROM deleted)
		END
	GO
