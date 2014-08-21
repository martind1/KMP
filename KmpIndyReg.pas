unit KmpIndyReg;
(* Komponenten die Indy benötigen
26.09.09 MD erstellt: UdpPort (von ComPort bzw. WSPort)

*)
interface

procedure Register;

implementation

uses
  Classes, Controls, comctrls,
  UdpPortKmp;

(* Register *)
procedure Register;
begin
  {RegisterComponents('Beispiele', [TMemoryTable]);}
  //RegisterComponents('Beispiele', [TStopWatch]);

  (* COM *)
  RegisterComponents('COM', [TUdpPort]);       //UDP ComPort (Rowa 10)
  
end;

end.
