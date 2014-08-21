/* RALA: UDFs */
/* CONNECT "c:\db\rala\rala.gdb" user "sysdba" password "masterkey"; */

drop external function N0Dbl;
drop external function N0Int;
drop external function N0Str;

declare external function N0Dbl
  double precision
  returns
  double precision by value
  entry_point 'N0Dbl' module_name 'RalaUDF.dll';

declare external function N0Int
  integer
  returns
  integer by value
  entry_point 'N0Int' module_name 'RalaUDF.dll';

declare external function N0Str
  cstring(254)
  returns
  cstring(254) /* free_it */
  entry_point 'N0Str' module_name 'RalaUDF.dll';


