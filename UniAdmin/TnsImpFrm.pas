unit TnsImpFrm;
(* Tnsnames importieren
08.11.11 md  erstellt
*)

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, DatumDlg, Grids, TgridKmp,
  MAINFrm;

type
  TFrmTnsImp = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    EdFilename: TEdit;
    BtnFilename: TFileBtn;
    Panel2: TPanel;
    tgAlias: TTitleGrid;
    BtnImport: TBitBtn;
    BtnReadTns: TBitBtn;
    BtnClose: TBitBtn;
    procedure BtnReadTnsClick(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnImportClick(Sender: TObject);
  private
    tgAliasRow: integer;
    MainFrm: TFrmMAIN;
    procedure ReadTns(AStream: TStream);
    procedure ProcessAlias(Aliasname, Host, Port, ServiceName,
      Protokoll: string);
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    class procedure Execute(aMainFrm: TFrmMAIN);
  end;

var
  FrmTnsImp: TFrmTnsImp;

implementation
{$R *.dfm}
uses
  Prots;

{ TFrmTnsImp }

class procedure TFrmTnsImp.Execute(aMainFrm: TFrmMAIN);
begin
  if FrmTnsImp = nil then
    FrmTnsImp := TFrmTnsImp.Create(nil);
  FrmTnsImp.MainFrm := aMainFrm;
  FrmTnsImp.Show;
end;

procedure TFrmTnsImp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FrmTnsImp := nil;
  Action := caFree;
end;

procedure TFrmTnsImp.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmTnsImp.BtnImportClick(Sender: TObject);
var
  Y: Integer;
begin
  for Y := 1 to tgAlias.RowCount - 1 do
    MainFrm.TnsImp(tgAlias.Cells[1, Y], //Aliasname
                   tgAlias.Cells[2, Y], //Host
                   tgAlias.Cells[3, Y], //Port
                   tgAlias.Cells[4, Y]) //ServiceName
end;

procedure TFrmTnsImp.BtnReadTnsClick(Sender: TObject);
var
  AFileStream: TFileStream;
begin
  AFileStream := TFileStream.Create(EdFilename.Text, fmOpenRead);
  try
    ReadTns(AFileStream);
  finally
    AFileStream.Free;
  end;
end;

procedure TFrmTnsImp.ReadTns(AStream: TStream);
var
  TokStr: string;
  TokTyp, Ch, BackCh: AnsiChar;
  Step: integer;
  AliasName, Port, Host, ServiceName, Protokoll: string;

  function NextCh: boolean;
  begin
    if not (BackCh in [' ', #0, #8, #10]) then
    begin
      Ch := BackCh;
      BackCh := #0;
      Result := true;
    end else
    begin
      while AStream.Position < AStream.Size do
      begin
        AStream.ReadBuffer(Ch, 1);
        if not (Ch in [' ', #8, #10]) then
        begin
          Result := true;
          Exit;
        end;
      end;
      Ch := #0;

    end;
  end;

  function NextTok: boolean;
  begin
    Result := false;
    while NextCh do
    begin
      case Ch of
        '#': repeat NextCh until Ch in [#0, #13];
        '(', ')', '=': begin
          TokTyp := Ch; TokStr := Ch;
          Result := true;
          Exit;
        end;
        'A'..'Z', 'a'..'z', '0'..'9', '.', '_', '-', ',': begin
          TokTyp := 'I';  //Ident
          TokStr := Ch;
          while NextCh do
          begin
            if ch in ['A'..'Z', 'a'..'z', '0'..'9', '.', '_', '-', ','] then
            begin
              TokStr := TokStr + Ch;
            end else
            begin
              BackCh := Ch;
              Result := true;
              Exit;
            end;
          end;
        end;
      end; //case
    end;
  end;

  procedure ProcessTok;
  begin
    case TokTyp of
      'I': if Step = 0 then
           begin
             if AliasName <> '' then
             begin
               ProcessAlias(Aliasname, Host, Port, ServiceName, Protokoll);
               AliasName := '';
               Host := '';
               Port := '';
               ServiceName := '';
               Protokoll := '';
             end;
             AliasName := TokStr;
           end else
           begin
             if SameText(TokStr, 'HOST') then
             begin
               NextTok;  //'='
               NextTok;
               Host := TokStr;
             end else
             if SameText(TokStr, 'PORT') then
             begin
               NextTok;  //'='
               NextTok;
               Port := TokStr;
             end else
             if SameText(TokStr, 'SERVICE_NAME') or
                SameText(TokStr, 'SID') then
             begin
               NextTok;  //'='
               NextTok;
               ServiceName := TokStr;
             end else
             if SameText(TokStr, 'PROTOCOL') then
             begin
               NextTok;  //'='
               NextTok;
               Protokoll := TokStr;  //kann SPX sein
             end;
           end;
      '(': Step := Step + 1;
      ')': Step := Step - 1;
    end;
  end;

begin { ReadTns }
  BackCh := #0;
  Step := 0;
  AliasName := '';
  tgAlias.ClearAll;
  tgAliasRow := 1;
  while NextTok do
    ProcessTok;
  if AliasName <> '' then
    ProcessAlias(Aliasname, Host, Port, ServiceName, Protokoll);
  tgAlias.AdjustColWidths;
end;

procedure TFrmTnsImp.ProcessAlias(Aliasname, Host, Port, ServiceName,
  Protokoll: string);
var
  Y: integer;
  Alias1: string;

  procedure ProcessAlias1;
  begin
    Y := tgAliasRow;
    tgAlias.AddCell(1, Y, Alias1);
    tgAlias.AddCell(2, Y, Host);
    tgAlias.AddCell(3, Y, Port);
    tgAlias.AddCell(4, Y, ServiceName);
    Inc(tgAliasRow);
  end;

var
  NextS: string;
begin { ProcessAlias }
  if SameText(Protokoll, 'TCP') then
  begin
    Alias1 := PStrTok(AliasName, ',', NextS);
    while Alias1 <> '' do
    begin
      ProcessAlias1;
      Alias1 := PStrTokNext(',', NextS);
    end;
  end;
end;

end.
