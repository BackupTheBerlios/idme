unit frmAddCommand;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls, frmMain;

type
  TAddCommand = class(TForm)
    lblCommand: TLabel;
    txtCommand: TEdit;
    cmdOK: TButton;
    cmdAbort: TButton;
    procedure cmdAbortClick(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  AddCommand: TAddCommand;

implementation

{$R *.xfm}

procedure TAddCommand.cmdAbortClick(Sender: TObject);
begin
// Nachfragen
if(MessageDlg('','Wollen Sie wirklich Abbrechen?',mtConfirmation,[mbYes, mbNo],0) = mrYes) then
	begin
		// Wenn Ja
  	Close;
  end;
end;

procedure TAddCommand.cmdOKClick(Sender: TObject);
begin
// �berpr�fen
if(txtCommand.Text<>'') then // Wenn Ok
  begin
		// Hinzuf�gen
    Main.lsCommands.Items.Add(txtCommand.Text);
    Close;
  end
else // Wenn kein Kommando eingegeben wurde
	begin
  	ShowMessage('Sie m�ssen zuerst ein Kommando eingeben.');
  end;
end;

end.
