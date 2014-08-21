unit EmailSendKmp;
(* Sendet Emails, indem Sie in eine .EML Datei geschrieben werden
   Zur Weiterverarbeitung mit SendMailSvr
                Unterstützt .EXE Aufrufparameter: EmailFrom=  EmailTo=  EmailOutBox=
   28.05.07 MD  OutBox wird aus Registry gelesen (siehe SendMailSvr)
   18.02.08 MD  Problem: bei Attachments wird body nicht gesendet (geschrieben schon)
                -> Encoding=enUU setzen
   22.10.08 MD  bei Attachments und HTML Boddy wird ein plain HtmlToText als 2.Header mitgesendet.
                Eincoding=MIME funktioniert dann auch.
   24.12.09 MD  EmailCC (kmp\mssql\emaifrm)
   19.01.10 MD  Müller -> Mueller
   04.11.11 md  d2010 Indy 10.x
                entfernt: MaxLineAction, RecvBufferSize, AutenticationType
   13.05.12 md  SSL Google mit TLS: Port 587
   13.05.12 md  SendSmtpMail als public für Direktaufruf (Fehler wenn SendOK=false
                benötigt openssl dll: http://indy.fulgan.com/SSL/
   12.11.12 md  bei Plain Text wird jetzt ein IdText mit charset=Windows-1252 angelegt.

---
Google GMail:
benötigt openssl dll
---

*)
{ TODO -omd : SMTP Erweiterungen }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IdBaseComponent, IdMessage, IdSMTP;

type
  TEmailSendKmp = class(TIdMessage)
  private
    { Private-Deklarationen }
    fEmailFrom: string;
    fEmailTo: string;
    fEmailCC: string;
    fEmailOutBox: string;
    fFilename: string;
    fSendOK: boolean;
    fSmtp: boolean;
    fIdSMTP: TIdSMTP;
    fSmtpAuth: boolean;
    fSmtpAfterPop: boolean;
    fSmtpPort: integer;
    fSmtpServer: string;
    fSmtpPassword: string;
    fSmtpAccount: string;
    function LoadFromRegistry: string;
  protected
    { Protected-Deklarationen }
    procedure CheckParams;
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); reintroduce; overload;
    procedure FillEMail(aSubject, aText, aAttach: string);
    procedure SendEMail(aSubject, aText, aAttach: string);
    procedure SendSmtpMail;
    procedure SmtpConnect;
    procedure SmtpDisconnect;
    procedure SmtpSend;
    property Filename: string read fFilename;
    property SendOK: boolean read fSendOK;
  published
    { Published-Deklarationen }
    property EmailFrom: string read fEmailFrom write fEmailFrom;
    property EmailTo: string read fEmailTo write fEmailTo;
    property EmailCC: string read fEmailCC write fEmailCC;
    property EmailOutBox: string read fEmailOutBox write fEmailOutBox;
    property Smtp: boolean read fSmtp write fSmtp;
    property SmtpServer: string read fSmtpServer write fSmtpServer;
    property SmtpPort: integer read fSmtpPort write fSmtpPort;
    property SmtpAuth: boolean read fSmtpAuth write fSmtpAuth;
    property SmtpAfterPop: boolean read fSmtpAfterPop write fSmtpAfterPop;
    property SmtpAccount: string read fSmtpAccount write fSmtpAccount;
    property SmtpPassword: string read fSmtpPassword write fSmtpPassword;
  end;

  procedure Register;

implementation

uses
  Registry,
  IdAttachmentFile, IdText, IdSSLOpenSSL, IdExplicitTLSClientServerBase,
  Prots, Err__Kmp, GNav_Kmp;

{ TEmailSendKmp }

function TEmailSendKmp.LoadFromRegistry: string;
var
  Reg: TRegistry;
begin
  //Verzeichnis von Registry lesen. Vergl. SendMailSvr
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\MDSO\SendMailSvr', true) then
      result := Reg.ReadString('OutBox');
  finally
    Reg.CloseKey;
    Reg.Free;
  end;
end;

procedure TEmailSendKmp.CheckParams;
var
  NewOutBox: string;
begin
  NewOutBox := EmailOutBox;

  if GNavigator <> nil then
  begin
    if EmailFrom = '' then
      EmailFrom := GNavigator.Paramlist.Values['EmailFrom'];
    if EmailTo = '' then
      EmailTo := GNavigator.Paramlist.Values['EmailTo'];
    if EmailOutBox = '' then
      NewOutBox := GNavigator.Paramlist.Values['EmailOutBox'];
  end;
  if EmailOutBox = '' then
    NewOutBox := LoadFromRegistry;   //vom SendMailSvr

  if EmailOutBox <> NewOutBox then
  begin
    EmailOutBox := NewOutBox;
    if not Smtp then
      Prot0('%s.OutBox=%s', [OwnerDotName(self), NewOutBox]);
  end;
end;

