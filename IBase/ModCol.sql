/* Vorlage für Interbase: Modify Column(#Table#, #Col#, #Format#)

ALTER TABLE #Table#
  ADD TMP_#Col#                         #Format#
/
update #Table#
  set TMP_#Col# = #Col#
/
ALTER TABLE #Table#
  DROP #Col#
/
ALTER TABLE #Table#
  ADD #Col#                             #Format#
/
update #Table#
  set #Col# = TMP_#Col#
/
ALTER TABLE #Table#
  DROP TMP_#Col#
/

