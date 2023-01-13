--Operator CONTAINS - Podstawy
--Zad. 1
create table CYTATY
as select * from ZSBD_TOOLS.CYTATY;

--Zad. 2
select AUTOR, TEKST 
from CYTATY
where LOWER(TEKST) LIKE '%pesymista%'
and LOWER(TEKST) LIKE '%optymista%';

--Zad. 3
create index CYTATY_TEKST_IDX on CYTATY(TEKST)
indextype is CTXSYS.CONTEXT;

--Zad. 4
select AUTOR, TEKST
from CYTATY
where CONTAINS(TEKST, 'PESYMISTA AND OPTYMISTA', 1) > 0;

--Zad. 5
select AUTOR, TEKST
from CYTATY
where CONTAINS(TEKST, 'PESYMISTA - OPTYMISTA', 1) > 0;

--Zad. 6
select AUTOR, TEKST
from CYTATY
where CONTAINS(TEKST,'near((pesymista, optymista),3)') > 0;

--Zad. 7
select AUTOR, TEKST
from CYTATY
where CONTAINS(TEKST,'near((pesymista, optymista),10)') > 0;

--Zad. 8
select AUTOR, TEKST
from CYTATY
where CONTAINS(TEKST,'życi%',1) > 0;

--Zad. 9
select AUTOR, TEKST, SCORE(1) as DOPASOWANIE
from CYTATY
where CONTAINS(TEKST,'życi%',1) > 0;

--Zad. 10
select AUTOR, TEKST, SCORE(1) as DOPASOWANIE
from CYTATY
where CONTAINS(TEKST,'życi%',1) > 0
and ROWNUM <=1
order by DOPASOWANIE desc;

--Zad. 11
select AUTOR, TEKST
from CYTATY
where CONTAINS(TEKST,'FUZZY(PROBELM,,,N)', 1) > 0;

--Zad. 12
insert into CYTATY
values(39,'Bertrand Russel', 'To smutne, że głupcy są tacy pewni siebie, a ludzie rozsądni tacy pełni wątpliwości.');
commit;

delete from CYTATY
where ID = 39;

select * from CYTATY;

--Zad. 13
select AUTOR, TEKST
from CYTATY
where CONTAINS(TEKST, 'głupcy', 1) > 0;

--Zad. 14
select TOKEN_TEXT
from DR$CYTATY_TEKST_IDX$I;

select TOKEN_TEXT
from DR$CYTATY_TEKST_IDX$I
where TOKEN_TEXT = 'głupcy';

--Zad. 15
drop index CYTATY_TEKST_IDX;

create index CYTATY_TEKST_IDX on CYTATY(TEKST)
indextype is CTXSYS.CONTEXT;

--Zad. 16
select AUTOR, TEKST
from CYTATY
where CONTAINS(TEKST, 'głupcy', 1) > 0;

--Zad. 17
drop index CYTATY_TEKST_IDX;

drop table CYTATY;

--Zaawansowane indeksowanie i wyszukiwanie
--Zad. 1
create table QUOTES
as select * from ZSBD_TOOLS.QUOTES;

--Zad. 2
create index QUOTES_TEXT_IDX on QUOTES(TEXT)
indextype is CTXSYS.CONTEXT;

--Zad. 3
select AUTHOR, TEXT
from QUOTES
where CONTAINS(TEXT, 'work', 1) > 0;

select AUTHOR, TEXT
from QUOTES
where CONTAINS(TEXT, '$work', 1) > 0;

select AUTHOR, TEXT
from QUOTES
where CONTAINS(TEXT, 'working', 1) > 0;

select AUTHOR, TEXT
from QUOTES
where CONTAINS(TEXT, '$working', 1) > 0;

--Zad. 4
select AUTHOR, TEXT
from QUOTES
where CONTAINS(TEXT, 'it', 1) > 0;

--Zad. 5
select *
from CTX_STOPLISTS;

--Zad. 6
select *
from CTX_STOPWORDS;

--Zad. 7
drop index QUOTES_TEXT_IDX;

create index QUOTES_TEXT_IDX on QUOTES(TEXT)
indextype is CTXSYS.CONTEXT
parameters ('stoplist CTXSYS.EMPTY_STOPLIST');

--Zad. 8
select AUTHOR, TEXT
from QUOTES
where CONTAINS(TEXT, 'it', 1) > 0;

--Zad. 9
select AUTHOR, TEXT
from QUOTES
where CONTAINS(TEXT, 'fool AND humans', 1) > 0;

--Zad. 10
select AUTHOR, TEXT
from QUOTES
where CONTAINS(TEXT, 'fool AND humans', 1) > 0;

--Zad. 11
select AUTHOR, TEXT
from QUOTES
where CONTAINS(TEXT,'(fool AND humans) within SENTENCE',1) > 0;

--Zad. 12
drop index QUOTES_TEXT_IDX;

--Zad. 13
begin
    ctx_ddl.create_section_group('nullgroup', 'NULL_SECTION_GROUP');
    ctx_ddl.add_special_section('nullgroup', 'SENTENCE');
    ctx_ddl.add_special_section('nullgroup', 'PARAGRAPH');
end;

--Zad. 14
create index QUOTES_TEXT_IDX on QUOTES(TEXT)
indextype is CTXSYS.CONTEXT
parameters ('stoplist CTXSYS.EMPTY_STOPLIST
            section group nullgroup');

--Zad. 15
select AUTHOR, TEXT
from QUOTES
where CONTAINS(TEXT,'(fool AND humans) within SENTENCE',1) > 0;

select AUTHOR, TEXT
from QUOTES
where CONTAINS(TEXT,'(fool AND computers) within SENTENCE',1) > 0;

--Zad. 16
select AUTHOR, TEXT
from QUOTES
where CONTAINS(TEXT, 'humans', 1) > 0;

--Zad. 17
drop index QUOTES_TEXT_IDX;

begin
    ctx_ddl.create_preference('lex_z_m','BASIC_LEXER');
    ctx_ddl.set_attribute('lex_z_m', 'printjoins', '_-');
    ctx_ddl.set_attribute ('lex_z_m', 'index_text', 'YES');
end;

create index QUOTES_TEXT_IDX on QUOTES(TEXT)
indextype is CTXSYS.CONTEXT
parameters ('stoplist CTXSYS.EMPTY_STOPLIST
            section group nullgroup
            LEXER lex_z_m');

--Zad. 18
select AUTHOR, TEXT
from QUOTES
where CONTAINS(TEXT, 'humans', 1) > 0;

--Zad. 19
select AUTHOR, TEXT
from QUOTES
where CONTAINS(TEXT, 'non\-humans', 1) > 0;

--Zad. 20
drop table QUOTES;

begin
    ctx_ddl.drop_preference('lex_z_m');
end;