program iDME;

uses
  QForms,
  frmMain in 'frmMain.pas' {Main},
  frmAddCommand in 'frmAddCommand.pas' {AddCommand},
  frmGPL in 'frmGPL.pas' {GPL},
  frmEditCommand in 'frmEditCommand.pas' {EditCommand};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'iDME - iDesk Menu Editor';
  Application.CreateForm(TMain, Main);
  Application.CreateForm(TAddCommand, AddCommand);
  Application.CreateForm(TGPL, GPL);
  Application.CreateForm(TEditCommand, EditCommand);
  Application.Run;
end.