procedure TEmailSendKmp.FillEMail(aSubject, aText, aAttach: string);
// Mail mit Parametern belegen. Für Dpe.Email
// Exception wenn Anhang nicht gefunden
var
  Attach, NextS: string;
  AIdAttachmentFile: TIdAttachmentFile;
  AIdText: TIdText;
  ABody: TStrings;
  Trenner: string;
begin
  CheckParams;
  Clear;
  Flags := [mfDraft];
  ABody := nil;
  Trenner := ',' + CRLF;
  Attach := Trim(PStrTok(aAttach, Trenner, NextS));
  if (Attach <> '') and not FileExists(Attach) then  //es gibt Namen die Komma enthalten!
  begin
    Trenner := ';' + CRLF;
    Attach := Trim(PStrTok(aAttach, Trenner, NextS));
  end;

  (* works wenn ohne Att - 22.10.08 *)
  if (PosI('<HTML', aText) > 0) and (Attach = '') then
  begin
    ContentType := 'text/html';  //; charset=windows-1252
    ContentTransferEncoding := '8bit';
  end else
  if PosI('<HTML', aText) > 0 then
  try
    ABody := TStringList.Create;

    (* Probleme mit alternate - 22.10.08
    ABody.Text := HtmlToText(aText);  //zuerst Text plain
    AIdText := TIdText.Create(MessageParts, ABody);
    AIdText.ContentType := 'text/plain';  //; charset=windows-1252
    *)

    ABody.Text := aText;
    AIdText := TIdText.Create(MessageParts, ABody);
    AIdText.ContentType := 'text/html';  //; charset=windows-1252

    AText := '';  //kein Text mehr bzw. HtmlToText probieren
  finally
    ABody.Free;
  end else
  //Plain Text. 11.11.12 Charset explizit setzen in eigenem MessagePart
  //http://dev-doc.blogspot.de/2012/08/delphi-indy-10-ssl-and-encoding-issues.html
  try
    ABody := TStringList.Create;

    ABody.Text := aText;
    AIdText := TIdText.Create(MessageParts, ABody);
    AIdText.ContentType := 'text/plain';  //; charset=windows-1252
    AIdText.CharSet := 'Windows-1252';   //1251 wäre kyrillisch

    AText := '';  //kein Text mehr bzw. HtmlToText probieren
  finally
    ABody.Free;
  end;

  while Attach <> '' do
  begin
    if not FileExists(Attach) then
      raise EFOpenError.CreateFmt('Attachment "%s" not found.', [ExpandFileName(Attach)]);
    {MessageParts is a TIdMessagePartsList used to store the TIdMessagePart components that make up the message}
    AIdAttachmentFile := TIdAttachmentFile.Create(MessageParts, Attach);
    if CompareText(ExtractFileExt(Attach), '.DOC') = 0 then
      AIdAttachmentFile.ContentType := 'application/msword' else
    if CompareText(ExtractFileExt(Attach), '.PDF') = 0 then
    AIdAttachmentFile.ContentType := 'application/pdf';
    Attach := Trim(PStrTok('', Trenner, NextS));
  end;
  Body.Text := aText;
  if EmailFrom <> '' then
  begin
    From.Text := EmailFrom;
    {From.Address := EdUserEmail.Text;
    From.Name := Application.Title;}
    ReplyTo.EMailAddresses := StrToIntl(EmailFrom);  //Umlaute ersetzen
  end;
  Recipients.EMailAddresses := StrToIntl(EmailTo); //LbEmailTo.Items.CommaText;  { To: header }
  CCList.EMailAddresses := StrToIntl(EmailCC); //ab 24.12.09
  Subject := aSubject; { Subject: header }
  //Priority := TIdMessagePriority(cboPriority.ItemIndex); { Message Priority }
  //CCList.EMailAddresses := edtCC.Text; {CC}
  //BccList.EMailAddresses := edtBCC.Text; {BBC}
  ReceiptRecipient.Text := '';      {indicate that there is no receipt recipiant}
end;

procedure TEmailSendKmp.SendEMail(aSubject, aText, aAttach: string);
// Mail als File speichern (für SendMailSvr)
// Mail direkt versenden (Smtp=true)
var
  FN: string;
