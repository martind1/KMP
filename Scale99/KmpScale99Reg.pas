unit KmpScale99Reg;
(* Komponenten die Schr�ttle Scale99 Typelibrary ben�tigen
01.10.09 MD erstellt

*)
interface

procedure Register;

implementation

uses
  Classes, Controls, comctrls,
  Scale99Kmp;

(* Register *)
procedure Register;
begin
  {RegisterComponents('Beispiele', [TMemoryTable]);}
  //RegisterComponents('Beispiele', [TStopWatch]);

  (* COM *)
  RegisterComponents('COM', [TScale99Kmp]);       //Rowa 10 Scale99 Ole
  
end;

end.
