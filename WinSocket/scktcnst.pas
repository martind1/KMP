
{*******************************************************}
{                                                       }
{       Borland Delphi Visual Component Library         }
{                                                       }
{       Copyright (c) 1997,99 Inprise Corporation       }
{                                                       }
{*******************************************************}

unit ScktCnst;

interface

const
  //Do not localize
  KEY_SOCKETSERVER  = '\SOFTWARE\Borland\Socket Server';
  KEY_IE            = 'SOFTWARE\Microsoft\Internet Explorer';
  csSettings        = 'Settings';
  ckPort            = 'Port';
  ckThreadCacheSize = 'ThreadCacheSize';
  ckInterceptGUID   = 'InterceptGUID';
  ckShowHost        = 'ShowHost';
  ckTimeout         = 'Timeout';
  ckRegistered      = 'RegisteredOnly';
  SServiceName      = 'SocketServer';
  SApplicationName  = 'Borland Socket Server';

resourcestring
  SServiceOnly = 'Der Socket-Server kann auf Win NT 3.51 und �lter als Service ausgef�hrt werden';
  SErrClose = 'Das Programm kann nicht beendet werden, da noch aktive Verbindungen bestehen. '+
'Sollen diese Verbindungen abgebrochen werden?';
  SErrChangeSettings = 'Die Einstellungen k�nnen nicht ge�ndert werden, da noch aktive Verbindungen '+
'bestehen. Sollen diese Verbindungen abgebrochen werden?';
  SQueryDisconnect = 'Wenn die Verbindung zu den Clients getrennt wird, kann das zu Fehlern in der '+
'Anwendung f�hren. Weiter?';
  SOpenError = 'Fehler beim �ffnen von Port %d. Fehler: %s';
  SHostUnknown = '(Unbekannt)';
  SNotShown = '(Nicht angezeigt)';
  SNoWinSock2 = 'Vor Verwendung der Socket-Verbindung mu� Winsock 2 installiert werden';
  SStatusline = '%d aktuelle Verbindungen';
  SAlreadyRunning = 'Der Socket-Server wird bereits ausgef�hrt';
  SNotUntilRestart = 'Die �nderungen werden erst nach Neustart des Socket-Server wirksam';

implementation

end.
 