begin
  fSendOK := false;
  try
    if Smtp then
    begin
      Prot0('%s SMTP(%s:%d) "%s" an %s', [OwnerDotName(self), SmtpServer, SmtpPort, aSubject, EmailTo]);
      fFilename := '';
      CheckParams;
      Clear;  //alte Adressen und bodies entfernen
      FillEMail(aSubject, aText, aAttach);
      SendSmtpMail;
    end else
    begin
      FN := Format('Outbox=%s To=%s', [ValidDir(EmailOutBox), EmailTo]);
      Prot0('%s save "%s" an %s', [OwnerDotName(self), aSubject, EmailTo]);
      CheckParams;
      ForceDirectories(ValidDir(EmailOutBox));
      FN := CreateUniqueFileName(
        ValidDir(EmailOutBox) + Format('%s_#Y#M#D#H#N#S_#C.EML', [CompName]));
      DeleteFile(FN);
      fFilename := ExtractFilename(FN);    //zur Info merken (ohne Pfad)
      Clear;  //alte Adressen und bodies entfernen
      FillEMail(aSubject, aText, aAttach);
      AddHeader('X-Unsent: 1');           {OE}
      AddHeader('X-Filename: ' + FN);
      SaveToFile(FN);
      fSendOK := true;
    end;
  except on E:Exception do begin
      fFilename := E.Message;    //Fehler Indikator
      EProt(self, E, 'Fehler bei SendEMail%d(%s)', [Ord(Smtp), FN]);
    end;
  end;
end;

procedure TEmailSendKmp.SmtpConnect;
// Connect zu SMTP. Exception bei Fehler.
// für Direktaufruf (Smtp-Properties müssen gefüllt sein. 13.05.12
// Googlemail: http://www.delphi3000.com/articles/article_4796.asp?SK=
//             http://www.marcocantu.com/tips/oct06_gmail.html
var
  IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
begin
  ProtL('%s Connect SMTP %s', [OwnerDotName(self), SMTPServer]);
  if fIdSMTP = nil then
    fIdSMTP := TIdSMTP.Create(self);
  if fSmtpAuth then
    fIdSmtp.AuthType := satDefault else {Simple Login}
    fIdSmtp.AuthType := satNone;
  fIdSmtp.Username := SMTPAccount;
  fIdSmtp.Password := SMTPPassword;
  fIdSmtp.MailAgent := ExtractFileName(Application.ExeName) + '@' + CompName; //X-Mailer
  {General setup}
  fIdSmtp.Host := SMTPServer;
  fIdSmtp.Port := IntDflt(SMTPPort, 25);
  if fIdSmtp.Port = 465 then  //SSL normal
  begin
    IdSSLIOHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(self);
    IdSSLIOHandlerSocket.SSLOptions.Method := sslvSSLv2;
    IdSSLIOHandlerSocket.SSLOptions.Mode := sslmUnassigned;
    IdSSLIOHandlerSocket.SSLOptions.VerifyMode := [];
    IdSSLIOHandlerSocket.SSLOptions.VerifyDepth := 0;
    fIdSmtp.IOHandler := IdSSLIOHandlerSocket;
  end;
  if fIdSmtp.Port = 587 then  //SSL Google mit TLS
  begin
    IdSSLIOHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(self);
    IdSSLIOHandlerSocket.SSLOptions.Method := sslvTLSv1;
    IdSSLIOHandlerSocket.SSLOptions.Mode := sslmUnassigned;
    IdSSLIOHandlerSocket.SSLOptions.VerifyMode := [];
    IdSSLIOHandlerSocket.SSLOptions.VerifyDepth := 0;
    fIdSmtp.IOHandler := IdSSLIOHandlerSocket; //Googlemail mit START TLS
    fIdSmtp.UseTLS := utUseExplicitTLS; //erst hier! utNoTLSSupport;  //utUseImplicitTLS
  end;

  {now we send the message}
  try
    fIdSmtp.Connect;
    //so nicht: if fIdSmtp.Port = 587 then fIdSmtp.SendCmd('STARTTLS', 220); //SSL Google mit TLS
  except on E:Exception do
    EError('Fehler bei Connect SMTP %s:%d - %s', [fIdSmtp.Host, fIdSmtp.Port, E.Message]);
  end;
end;

procedure TEmailSendKmp.SmtpSend;
begin
  fIdSmtp.Send(self);
end;

procedure TEmailSendKmp.SmtpDisconnect;
begin
  ProtL('%s Disconnect SMTP %s', [OwnerDotName(self), SMTPServer]);
  fIdSmtp.Disconnect;
end;

procedure TEmailSendKmp.SendSmtpMail;
// Mail per Smtp versenden. Aufruf in SendEMail.
// für Direktaufruf (Smtp-Properties müssen gefüllt sein. 13.05.12
begin
  fSendOK := false;
  try
    SmtpConnect;
    try
      try
        SmtpSend;
        fSendOK := true;
      except on E:Exception do begin
          fFilename := E.Message;    //Fehler Indikator
          EProt(self, E, 'Fehler bei SMTP.Send', [0]);
        end;
      end;
    finally
      SmtpDisconnect;
    end;

  except on E:Exception do begin
      fFilename := E.Message;    //Fehler Indikator
      EProt(self, E, 'Fehler bei SendSmtpMail(%s:%d)', [SmtpServer, SmtpPort]);
    end;
  end;
end;

procedure Register;
begin
  RegisterComponents('GNAV', [TEmailSendKmp]);
end;

constructor TEmailSendKmp.Create(AOwner: TComponent);
begin
  inherited;
  fSmtpPort := 25;
end;

end.
