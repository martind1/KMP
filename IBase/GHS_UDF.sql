/*===============================================================*/
/* Subject:        User defined functions                        */
/* Database name:  GHS                                           */
/* DBMS name:      Interbase 5                                   */
/* Created on:     10.04.04                                      */
/*===============================================================*/

drop external function appendtok;

declare external function appendtok
  cstring(250), cstring(250), cstring(250)
  returns
  cstring(250) free_it
  entry_point 'appendtok' module_name 'GhsUdf.dll';


