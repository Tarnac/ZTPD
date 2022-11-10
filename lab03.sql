--Zad. 1
CREATE TABLE DOKUMENTY(
    ID NUMBER(12) PRIMARY KEY,
    DOKUMENT CLOB
);

--Zad. 2
DECLARE
    tekst CLOB :='';
BEGIN
    FOR counter IN 1..10000 LOOP
        tekst := tekst || 'Oto tekst.';
    END LOOP;
    
    INSERT INTO DOKUMENTY(ID, DOKUMENT) VALUES(1, TO_CLOB(tekst));
    
END;

--Zad. 3
--a
SELECT * FROM DOKUMENTY;

--b
SELECT UPPER(DOKUMENT) FROM DOKUMENTY;

--c
SELECT LENGTH(DOKUMENT) FROM DOKUMENTY;

--d
SELECT DBMS_LOB.GETLENGTH(DOKUMENT) FROM DOKUMENTY;

--e
SELECT SUBSTR(DOKUMENT, 5,1000) FROM DOKUMENTY;

--f
SELECT DBMS_LOB.SUBSTR(DOKUMENT, 1000, 5) FROM DOKUMENTY;

--Zad. 4
INSERT INTO DOKUMENTY(ID, DOKUMENT) VALUES(2, EMPTY_CLOB());

--Zad. 5
INSERT INTO DOKUMENTY(ID, DOKUMENT) VALUES(3, NULL);

--Zad. 6 Polecenia z zad. 3.

--Zad. 7
SELECT * FROM ALL_DIRECTORIES;

--Zad. 8
DECLARE
    lobd clob;
    fils BFILE := BFILENAME('ZSBD_DIR', 'dokument.txt');
    doffset integer := 1;
    soffset integer := 1;
    langctx integer := 0;
    warn integer := null;
BEGIN
    SELECT DOKUMENT INTO lobd FROM DOKUMENTY
    WHERE ID = 2 FOR UPDATE;
    DBMS_LOB.fileopen(fils, DBMS_LOB.file_readonly);
    DBMS_LOB.LOADCLOBFROMFILE(lobd, fils, DBMS_LOB.LOBMAXSIZE, doffset, soffset,
        873, langctx, warn);
    DBMS_LOB.FILECLOSE(fils);
    DBMS_LOB.FILECLOSE(fils);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Status operacji: '||warn);
END;

--Zad. 9
UPDATE DOKUMENTY 
SET DOKUMENT = TO_CLOB(BFILENAME('ZSBD_DIR', 'dokument.txt'))
WHERE ID = 3;

--Zad. 10
SELECT * FROM DOKUMENTY;

--Zad. 11
SELECT LENGTH(DOKUMENT) FROM DOKUMENTY;

--Zad. 12
DROP TABLE DOKUMENTY;

--Zad. 13
CREATE OR REPLACE PROCEDURE CLOB_CENSOR(lobd in out clob, text_to_replace in VARCHAR2)
IS
    censored VARCHAR2(250);
    pos INTEGER;
BEGIN
    censored := '';
    FOR counter IN 1..LENGTH(text_to_replace) LOOP
        censored := censored || '.';
    END LOOP;
    
    pos := DBMS_LOB.INSTR(lobd, text_to_replace);
    WHILE pos <> 0
        LOOP
            DBMS_LOB.WRITE(lobd, LENGTH(text_to_replace), pos, censored);
            pos := DBMS_LOB.INSTR(lobd, text_to_replace);
        END LOOP;
END CLOB_CENSOR;

--Zad. 14
CREATE TABLE BIOGRAPHIES_COPY AS SELECT * FROM ZSBD_TOOLS.BIOGRAPHIES;

SELECT * FROM BIOGRAPHIES_COPY;

DECLARE
    lobd CLOB;
BEGIN
    SELECT BIO INTO lobd
    FROM BIOGRAPHIES_COPY
    FOR UPDATE;
    
    CLOB_CENSOR(lobd, 'Cimrman');
    COMMIT;
END;

SELECT * FROM BIOGRAPHIES_COPY;

--Zad. 15
DROP TABLE BIOGRAPHIES_COPY;
