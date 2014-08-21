drop TRIGGER TR_ARTI_CHANGELOG;
drop TRIGGER TR_ARTI_CHANGELOG_AFD;
drop TRIGGER TR_ARTI_CHANGELOG_AFU;

create trigger TR_ARTI_CHANGELOG_AFD ON ARTI after delete as
begin
end;

create trigger TR_ARTI_CHANGELOG_AFU ON ARTI after update as
begin
  declare @S varchar(8000)
  declare @PK varchar(250)
  declare CUR_INS cursor local for select ARTI_NR from inserted
  declare @ARTI_NR varchar(30)
  open CUR_INS
  while 1=1
  begin
    fetch next from CUR_INS
    into @ARTI_NR
    if @@FETCH_STATUS <> 0 break

    set @S = 'ARTI:'
    set @PK = @ARTI_NR

    if isnull((select ARTI_NR from deleted where ARTI_NR=@ARTI_NR), '?') <>
       isnull((select ARTI_NR from inserted where ARTI_NR=@ARTI_NR), '?')
      set @S = @S + 'ARTI_NR('+(select ARTI_NR from deleted)+')->('+(select ARTI_NR from inserted)+') '


    if len(@S) > len('ARTI:')
    begin
      exec ADD_STME 11011, 'webab', @PK, 'N', @S
    end
  end;

end;

