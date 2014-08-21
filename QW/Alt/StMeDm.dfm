object DmStme: TDmStme
  OldCreateOrder = False
  Left = 495
  Top = 353
  Height = 421
  Width = 598
  object Session1: TuSession
    SessionName = 'SESSION1'
    Left = 8
    Top = 8
  end
  object Database1: TuDataBase
    Username = 'quva'
    LoginPrompt = False
    AliasName = 'QwLokal'
    DatabaseName = 'DB_STME'
    SessionName = 'Session1_3'
    Params.Strings = (
      'USER NAME=quva'
      'Port=0')
    TransIsolation = tiDirtyRead
    StartConnect = False
    Left = 72
    Top = 8
  end
  object QueSTME: TuQuery
    SQL.Strings = (
      'select /*+RULE */'
      'count(*)'
      'from STOERMELDUNGEN')
    DatabaseName = 'DB1'
    SessionName = 'SESSION'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 136
    Top = 8
  end
end
