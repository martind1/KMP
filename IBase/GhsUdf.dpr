library GhsUdf;

{ Wichtiger Hinweis zur DLL-Speicherverwaltung: ShareMem mu� sich in der
  ersten Unit der unit-Klausel der Bibliothek und des Projekts befinden (Projekt-
  Quelltext anzeigen), falls die DLL Prozeduren oder Funktionen exportiert, die
  Strings als Parameter oder Funktionsergebnisse weitergibt. Dies trifft auf alle
  Strings zu, die von oder zur DLL weitergegeben werden -- auch diejenigen, die
  sich in Records oder Klassen befinden. ShareMem ist die Schnittstellen-Unit
  zu BORLNDMM.DLL, der gemeinsamen Speicherverwaltung, die zusammen mit
  der DLL weitergegeben werden mu�. Um die Verwendung von BORLNDMM.DLL
  zu vermeiden, sollten String-Informationen als PChar oder ShortString �bergeben werden. }

uses
  SysUtils,
  Classes,
  SAppend in 'SAppend.pas';

exports
  appendtok;

begin
end.
