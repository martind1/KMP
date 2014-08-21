unit Expkufrm;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Qwf_Form, StdCtrls, Buttons, ExtCtrls, Lnav_kmp, DatumDlg,
  DB,  Uni, DBAccess, MemDS;

type
  TSpk = record
    case integer of
      0: (LoByte,
          HiByte: byte);
      1: (W: word);
  end;
type
  TFrmExpKu = class(TqForm)
    Nav: TLNavigator;
    BtnClose: TBitBtn;
    Label1: TLabel;
    EdVon: TEdit;
    DatumBtn1: TDatumBtn;
    Label2: TLabel;
    EdBis: TEdit;
    DatumBtn2: TDatumBtn;
    BtnStart: TBitBtn;
    Label3: TLabel;
    lbProt: TListBox;
    Label4: TLabel;
    EdFnAddr: TEdit;
    LaStatus: TLabel;
    LDataSource1: TLDataSource;
    Query1: TuQuery;
    Label5: TLabel;
    EdEdv: TEdit;
    EdFnAcc: TEdit;
    Label6: TLabel;
    EdFnAdAc: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    EdZtTage: TEdit;
    procedure BtnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BtnStartClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FrmExpKu: TFrmExpKu;

implementation
{$R *.DFM}
uses
  Prots, AbortDlg, Ini__Kmp, Err__Kmp,
  ParaFrm;

procedure TFrmExpKu.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmExpKu.FormCreate(Sender: TObject);
begin
  FrmExpKu := self;
  EdFnAddr.Text := IniKmp.ReadString('Umgebung','FnAddr','\SUNEXP\KDADRESS.DAT');
  EdFnAcc.Text := IniKmp.ReadString('Umgebung','FnAcc','\SUNEXP\KDKONTEN.DAT');
  EdFnAdAc.Text := IniKmp.ReadString('Umgebung','FnAcc','\SUNEXP\KDZUORD.DAT');
  EdZtTage.Text := IniKmp.ReadString('Umgebung','ZtTage','14');
  EdEdv.Text := Nav.FltrList.Values['KUND_EDV'];
  EdBis.Text := DateToStr(date);
end;

procedure TFrmExpKu.FormDestroy(Sender: TObject);
begin
  IniKmp.WriteString('Umgebung', 'FnAddr', EdFnAddr.Text);
  IniKmp.WriteString('Umgebung', 'FnAcc', EdFnAcc.Text);
  IniKmp.WriteString('Umgebung', 'FnAdAc', EdFnAdAc.Text);
  IniKmp.WriteString('Umgebung', 'ZtTage', EdZtTage.Text);
  FrmExpKu := nil;
end;

procedure TFrmExpKu.FormActivate(Sender: TObject);
begin
  Prot.ListBox := lbProt;
end;

procedure WriteFmt( var F: TextFile; const Fmt: string; const Args: array of const);
begin
  Write(F, Format(Fmt, Args));
end;

