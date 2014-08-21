unit ddegewichtkmp;
(* Fahrzeugwaage Schenk *)
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, CPro_kmp, FaWa_Kmp;

type
  TDDEGewichtKmp = class(TFaWaKmp)
  private
    { Private-Deklarationen }
  protected
    { Protected-Deklarationen }
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    procedure Init; override;
    function ProtGewicht( Beizeichen: string): longint; override;
  published
    { Published-Deklarationen }
  end;

implementation

uses
  Prots, Err__Kmp;

(*** Initialisierung *********************************************************)

constructor TDDEGewichtKmp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

(*** Methoden ***************************************************************)

procedure TDDEGewichtKmp.Init;
var
  Befehl : array[0..128] of AnsiChar;
  BefLen: integer;
begin
  StrFmt( Befehl, '#EU#%s#%s',
    [FormatDateTime('dd.mm.jj', date), FormatDateTime('hh:nn', time)]);
  BefLen := StrLen( Befehl);
  Start( Befehl, BefLen);
end;


(*** Interne Methoden *******************************************************)


(*** Ereignisgesteuerte Befehle **************************************)

function TDDEGewichtKmp.ProtGewicht( Beizeichen: string): longint;
begin
  {StrFmt( Befehl, '1#TP#%s', [Beizeichen]);
  BefLen := StrLen( Befehl);
  ProtGewichtId := Start( Befehl, BefLen);}
  Inc(TelIDCounter);
  ProtGewichtId := TelIDCounter;
  PostMessage( (Owner as TForm).Handle, BC_CHECKREADONLY, WPARAM(0), LPARAM(0));

  {
  if assigned(FOnProtGewicht) then
        FOnProtGewicht( Tel_Id, Gewicht, ProtNr, FaWaStatus);
        }
  Result := ProtGewichtId;
end;


end.
