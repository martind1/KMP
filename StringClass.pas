unit StringClass;
(* String als TObject verwalten
10.02.10 md  erstellt
*)
interface

type
  TString = class(TObject)
  private
    fString: string;
  public
    constructor Create(aString: string);
    property S: string read fString write fString; 
  end;

implementation

{ TString }

constructor TString.Create(aString: string);
begin
  fString := aString;
end;

end.
 