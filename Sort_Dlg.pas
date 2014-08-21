unit Sort_dlg;
(* Dialog für Sortieren
15.08.00 MD  Positionieren [X]
21.11.13 md  bei erfolgreichem genauen Vergleich abbrechen

*)

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls,
  Qwf_Form, DPos_Kmp;

type
  TDlgSort = class(TqForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    KeyLabel: TLabel;
    lbKeys: TListBox;
    chbAbsteigend: TCheckBox;
    chbPermanent: TCheckBox;
    chbGotoPos: TCheckBox;
    procedure lbKeysDblClick(Sender: TObject);
    procedure lbKeysClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure chbAbsteigendClick(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
    KeyList: TValueList;
    KeyFields: string;
    KeysIdx: string;
    Desc: boolean;
    SMessDone: boolean;
  public
    { Public declarations }
    class function Execute(Sender: TObject; AKeyList: TValueList;
                           var AKeyFields: string; var Permanent: boolean): integer;
    (* Sortierdialog. Ergibt 0 wenn 'ohne' ausgewählt
                             1 + Index in AKeyList wenn Key ausgewählt
                            -1 wenn Abbruch *)
  end;

var
  DlgSort: TDlgSort;

implementation
{$R *.DFM}
uses
  SysUtils,
  Prots, Ini__Kmp, GNav_Kmp, KmpResString;

class function TDlgSort.Execute(Sender: TObject; AKeyList: TValueList;
  var AKeyFields: string; var Permanent: boolean): integer;
(* Sortierdialog. Ergibt 0 wenn 'ohne' ausgewählt
                         1 + Index in AKeyList wenn Key ausgewählt
                        -1 wenn Abbruch *)
var
  I, Modus: integer;
  S1, NextS, AscKeyFields: string;
begin
  result := -1;
  DlgSort := TDlgSort.Create(Application.MainForm);
  try
    DlgSort.KeyList.Assign(AKeyList);
    if (Sender <> nil) and (Sender is TControl) then
    begin
      DlgSort.Left := TControl(Sender).Left;
      DlgSort.Top := TControl(Sender).Top + 50;
    end;
    DlgSort.lbKeys.Items.Clear;    {Löschen und mit Daten füllen}
    DlgSort.lbKeys.Items.Add(SSort_Dlg_001);	// '(ohne)'
    DlgSort.lbKeys.ItemIndex := 0;
    DlgSort.KeysIdx := '';
    AscKeyFields := StrCgeStrStr(AKeyFields, ' desc', '', true);
    for Modus := 1 to 2 do
    begin
      for I:= 0 to AKeyList.Count-1 do {über alle Keys}
      begin
        if Char1(AKeyList.Param(I)) <> ';' then
        begin
          DlgSort.lbKeys.Items.Add(AKeyList.Param(I));   {Linke Seite Eintragen}
          if ((Modus = 1) and (AKeyFields = DlgSort.KeyList.Value(I))) or
             ((Modus = 2) and (AscKeyFields = DlgSort.KeyList.Value(I))) then
          try
            DlgSort.lbKeys.ItemIndex := I+1;        {markieren des aktuellen Keys}
            DlgSort.lbKeys.Selected[I+1] := true;
            if AKeyFields <> DlgSort.KeyList.Value(I) then
              DlgSort.chbAbsteigend.Checked := true;
            AppendTok(DlgSort.KeysIdx, IntToStr(I+1), ';');
          except
          end;
        end else
          DlgSort.lbKeys.Items.Add('-');    {damit Index stimmt}
      end;
      if DlgSort.lbKeys.ItemIndex > 0 then
        Break;  //bei erfolgreichem genauen Vergleich abbrechen
    end;
    DlgSort.chbAbsteigend.Enabled := DlgSort.lbKeys.ItemIndex > 0;
    DlgSort.chbPermanent.Enabled := Permanent;
    DlgSort.chbGotoPos.Checked := SysParam.GotoPos;
    DlgSort.KeyFields := AKeyFields;
    if DlgSort.chbAbsteigend.Enabled then
      DlgSort.Desc := DlgSort.chbAbsteigend.Checked;
    if (DlgSort.ShowModal = mrOK) and (DlgSort.lbKeys.ItemIndex >= 0) then
    begin
      if DlgSort.lbKeys.ItemIndex = 0 then {'ohne' ausgesucht}
      begin
        AKeyFields := '';
        result := 0;
      end else {DlgSort.lbKeys.ItemIndex > 0}
      begin
        {AKeyFields := DlgSort.KeyFields;}
        (*
        AKeyFields := '';
        for I := 1 to DlgSort.lbKeys.Items.Count - 1 do
          if I <> DlgSort.lbKeys.ItemIndex  then
            if DlgSort.lbKeys.Selected[I] then
              AppendTok(AKeyFields, DlgSort.KeyList.Value(I - 1), ';');
        AppendTok(AKeyFields,                                    {zum Schluß!}
          DlgSort.KeyList.Value(DlgSort.lbKeys.ItemIndex - 1), ';');
        *)
        if DlgSort.KeysIdx <> '' then
        begin
          AKeyFields := '';
          S1 := PStrTok(DlgSort.KeysIdx, ';', NextS);
          I := StrToIntTol(S1);
          while I > 0 do
          begin
            AppendTok(AKeyFields, DlgSort.KeyList.Value(I - 1), ';');
            S1 := PStrTok('', ';', NextS);
            I := StrToIntTol(S1);
          end;
        end;
        result := DlgSort.lbKeys.ItemIndex;
      end;
      Permanent := DlgSort.chbPermanent.Checked;
    end;
    SysParam.FGotoPos := DlgSort.chbGotoPos.Checked;
    IniKmp.WriteBool(SSortierung, 'GotoPos', SysParam.FGotoPos);{auch bei Cancel}
  finally
    DlgSort.Release;
    DlgSort := nil;
  end;
end;

procedure TDlgSort.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if SMessDone then
    Exit;
  SMessDone := true;
  if KeyFields <> '' then
    SMess(SSort_Dlg_002, [KeyFields]) else	// 'Sortierung nach %s'
    SMess(SSort_Dlg_003, [0]);			// 'Ohne Sortierung'
end;

procedure TDlgSort.lbKeysClick(Sender: TObject);
var
  AList: TFltrList;
  I: integer;
begin
  if lbKeys.ItemIndex > 0 then
  begin
    AList := TFltrList.Create;
    try
      (*if lbKeys.SelCount = 1 then
      begin
        KeyFields := KeyList.Value(lbKeys.ItemIndex - 1);
      end else
      if lbKeys.SelCount > 1 then
      begin
        AppendTok(KeyFields, KeyList.Value(lbKeys.ItemIndex - 1), ';');
      end;*)
      if lbKeys.SelCount = 1 then               {für die Reihenfolge des klickens}
      begin
        KeysIdx := IntToStr(lbKeys.ItemIndex);
      end else
      if lbKeys.SelCount > 1 then
      begin
        if KeysIdx = '' then
        begin
          for I := 0 to lbKeys.Items.Count - 1 do
            if lbKeys.Selected[I] then
              AppendTok(KeysIdx, IntToStr(I), ';');
        end else
          AppendTok(KeysIdx, IntToStr(lbKeys.ItemIndex), ';');
      end;

      AList.AddTokens(KeyList.Value(lbKeys.ItemIndex - 1), ';,');
      Desc := false;
      for I := 0 to AList.Count - 1 do
        if PosI(' desc', AList[I]) > 0 then
        begin
          Desc := true;
          break;
        end;
      chbAbsteigend.Checked := Desc;
      //SMess(SSort_Dlg_002, [KeyList.Value(lbKeys.ItemIndex - 1)]); // 'Sortierung nach %s'
      SMess(SSort_Dlg_002, [KeyFields]); // 'Sortierung nach %s'
    finally
      AList.Free;
    end;
  end else
  begin
    SMess(SSort_Dlg_003, [0]);		// 'Ohne Sortierung'
    chbAbsteigend.Checked := false;
  end;
  chbAbsteigend.Enabled := lbKeys.ItemIndex > 0;
end;

procedure TDlgSort.chbAbsteigendClick(Sender: TObject);
var
  AList: TFltrList;
  S1, S2: string;
  I, P: integer;
begin
  if lbKeys.ItemIndex > 0 then
  begin
    AList := TFltrList.Create;
    try
      AList.AddTokens(KeyList.Value(lbKeys.ItemIndex - 1), ';');
      S1 := KeyList.Param(lbKeys.ItemIndex - 1) + '=';
      for I := 0 to AList.Count - 1 do
      begin
        S2 := AList[I];
        P := PosI(' desc', S2);
        if (P <= 0) and not Desc and chbAbsteigend.Checked then
          AddStr(S2, ' desc') else
        if (P > 0) and Desc and not chbAbsteigend.Checked then
          System.Delete(S2, P, 250);
        if I > 0 then
          AddStr(S1, ';');
        AddStr(S1, S2);
      end;
      KeyList[lbKeys.ItemIndex - 1] := S1;
      // 'Sortierung nach %s'
      SMess(SSort_Dlg_002, [KeyList.Value(lbKeys.ItemIndex - 1)]);
    finally
      AList.Free;
    end;
  end;
end;

procedure TDlgSort.lbKeysDblClick(Sender: TObject);
begin
  OKBtn.Click;
end;

procedure TDlgSort.FormCreate(Sender: TObject);
begin
  KeyList := TValueList.Create;
  GNavigator.TranslateForm(self);
end;

procedure TDlgSort.FormDestroy(Sender: TObject);
begin
  KeyList.Free;
end;

end.
