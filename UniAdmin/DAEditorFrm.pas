
//////////////////////////////////////////////////
//  DB Access Components
//  Copyright © 1998-2011 Devart. All right reserved.
//  Base Component Editor
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I Dac.inc}

unit DAEditorFrm;
{$ENDIF}

interface

//md:
{$UNDEF DBTOOLS}

uses
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
{$IFNDEF KYLIX}
  SysUtils, Classes, Graphics, Controls, Forms, DBGrids, Dialogs,
  StdCtrls, ExtCtrls, Buttons,
{$ELSE}
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDBGrids, QDialogs, QStdCtrls, QExtCtrls,
  QButtons, Qt,
{$ENDIF}
{$IFDEF DBTOOLS}
  DBToolsClient,
{$IFDEF CLR}
  System.Text,
{$ENDIF}
{$ENDIF}
{$IFDEF FPC}
  LResources,
{$ENDIF}
   CREditorFrm;
//md DADesignUtils,

type
  TFrmDAEditor = class(TFrmCREditor)
  protected
//md    function GetDADesignUtilsClass: TDADesignUtilsClass;
  public
    procedure CheckConnection(const Component: TComponent);
//md    property DADesignUtilsClass: TDADesignUtilsClass read GetDADesignUtilsClass;
//md:
  end;

implementation
uses
{$IFDEF MSWINDOWS}
  Registry,
{$ENDIF}
{$IFDEF USE_SYNEDIT}
  Menus,
{$ENDIF}
  DB, DAConsts, DBAccess;

//md:
{$R *.dfm}

{ TFrmDAEditor }

//md function TFrmDAEditor.GetDADesignUtilsClass: TDADesignUtilsClass;
//begin
//  Result := TDADesignUtilsClass(FCRDesignUtilsClass);
//end;

procedure TFrmDAEditor.CheckConnection(const Component: TComponent);
var
  Connection: TCustomDAConnection;
begin
  if Component is TCustomDAConnection then
    Connection := TCustomDAConnection(Component)
  else begin
//md    Connection := DADesignUtilsClass.UsedConnection(Component) as TCustomDAConnection;
//md:
    Connection := TCustomDAConnection(Component);
    if Connection = nil then
      DatabaseError(SConnectionNotDefined);
  end;
  if not Connection.Connected then begin
    Connection.Connect;
  {$IFDEF DBTOOLS}
    DBTools.CheckConnectionChanges;
  {$ENDIF}
  end;
end;

{$IFDEF FPC}
initialization
  {$i DAEditor.lrs}
{$ENDIF}

end.
