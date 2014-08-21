unit ADO__Kmp;
(* TADOConnection modifiziert:
   property StartConnect hinzugefügt.
   Wenn auf false (Vorgabe) bleinbt Connected beim Einlesen des Formulars auf false,
   so daß Connection nicht geöffnet wird.
   Autor: Martin Dambach
   Letzte Änderung:
   29.07.08        Erstellen
*)

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, ADODB;

type
  TqADOConnection = class(TADOConnection)
  private
    { Private-Deklarationen }
    FStartConnect: boolean;          {Überschreibt Connected beim Start}
    procedure SetStartConnect(Value: boolean);
  protected
    { Protected-Deklarationen }
    procedure Loaded; override;
  public
    { Public-Deklarationen }
  published
    { Published-Deklarationen }
    property StartConnect: boolean read FStartConnect write SetStartConnect;
  end;

implementation

uses
  Prots, Err__Kmp, GNav_Kmp, FldDsKmp;

procedure TqADOConnection.SetStartConnect(Value: boolean);
begin
  if (csReading in ComponentState) and not (csDesigning in ComponentState) then
  try
    Connected := Value;                    {Schaltet FStreamedConnected aus}
  except on E:Exception do
    EProt(self, E, 'TqADOConnection.Connected(%d)', [ord(Value)]);
  end;

  FStartConnect := Value;
end;

procedure TqADOConnection.Loaded;
begin
  try
    Connected := StartConnect;   //false
  except
    // keine meldung
  end;
end;

end.
