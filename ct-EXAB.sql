/* MSSQL */

/* Table EXCELABFRAGEN - EXAB - Excel Abfragen
   18.08.08 md  erstellt
*/
DROP TABLE EXCELABFRAGEN;
CREATE TABLE EXCELABFRAGEN(
  TITEL              varchar(200) not null,
  ZEILE              int not null,
  F01                float null,
  F02                float null,
  F03                float null,
  F04                float null,
  F05                float null,
  F06                float null,
  F07                float null,
  F08                float null,
  F09                float null,
  F10                float null,
  F11                float null,
  F12                float null,
  F13                float null,
  F14                float null,
  F15                float null,
  F16                float null,
  F17                float null,
  F18                float null,
  F19                float null,
  F20                float null,
  F21                float null,
  F22                float null,
  F23                float null,
  F24                float null,
  F25                float null,
  F26                float null,
  F27                float null,
  F28                float null,
  F29                float null,
  F30                float null,
  F31                float null,
  F32                float null,
  F33                float null,
  F34                float null,
  F35                float null,
  F36                float null,
  F37                float null,
  F38                float null,
  F39                float null,
  F40                float null,
  S01                varchar(50) null,
  S02                varchar(50) null,
  S03                varchar(50) null,
  S04                varchar(50) null,
  S05                varchar(50) null,
  S06                varchar(50) null,
  S07                varchar(50) null,
  S08                varchar(50) null,
  S09                varchar(50) null,
  S10                varchar(50) null,
  S11                varchar(50) null,
  S12                varchar(50) null,
  S13                varchar(50) null,
  S14                varchar(50) null,
  S15                varchar(50) null,
  S16                varchar(50) null,
  S17                varchar(50) null,
  S18                varchar(50) null,
  S19                varchar(50) null,
  S20                varchar(50) null,
  T01                datetime null,
  T02                datetime null,
  T03                datetime null,
  T04                datetime null,
  T05                datetime null,
  T06                datetime null,
  T07                datetime null,
  T08                datetime null,
  T09                datetime null,
  T10                datetime null,
  T11                datetime null,
  T12                datetime null,
  T13                datetime null,
  T14                datetime null,
  T15                datetime null,
  T16                datetime null,
  T17                datetime null,
  T18                datetime null,
  T19                datetime null,
  T20                datetime null,
  ERFASST_VON        varchar(30) null,
  ERFASST_AM         datetime null,
  GEAENDERT_VON      varchar(30) null,
  GEAENDERT_AM       datetime null,
  ANZAHL_AENDERUNGEN int null,
  BEMERKUNG          varchar(255) null,
  constraint PK_EXAB primary key (TITEL, ZEILE)
);


