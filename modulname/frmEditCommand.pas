unit frmEditCommand;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls, frmMain;

type
  TEditCommand = class(TForm)
    lblCmdEdit: TLabel;
    txtCmdEdit: TEdit;
    cmdOk: TButton;
    cmdAbort: TButton;
    procedure FormCreate(Sender: TObject);
    procedure cmdOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cmdAbortClick(Sender: TObject);
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
end;

var
  EditCommand: TEditCommand;
  Index: Integer;
  Meldung: MSG;

implementation

uses
	gnugettext;

{$R *.xfm}

procedure TEditCommand.FormCreate(Sender: TObject);
begin
gnugettext.TranslateProperties (self);
SetCap(); // Übersetzen
end;

// Übersetzen
procedure TEditCommand.SetCap();
begin
// Fenster
// Kommando
lblCmdEdit.Caption:=_('Command:');
// Übernehmen
cmdOk.Caption:=_('Ok');
// Abbrechen
cmdAbort.Caption:=_('Abort');

// Meldungen
// Wollen Sie wirklich Abbrechen?
Meldung.MSG1:=_('Abort?');
end;

procedure TEditCommand.cmdOkClick(Sender: TObject);
begin
// Übernehmen
Main.lsCommandsE.Items.Delete(Index);
Main.lsCommandsE.Items.Add(txtCmdEdit.Text);
// Ausblenden
txtCmdEdit.Text:='';
Self.Hide;
end;

procedure TEditCommand.FormShow(Sender: TObject);
begin
// Kommando Laden
txtCmdEdit.Text:=Main.lsCommandsE.Items[Index];
end;

procedure TEditCommand.cmdAbortClick(Sender: TObject);
begin
Close();
end;

procedure TEditCommand.FormCloseQuery(Sender: TObject;
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