procedure TFrmExpKu.BtnStartClick(Sender: TObject);
var
  N: integer;
  fAddr, fAcc, fAdAc: TextFILE;

  procedure ExportKunde;
  begin
    with Query1 do
    begin
      writefmt(fAddr, '%05.5d     ', [FieldByName('KUND_NR').AsInteger]);
      writefmt(fAddr, '%19s', [' ']);
      writefmt(fAddr, '%3s', ['ADD']);
      writefmt(fAddr, '%10.10s', [UpperCase(FieldByName('KUND_NA1').AsString)]);
      writefmt(fAddr, '%8s', [FormatDateTime('YYYYMMDD',
                             FieldByName('LETZTE_AENDERUNG').AsDateTime)]);
      writefmt(fAddr, '%-35.35s', [FieldByName('KUND_NA1').AsString]);
      writefmt(fAddr, '%-35.35s', [FieldByName('KUND_NA2').AsString]);
      writefmt(fAddr, '%-35.35s', [Format('%s %s',
                                   [FieldByName('KUND_STR').AsString,
                                    FieldByName('KUND_HNR').AsString])]);
      writefmt(fAddr, '%-35.35s', [' ']);
      writefmt(fAddr, '%-35.35s', [Format('%s %s',
                                   [FieldByName('KUND_PLZ').AsString,
                                    FieldByName('KUND_ORT').AsString])]);
      writefmt(fAddr, '%-35.35s', [' ']);
      writefmt(fAddr, '%-15.15s', [FieldByName('KUND_TEL').AsString]);
      writefmt(fAddr, '%-15.15s', [' ']);
      writefmt(fAddr, '%-15.15s', [FieldByName('KUND_FAX').AsString]);
      writefmt(fAddr, '%-30.30s', [copy(GetFieldText(
                                  FieldByName('BEMERKUNG')),1,30)]);
      writefmt(fAddr, '%-4.4s', [' ']);
      writefmt(fAddr, '%-30.30s', [copy(GetFieldText(
                                  FieldByName('BEMERKUNG')),31,30)]);
      WriteLn(fAddr);

      writefmt(fAcc, 'KD%05.5d   ', [FieldByName('KUND_NR').AsInteger]);
      writefmt(fAcc, '%19s', [' ']);
      writefmt(fAcc, '%3s', ['ACC']);
      writefmt(fAcc, '%10.10s', [UpperCase(FieldByName('KUND_NA1').AsString)]);
      writefmt(fAcc, '%8s', [FormatDateTime('YYYYMMDD',
                             FieldByName('LETZTE_AENDERUNG').AsDateTime)]);
      writefmt(fAcc, '%-35.35s', [Format('%s %s',
                                   [FieldByName('KUND_NA1').AsString,
                                    FieldByName('KUND_NA2').AsString])]);
      writefmt(fAcc, '%-1.1s', ['D']);
      writefmt(fAcc, '%-1.1s', ['O']);
      writefmt(fAcc, '%-54.54s', [' ']);
      writefmt(fAddr, '%05.5d     ', [FieldByName('KUND_NR').AsInteger]);
      writefmt(fAcc, '%-13.13s', [' ']);
      writefmt(fAcc, '%03.3d', [StrToIntTol(EdZtTage.Text)]);
      writefmt(fAcc, '%-115.115s', [' ']);
      writefmt(fAcc, '%-120.120s', [' ']);
      writefmt(fAcc, '%-174.174', [' ']);
      WriteLn(fAcc);

      writefmt(fAddr, '%05.5d     ', [FieldByName('KUND_NR').AsInteger]);
      writefmt(fAdAc, '%19s', [' ']);
      writefmt(fAdAc, '%3s', ['ADB']);
      writefmt(fAddr, '%05.5d     ', [FieldByName('KUND_NR').AsInteger]);
      writefmt(fAdAc, '%8s', [FormatDateTime('YYYYMMDD',
                             FieldByName('LETZTE_AENDERUNG').AsDateTime)]);
      writefmt(fAdAc, 'KD%05.5d   ', [FieldByName('KUND_NR').AsInteger]);
      writefmt(fAdAc, '%-54.54', [' ']);
      WriteLn(fAdAc);
    end;
  end;

begin
  AssignFile(fAddr, EdFnAddr.Text);
  Rewrite(fAddr);
  AssignFile(fAcc, EdFnAcc.Text);
  Rewrite(fAcc);
  AssignFile(fAdAc, EdFnAdAc.Text);
  Rewrite(fAdAc);
  try
    Nav.FltrList.Values['KUND_EDV'] := EdEdv.Text;
    Nav.FltrList.Values['LETZTE_AENDERUNG'] := EdVon.Text + '..' + EdBis.Text;
    N := 0;
    Prot0('Start Export Kunden(%s)(%s)',
      [Nav.FltrList.Values['KUND_EDV'],
       Nav.FltrList.Values['LETZTE_AENDERUNG']]);
    Query1.Open;
    while not Query1.EOF do
    begin
      Inc(N);
      ProtP('%5d %s', [N, Query1.FieldByName('KUND_NR').AsString,
        Query1.FieldByName('KUND_NA1').AsString]);
      ExportKunde;
      Query1.Next;
    end;
    Prot0('Ende Export (%d exportiert)', [N]);
  finally
    CloseFile(fAddr);
    CloseFile(fAcc);
    CloseFile(fAdAc);
  end;
end;

end.
