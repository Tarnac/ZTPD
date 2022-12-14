--Zad. 1
CREATE TABLE MOVIES(
ID NUMBER(12) PRIMARY KEY,
TITLE VARCHAR2(400) NOT NULL,
CATEGORY VARCHAR2(50),
YEAR CHAR(4),
CAST VARCHAR2(4000),
DIRECTOR VARCHAR2(4000),
STORY VARCHAR2(4000),
PRICE NUMBER(5,2),
COVER BLOB,
MIME_TYPE VARCHAR2(50)
);

--Zad. 2
INSERT INTO MOVIES
SELECT D.ID, D.TITLE, D.CATEGORY, trim(to_char(D.YEAR,'9999')), D.CAST, D.DIRECTOR, D.STORY, D.PRICE, C.IMAGE, C.MIME_TYPE
FROM DESCRIPTIONS D left join COVERS C on D.ID = C.MOVIE_ID;

SELECT * FROM MOVIES;

--Zad. 3
SELECT ID, TITLE FROM MOVIES
WHERE COVER IS NULL;

--Zad. 4
SELECT ID, TITLE, dbms_lob.getlength(COVER) AS "FILESIZE" FROM MOVIES
WHERE COVER IS NOT NULL;

--Zad. 5
SELECT ID, TITLE, dbms_lob.getlength(COVER) AS "FILESIZE" FROM MOVIES
WHERE COVER IS NULL;

--Zad. 6
SELECT * FROM ALL_DIRECTORIES;

--Zad. 7
UPDATE MOVIES
SET COVER = EMPTY_BLOB(),
MIME_TYPE = 'image/jpeg'
WHERE ID = 66;

--Zad. 8
SELECT ID, TITLE, DBMS_LOB.GETLENGTH(COVER) AS "FILESIZE" FROM MOVIES
WHERE ID IN (65, 66);

--Zad. 9
DECLARE
    lobd blob;
    fils BFILE := BFILENAME('ZSBD_DIR','escape.jpg');
BEGIN   
    SELECT COVER INTO lobd
    FROM MOVIES
    WHERE ID = 66
    FOR UPDATE;
    
    DBMS_LOB.fileopen(fils, DBMS_LOB.file_readonly);
    DBMS_LOB.LOADFROMFILE(lobd,fils,DBMS_LOB.GETLENGTH(fils));
    DBMS_LOB.FILECLOSE(fils);
    COMMIT;
END;

--Zad. 10
CREATE TABLE TEMP_COVERS(
movie_id NUMBER(12),
image BFILE,
mime_type VARCHAR2(50)
);

--Zad. 11
INSERT INTO TEMP_COVERS
VALUES (65, BFILENAME('ZSBD_DIR', 'eagles.jpg'), 'image/jpeg');

--Zad. 12
select MOVIE_ID, DBMS_LOB.GETLENGTH(IMAGE) FILESIZE
from TEMP_COVERS;

--Zad. 13
DECLARE
    LOBD   blob;
    FILS   BFILE;
    M_TYPE varchar2(50);
BEGIN
    SELECT IMAGE, MIME_TYPE
    INTO FILS, M_TYPE
    FROM TEMP_COVERS
    WHERE MOVIE_ID = 65;

    DBMS_LOB.CREATETEMPORARY(LOBD, true, dbms_lob.session);
    DBMS_LOB.FILEOPEN(FILS, dbms_lob.file_readonly);
    DBMS_LOB.LOADFROMFILE(LOBD, FILS, dbms_lob.getlength(FILS));
    DBMS_LOB.FILECLOSE(FILS);

    UPDATE MOVIES
    SET COVER = LOBD,
        MIME_TYPE = M_TYPE
    WHERE ID = 65;

    DBMS_LOB.FREETEMPORARY(LOBD);
    COMMIT;
END;

--Zad. 14
SELECT ID, DBMS_LOB.GETLENGTH(COVER) AS "FILESIZE" FROM MOVIES
WHERE ID IN (65, 66);

--Zad. 15
DROP TABLE MOVIES;
DROP TABLE TEMP_COVERS;