program Project6;

uses
  Forms,
  USBStateChange in 'USBStateChange.pas' {Form6};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm6, Form6);
  Application.Run;
end.
