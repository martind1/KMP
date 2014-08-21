PROMPT
PROMPT Anlegen Tabelle REPLIKATION
PROMPT
CREATE TABLE QUI3.REPLIKATION
  (REPL_ID                     NUMBER(9)
     CONSTRAINT PK_REPL        PRIMARY KEY,
   OP                          VARCHAR2(1),
   TABLENAME                   VARCHAR2(80),
   PKEY                        VARCHAR2(2000),
   ERFASST_VON                 VARCHAR2 (30),
   ERFASST_AM                  DATE,
   GEAENDERT_VON               VARCHAR2(30),
   GEAENDERT_AM                DATE,
   ANZAHL_AENDERUNGEN          NUMBER(9),
   BEMERKUNG                   VARCHAR2(2000)
  )
  TABLESPACE USER_DATA STORAGE (INITIAL 4K NEXT 4K);
CREATE PUBLIC SYNONYM REPL FOR QUI3.REPLIKATION;
/
