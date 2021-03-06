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
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    procedure SetCap();
  public
    { Public-Deklarationen }
  end;

// Meldungen
type
	MSG = record
  	MSG1: String;
    MSG2: String;
end;

var
  AddCommand: TAddCommand;
  Meldung: MSG;

implementation

uses
	gnugettext;

{$R *.xfm}

procedure TAddCommand.cmdAbortClick(Sender: TObject);
begin
Close();
end;

procedure TAddCommand.cmdOKClick(Sender: TObject);
begin
// �berpr�fen
if(txtCommand.Text<>'') then // Wenn Ok
  begin
		// Hinzuf�gen
    Main.lsCommands.Items.Add(txtCommand.Text);
		Self.Hide;
  end
else // Wenn kein Kommando eingegeben wurde
	begin
  	ShowMessage(Meldung.MSG2);
  end;
end;

procedure TAddCommand.FormCreate(Sender: TObject);
begin
	gnugettext.TranslateProperties (self);
  SetCap(); // �bersetzen
end;

// �bersetzen
procedure TAddCommand.SetCap();
begin
// Fenster
// Kommando
lblCommand.Caption:=_('Command:');
// Ok
cmdOk.Caption:=_('Ok');
// Abbrechen
cmdAbort.Caption:=_('Abort');

// Meldungen
// Wollen Sie wirklich Abbrechen?
Meldung.MSG1:=_('Abort?');
// Sie m�ssen zuerst ein Kommando eingeben.
Meldung.MSG2:=_('Add a command first.');
end;

procedure TAddCommand.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
// Nachfragen
if(MessageDlg('',Meldung.MSG1,mtConfirmation,[mbYes, mbNo],0) = mrYes) then
	begin
		// Wenn Ja
  	CanClose:=true;
  end
else
	begin
  	// Wenn Nein
    CanClose:=false;
  end;
end;

end.
