unit frmMain;

(*
#####################################################
#            iDME - iDesk Menu Editor               #
#             Written by Andre Hauke                #
#                                                   #
#                Version Alpha 0.2                  #
#                                                   #
#              cfa2k@users.berlios.de               #
#              http://idme.berlios.de               #
#                                                   #
#               Released under GPL                  #
#####################################################
*)

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls, QComCtrls, QButtons, QMenus, QExtCtrls, LinuxFormManager,
  Functions, fraiDeskConfig;

type
  TMain = class(TForm)
    Menu: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet3: TTabSheet;
    lblTitle: TLabel;
    txtTitle: TEdit;
    lblCommands: TLabel;
    lsCommands: TListBox;
    lblIcon: TLabel;
    txtIcon: TEdit;
    chkSVG: TCheckBox;
    lblWidth: TLabel;
    txtWidth: TEdit;
    lblHeight: TLabel;
    txtHeight: TEdit;
    lblX: TLabel;
    txtX: TEdit;
    txtY: TEdit;
    lblY: TLabel;
    cmdCreate: TButton;
    cmdAbort: TButton;
    cmdAdd: TButton;
    cmdDel: TButton;
    cmdDelAll: TButton;
    cmdDir: TSpeedButton;
    OpenIcon: TOpenDialog;
    lsLnks: TListBox;
    popEdit: TPopupMenu;
    popDel: TMenuItem;
    lblName: TLabel;
    lblVersion: TLabel;
    lblCopy: TLabel;
    lblCMail: TLabel;
    lblGFXMail: TLabel;
    txtTitleE: TEdit;
    lblTitleE: TLabel;
    lblCommandsE: TLabel;
    lsCommandsE: TListBox;
    lblIconE: TLabel;
    txtIconE: TEdit;
    chkSVGE: TCheckBox;
    lblWidthE: TLabel;
    txtWidthE: TEdit;
    lblHeightE: TLabel;
    txtHeightE: TEdit;
    lblXE: TLabel;
    lblYE: TLabel;
    txtYE: TEdit;
    cmdSaveE: TButton;
    cmdAddE: TButton;
    cmdEditE: TButton;
    cmdDelE: TButton;
    cmdIconE: TSpeedButton;
    txtXE: TEdit;
    imgLogo: TImage;
    lblGFX: TLabel;
    lblBerlios: TLabel;
    lblGUP: TLabel;
    lblGPL: TLabel;
    chkUpdateCheck: TCheckBox;
    lbliDeskDir: TLabel;
    txtiDeskDir: TEdit;
    chkSDir: TCheckBox;
    chkiDeskVCheck: TCheckBox;
    fraInfo: TGroupBox;
    mInfo: TMemo;
    chkBugLog: TCheckBox;
    tmrInputCheck: TTimer;
    tmrInputCheck2: TTimer;
    TabSheet5: TTabSheet;
    fraConvertKDE: TGroupBox;
    lsKDEIcons: TListBox;
    cmdConvertStart: TButton;
    StatusBar: TProgressBar;
    ConvertPopup: TPopupMenu;
    AlleMakieren1: TMenuItem;
    MarkierungUmkehren1: TMenuItem;
    TabSheet6: TTabSheet;
    lblFont: TLabel;
    cboFont: TComboBox;
    dlgFont: TFontDialog;
    Button1: TButton;
    procedure cmdAddClick(Sender: TObject);
    procedure cmdDirClick(Sender: TObject);
    procedure cmdCreateClick(Sender: TObject);
    procedure MenuChange(Sender: TObject);
    procedure lsLnksClick(Sender: TObject);
    procedure popDelClick(Sender: TObject);
    procedure cmdAbortClick(Sender: TObject);
    procedure txtWidthKeyPress(Sender: TObject; var Key: Char);
    procedure txtHeightKeyPress(Sender: TObject; var Key: Char);
    procedure txtXKeyPress(Sender: TObject; var Key: Char);
    procedure txtYKeyPress(Sender: TObject; var Key: Char);
    procedure txtWidthEKeyPress(Sender: TObject; var Key: Char);
    procedure txtHeightEKeyPress(Sender: TObject; var Key: Char);
    procedure txtXEKeyPress(Sender: TObject; var Key: Char);
    procedure txtYEKeyPress(Sender: TObject; var Key: Char);
    procedure lblGPLClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tmrInputCheckTimer(Sender: TObject);
    procedure cmdSaveEClick(Sender: TObject);
    procedure cmdIconEClick(Sender: TObject);
    procedure tmrInputCheck2Timer(Sender: TObject);
    procedure cmdEditEClick(Sender: TObject);
    procedure cmdDelClick(Sender: TObject);
    procedure cmdDelAllClick(Sender: TObject);
    procedure chkSDirClick(Sender: TObject);
    procedure lblGPLMouseEnter(Sender: TObject);
    procedure lblGPLMouseLeave(Sender: TObject);
    procedure cmdConvertStartClick(Sender: TObject);
    procedure AlleMakieren1Click(Sender: TObject);
    procedure MarkierungUmkehren1Click(Sender: TObject);
  private
    procedure GetLnk(list: tlistbox;const Directory: string;
		const FileMask: string = '*.*');
    procedure SetCap();
    procedure CleanAdd();
    procedure CleanEdit();
    procedure ConvertKDELink(Link: String);
  public
    { Public-Deklarationen }
  end;

// Meldungen
type
	MSG = record
	MSG1: String;
  MSG2: String;
  MSG3: String;
  MSG4: String;
  MSG5: String;
  MSG6: String;
end;

type
	lnkTemp = record
  Caption: String;
	Command: String;
  Icon: String;
end;

var
  Main: TMain;
  Version: String;
  Meldung: MSG;
  HomeDir: String;
  rKDE: lnkTemp;

implementation

uses frmAddCommand,frmGPL,gnugettext,frmEditCommand;

{$R *.xfm}

procedure TMain.cmdAddClick(Sender: TObject);
begin
// Kommando Hinzufügen
AddCommand.ShowModal;
end;

// Bild Informationen ermitteln (Breite etc.)
// Autor: Brad Stowers
function ReadMWord(f: TFileStream): Word;
type
  TMotorolaWord = record
    case Byte of
      0: (Value: Word);
      1: (Byte1, Byte2: Byte);
  end;
var
  MW: TMotorolaWord;
begin
  { It would probably be better to just read these two bytes in normally }
  { and then do a small ASM routine to swap them.  But we aren't talking }
  { about reading entire files, so I doubt the performance gain would be }
  { worth the trouble. }
  f.read(MW.Byte2, SizeOf(Byte));
  f.read(MW.Byte1, SizeOf(Byte));
  Result:=MW.Value;
end;

procedure TMain.cmdDirClick(Sender: TObject);
type
  TPNGSig = array[0..7] of Byte;
const
  ValidSig: TPNGSig = (137,80,78,71,13,10,26,10);
var
  Sig: TPNGSig;
  f: tFileStream;
  x: integer;
  sFile: String;
begin
// Icon Auswahl Anzeigen
OpenIcon.InitialDir:=HomeDir; // Home Verzeichnis

if (OpenIcon.Execute = true) and (OpenIcon.FileName <> '') then
	txtIcon.Text:=OpenIcon.FileName;

  if(pos('png',lowercase(OpenIcon.FileName))<>0) then // Wenn PNG
  	// Breite und Höhe ermitteln
    sFile:=OpenIcon.FileName;
    FillChar(Sig, SizeOf(Sig), #0);
  	f:=TFileStream.Create(sFile, fmOpenRead);
  		try
    		f.read(Sig[0], SizeOf(Sig));
    	for x := Low(Sig) to High(Sig) do
      	if Sig[x] <> ValidSig[x] then Exit;
    			f.Seek(18, 0);
    			txtWidth.Text:=IntToStr(ReadMWord(f));
    			f.Seek(22, 0);
    			txtHeight.Text:=IntToStr(ReadMWord(f));
  		finally
    		f.Free;
  		end;
end;

procedure TMain.cmdCreateClick(Sender: TObject);
var
	Lnk: Textfile;
  iDeskDir: String;
  iDeskLnk: String;
  Title: String;
  i: Integer;

  Commands: String;
  SVG: String;
begin
// iDesk Verzeichnis
iDeskDir:=HomeDir+'/.idesktop';

// SVG
if(chkSVG.Checked=true) then // Wenn ausgewählt
  begin
		SVG:='true';
  end
else // Wenn nicht ausgewählt
	begin
  	SVG:='false';
  end;

// Kommandos
if(lsCommands.Items.Count>1) or (lsCommands.Items.Count=0) then // Wenn mehr als 1 Eintrag
  begin
		for i:=0 to lsCommands.Items.Count -1 do
  		begin
				Commands:=Commands + ' Command[' + inttostr(i) + ']: ' + lsCommands.Items.Strings[i];
        if(lsCommands.Items.Count-1 <> i) then // Solange nicht letzes Item
        	 Commands:=Commands + chr(10);
      end;
  end
else
	begin
   	if(lsCommands.Items.Count<>0) then // Wenn nicht leer
    	Commands:=' Command: ' + lsCommands.Items.Text;
  end;


		// Inhalt der Lnk Datei
		iDeskLnk:='table Icon' + chr(10) +
							'	Caption: ' + txtTitle.Text + chr(10) +
          		Commands + chr(10) +
          		' Icon: ' + txtIcon.Text + chr(10) +
          		' SVG: ' + SVG + chr(10) +
          		' Width: ' + txtWidth.Text + chr(10) +
          		' Height: ' + txtHeight.Text + chr(10) +
          		' X: ' + txtX.Text + chr(10) +
          		' Y: ' + txtY.Text + chr(10) +
          		'end';

  // Neue Verknüpfung Anlegen
  try
  Title:=stringreplace(txtTitle.Text,' ','',[rfReplaceAll]);
  AssignFile(Lnk, iDeskDir+'/'+Title+'.lnk'); // Datei bestimmen
  ReWrite(Lnk);
	Writeln(Lnk, iDeskLnk); // Schreiben
	Closefile(Lnk); // Datei Schließen

  // Meldung
  MessageDlg('',Meldung.MSG1,mtInformation,[mbOK],0)
except
	// Bei einem Fehler
  MessageDlg('',Meldung.MSG2,mtError,[mbOk],0);
end;
end;

procedure TMain.MenuChange(Sender: TObject);
var
	LnkDir: String;
begin
if(TabSheet2.Visible=true) then // Wenn editieren
	begin
  	// Alte Einträge Löschen
    lsLnks.Clear;
  	// Vorhandene Verknüpfungen Auslesen
  	LnkDir:=HomeDir+'/.idesktop';
  	GetLnk(lsLnks,LnkDir,'*.lnk');
	end;

if(TabSheet3.Visible=true) then // Wenn About
	begin
  	// Version Setzen
    lblVersion.Caption:='Version: ' + Version;
  end;

if(TabSheet5.Visible=true) then // Wenn editieren
	begin
  	// Alte Einträge Löschen
    lsKDEIcons.Clear;
  	// Vorhandene KDE Verknüpfungen Auslesen
  	LnkDir:=HomeDir+'/Desktop';
  	GetLnk(lsKDEIcons,LnkDir,'*.desktop');
	end;

if(TabSheet4.Visible=true) then // Wenn Einstellungen
	begin
  	if(chkSDir.Checked=true) then
    	txtiDeskDir.Enabled:=false
    else
    	txtiDeskDir.Enabled:=True;
  end;

if(TabSheet5.Visible=true) then // Wenn Extras
	begin
		StatusBar.Caption:='';
    StatusBar.Position:=0;
  end;
end;

// Vorhandene Verknüpfungen Auslesen
procedure TMain.GetLnk(list: tlistbox;const Directory: string;
const FileMask: string = '*.*');

//Hilfsfunktion, um Schrgstriche hinzuzfgen, wenn ntig
function SlashSep(const Path, S: string): string;
  begin
    if AnsiLastChar(Path)^ <> '/' then  Result := Path + '/' + S
    else Result := Path + S;
  end;

var SearchRec: TSearchRec;
begin
  if FindFirst(SlashSep(Directory, FileMask), faAnyFile-faDirectory,
  SearchRec) = 0 then
  begin
    try
      repeat
      	// Anzeigen
        list.Items.Add(SearchRec.Name)
      until FindNext(SearchRec) <> 0;
    finally
      SysUtils.FindClose(SearchRec);
    end;
  end;
end;

procedure TMain.lsLnksClick(Sender: TObject);
var
	iDeskLnk: String;
  TempFile: Textfile;
  Line: String;

  i: Integer;
begin
// Ausgewählte Datei Laden
iDeskLnk:=HomeDir+'/.idesktop/'+lsLnks.Items.Strings[lsLnks.ItemIndex];

// Alte Daten Löschen
txtTitle.Text:='';
lsCommandsE.Clear;
txtIconE.Text:='';
chkSVG.Enabled:=false;
txtWidthE.Text:='';
txtHeightE.Text:='';
txtXE.Text:='';
txtYE.Text:='';

AssignFile(TempFile,iDeskLnk);
Reset(TempFile);
  Try
    While Not EOF(TempFile) do // Bis das Ende erreicht ist
      begin
      	Readln(TempFile,Line); // Zeile Einlesen
        // Caption
        If Pos('caption',lowercase(Line))<>0 then
          txtTitleE.Text:=Copy(Line,pos('caption:',lowercase(Line))+9,length(Line));

        // Commands
        If Pos('command',lowercase(Line))<>0 then
        	if(pos('command[0]',lowercase(Line))<>0) then
            begin
        			for i:=0 to 9 do
          			begin
          				if(pos('command['+inttostr(i)+']',lowercase(Line))<>0) then
                		//lsCommandsE.Items.Add(Copy(Line,pos('command['+inttostr(i)+']:',lowercase(Line))+11,length(Line)));
            		end;
            end
          else
          	begin
            	lsCommandsE.Items.Add(Copy(Line,pos('command:',lowercase(Line))+9,length(Line)));
          	end;


        // Icon
        If Pos('icon',lowercase(Line))<>0 then
          txtIconE.Text:=Copy(Line,pos('icon:',lowercase(Line))+6,length(Line));

        // SVG
        If Pos('svg',lowercase(Line))<>0 then
          chkSVG.Checked:=strtoBool(Copy(Line,pos('svg:',lowercase(Line))+5,length(Line)));

        // Width
        If Pos('width',lowercase(Line))<>0 then
          txtWidthE.Text:=Copy(Line,pos('width:',lowercase(Line))+7,length(Line));

        // Height
        If Pos('height',lowercase(Line))<>0 then
          txtHeightE.Text:=Copy(Line,pos('height:',lowercase(Line))+7,length(Line));

        // X
        If Pos('x',lowercase(Line))<>0 then
          txtXE.Text:=Copy(Line,pos('x:',lowercase(Line))+3,length(Line));

        // Y
        If Pos('y',lowercase(Line))<>0 then
          txtYE.Text:=Copy(Line,pos('y:',lowercase(Line))+3,length(Line));
      end;
  Finally
    CloseFile(TempFile);
  end;
end;

procedure TMain.popDelClick(Sender: TObject);
var
	Index: Integer;
  LnkDir: String;
begin
// Nachfragen
if(MessageDlg('',Meldung.MSG3,mtconfirmation,[mbYes,mbNo],0)=mrYes) then
  // Link Verzeichnis
  LnkDir:=HomeDir+'/.idesktop';
	// Welcher Eintrag
  Index:=lsLnks.ItemIndex;
  // Löschen
  if(DeleteFile(LnkDir + '/' + lsLnks.Items.Strings[Index])=false) then
    begin
  		// Konnte nicht gelöscht werden
    	MessageDlg('',Meldung.MSG4,mtError,[mbOk],0);
    end
	else
  	begin
    	// Wurde gelöscht
    	MessageDlg('',Meldung.MSG5,mtInformation,[mbOk],0);
    end;

  // Liste Aktualisieren
  lsLnks.Clear; // Alte Daten Löschen
  // Vorhandene Verknüpfungen Auslesen
  GetLnk(lsLnks,LnkDir,'*.lnk');
end;

procedure TMain.cmdAbortClick(Sender: TObject);
begin
// Nachfragen
if(MessageDlg('',Meldung.MSG3,mtconfirmation,[mbYes,mbNo],0)=mrYes) then
  begin
		// Zurücksetzen
    CleanAdd();
  end;
end;

procedure TMain.txtWidthKeyPress(Sender: TObject; var Key: Char);
begin
// Nur Zahlen Zulassen
if not (key in [#8, #9, #48 .. #57]) then key:=#0;
end;

procedure TMain.txtHeightKeyPress(Sender: TObject; var Key: Char);
begin
// Nur Zahlen Zulassen
if not (key in [#8, #9, #48 .. #57]) then key:=#0;
end;

procedure TMain.txtXKeyPress(Sender: TObject; var Key: Char);
begin
// Nur Zahlen Zulassen
if not (key in [#8, #9, #48 .. #57]) then key:=#0;
end;

procedure TMain.txtYKeyPress(Sender: TObject; var Key: Char);
begin
// Nur Zahlen Zulassen
if not (key in [#8, #9, #48 .. #57]) then key:=#0;
end;

procedure TMain.txtWidthEKeyPress(Sender: TObject; var Key: Char);
begin
// Nur Zahlen Zulassen
if not (key in [#8, #9, #48 .. #57]) then key:=#0;
end;

procedure TMain.txtHeightEKeyPress(Sender: TObject; var Key: Char);
begin
// Nur Zahlen Zulassen
if not (key in [#8, #9, #48 .. #57]) then key:=#0;
end;

procedure TMain.txtXEKeyPress(Sender: TObject; var Key: Char);
begin
// Nur Zahlen Zulassen
if not (key in [#8, #9, #48 .. #57]) then key:=#0;
end;

procedure TMain.txtYEKeyPress(Sender: TObject; var Key: Char);
begin
// Nur Zahlen Zulassen
if not (key in [#8, #9, #48 .. #57]) then key:=#0;
end;

procedure TMain.lblGPLClick(Sender: TObject);
begin
// GPL Laden
if(gpl.LoadGPL=1)	then
	// GPL Anzeigen
	GPl.ShowModal;
end;

procedure TMain.FormCreate(Sender: TObject);
var
	sStart: String;
begin
// HomeDir Auslesen
HomeDir:=sysutils.GetEnvironmentVariable('HOME');

// Parameter Auswerten
if ParamCount>0 then begin
	// Standard Text
  sStart:='iDesk Menu Editor (alpha 0.2)'+ chr(10) + 'http://idme.berlios.de' + chr(10) + chr(10) +
  'Coded by Andre Hauke' + chr(10) + 'GFX by Stefan Schmidt' + chr(10);

	// Hilfe
	if ParamStr(1)='--help' then begin
  	writeln(sStart);
		writeln('usage: idme [--help|--version]');
    writeln('--help       show this information');
    writeln('--version    show version information');
    writeln('');
  	close();
    halt;
	end;

  // Version
  if ParamStr(1)='--version' then begin
  	writeln(sStart);
    writeln('iDesk Menu Editor, Version alpha 0.2, 31 January 2004');
    writeln('');
  	close();
    halt;
  end;
end;

Version:='Alpha 0.2'; // Version
gnugettext.TranslateProperties (self);
SetCap(); // Übersetzen
end;

// Übersetzen
procedure TMain.SetCap();
begin
// Neue Verknüpfung
TabSheet1.Caption:=_('Create Link');
// Titel
lblTitle.Caption:=_('Title:');
// Kommandos
lblCommands.Caption:=_('Commands:');
// Hinzufügen
cmdAdd.Caption:=_('Add');
// Entfernen
cmdDel.Caption:=_('Delete');
// Alle Löschen
cmdDelAll.Caption:=_('Delete All');
// Breite
lblWidth.Caption:=_('Width:');
// Höhe
lblHeight.Caption:=_('Height:');
// X
lblX.Caption:=_('X:');
// Y
lblY.Caption:=_('Y:');
// Anlegen
cmdCreate.Caption:=_('Create');
// Zurücksetzen
cmdAbort.Caption:=_('Cancel');

// Verknüpfung Editieren
TabSheet2.Caption:=_('Edit Link');
// Titel
lblTitleE.caption:=_('Title:');
// Kommandos
lblCommandsE.caption:=_('Commands:');
// Hinzufügen
cmdAddE.Caption:=_('Add');
// Editieren
cmdEditE.Caption:=_('Edit');
// Löschen
cmdDelE.Caption:=_('Delete');
// Breite
lblWidthE.Caption:=_('Width:');
// Höhe
lblHeightE.Caption:=_('Height:');
// X
lblXE.Caption:=_('X:');
// Y
lblYE.Caption:=_('Y:');
// Speichern
cmdSaveE.Caption:=_('Save');

// Einstellungen
TabSheet4.Caption:=_('Properties');
// Standard iDesktop Verzeichnis verwenden
chkSDir.Caption:=_('Use standard iDesk desktop dir');
// iDesktop Verzeichnis
lbliDeskDir.Caption:=_('iDesk dir:');
// iDesk Versions Check deaktivieren
chkiDeskVCheck.Caption:=_('Deactivate iDesk version check');
// Bug Log deaktivieren
chkBugLog.Caption:=_('Deactivate Bug Log');
// Beim Start auf Updates Prüfen
chkUpdateCheck.Caption:=_('Check for updates on startup');
// Info
fraInfo.Caption:=_('Info:');

// Extras
TabSheet5.Caption:=_('Extras');
// KDE Desktop Verknüpfungen Konvertieren
fraConvertKde.Caption:=_('Convert KDE Desktop links');
// Start
cmdConvertStart.Caption:=_('Start');

// About
TabSheet3.Caption:=_('About');
// Veröffentlicht unter der GPL
lblGPL.Caption:=_('Released under GPL');
// Programmiert von Andre Hauke
lblCopy.Caption:=_('Coded by') + ' Andre Hauke';
// GFX von Stefan Schmidt
lblGFX.Caption:=_('Graphics by') + ' Stefan Schmidt';

// Meldungen
// Verknüpfung wurde angelegt.
Meldung.MSG1:=_('Link successfully created.');
// Konnte Verknüpfung nicht erstellen!
Meldung.MSG2:=_('Couldn`t create link!');
// Sind Sie sich sicher?
Meldung.MSG3:=_('Are you sure?');
// Der Link konnte nicht gelöscht werden.
Meldung.MSG4:=_('Couldn`t delete link.');
// Link wurde gelöscht.
Meldung.MSG5:=_('Link succesfull deleted');
// Konnte Änderungen nicht Speichern!
Meldung.MSG6:=_('Couldn`t save changes!');
end;

procedure TMain.tmrInputCheckTimer(Sender: TObject);
begin
// Überprüfen ob alle relavanten Daten eingegeben wurden
if(txtTitle.Text='') or (lsCommands.Items.Count=0) or (txtIcon.Text='') or
(txtWidth.Text='') or (txtHeight.Text='') then
  cmdCreate.Enabled:=false // Erstellen verhindern
else
	cmdCreate.Enabled:=true; // Erstellen ermöglichen
end;

procedure TMain.cmdSaveEClick(Sender: TObject);
var
	LnkDir: String;
  Index: Integer;
  Lnk: Textfile;
  iDeskLnk: String;
  Title: String;
  i: Integer;

  Commands: String;
  SVG: String;
begin
// Nachfragen
if(MessageDlg('',Meldung.MSG3,mtConfirmation,[mbYes,mbNo],0)=mrYes) then
  LnkDir:=HomeDir+'/.idesktop';
	// Alte Datei Löschen
  // Link Verzeichnis
  LnkDir:=HomeDir+'/.idesktop';
	// Welcher Eintrag
  Index:=lsLnks.ItemIndex;

  // Löschen
  if(DeleteFile(LnkDir + '/' + lsLnks.Items.Strings[Index])=false) then
    begin
  		// Konnte nicht gelöscht werden
    	MessageDlg('',Meldung.MSG6,mtError,[mbOk],0);
      exit;
    end;

	// Speichern
  // SVG
	if(chkSVGE.Checked=true) then // Wenn ausgewählt
  	begin
			SVG:='true';
  	end
	else // Wenn nicht ausgewählt
		begin
  		SVG:='false';
  	end;

	// Kommandos
	if(lsCommandsE.Items.Count>1) or (lsCommandsE.Items.Count=0) then // Wenn mehr als 1 Eintrag
  	begin
			for i:=0 to lsCommandsE.Items.Count -1 do
  			begin
					Commands:=Commands + ' Command[' + inttostr(i) + ']: ' + lsCommandsE.Items.Strings[i];
        	if(lsCommandsE.Items.Count-1 <> i) then // Solange nicht letzes Item
        	 	Commands:=Commands + chr(10);
      	end;
  	end
	else
		begin
   		if(lsCommandsE.Items.Count<>0) then // Wenn nicht leer
    		Commands:=' Command: ' + lsCommandsE.Items.Text;
  	end;

		// Inhalt der Lnk Datei
		iDeskLnk:='table Icon' + chr(10) +
							'	Caption: ' + txtTitleE.Text + chr(10) +
          		Commands + chr(10) +
          		' Icon: ' + txtIconE.Text + chr(10) +
          		' SVG: ' + SVG + chr(10) +
          		' Width: ' + txtWidthE.Text + chr(10) +
          		' Height: ' + txtHeightE.Text + chr(10) +
          		' X: ' + txtXE.Text + chr(10) +
          		' Y: ' + txtYE.Text + chr(10) +
          		'end';

  // Neue Verknüpfung Anlegen
  try
  	Title:=stringreplace(txtTitleE.Text,' ','',[rfReplaceAll]);
  	AssignFile(Lnk, LnkDir+'/'+Title+'.lnk'); // Datei bestimmen
  	ReWrite(Lnk);
		Writeln(Lnk, iDeskLnk); // Schreiben
		Closefile(Lnk); // Datei Schließen

  	// Meldung
  	MessageDlg('',Meldung.MSG1,mtInformation,[mbOK],0)
	except
		// Bei einem Fehler
  	MessageDlg('',Meldung.MSG2,mtError,[mbOk],0);
	end;
  
  // Liste Aktualisieren
  lsLnks.Clear; // Alte Daten Löschen
  // Vorhandene Verknüpfungen Auslesen
  GetLnk(lsLnks,LnkDir,'*.lnk');
end;

procedure TMain.cmdIconEClick(Sender: TObject);
type
  TPNGSig = array[0..7] of Byte;
const
  ValidSig: TPNGSig = (137,80,78,71,13,10,26,10);
var
  Sig: TPNGSig;
  f: tFileStream;
  x: integer;
  sFile: String;
begin
// Icon Auswahl Anzeigen
OpenIcon.InitialDir:=HomeDir; // Home Verzeichnis

if OpenIcon.Execute then
	txtIconE.Text:=OpenIcon.FileName;

  if(pos('png',lowercase(OpenIcon.FileName))<>0) then // Wenn PNG
  	// Breite und Höhe ermitteln
    sFile:=OpenIcon.FileName;
    FillChar(Sig, SizeOf(Sig), #0);
  	f:=TFileStream.Create(sFile, fmOpenRead);
  		try
    		f.read(Sig[0], SizeOf(Sig));
    	for x := Low(Sig) to High(Sig) do
      	if Sig[x] <> ValidSig[x] then Exit;
    			f.Seek(18, 0);
    			txtWidthE.Text:=IntToStr(ReadMWord(f));
    			f.Seek(22, 0);
    			txtHeightE.Text:=IntToStr(ReadMWord(f));
  		finally
    		f.Free;
  		end;
end;

procedure TMain.tmrInputCheck2Timer(Sender: TObject);
begin
if(lsLnks.ItemIndex = -1) then
	begin
		// Wenn Nicht ausgewählt wurde
  	txtTitleE.Enabled:=false;
  	lsCommandsE.Enabled:=false;
  	cmdAddE.Enabled:=false;
  	cmdEditE.Enabled:=false;
  	cmdDelE.Enabled:=false;
  	txtIconE.Enabled:=false;
  	cmdIconE.Enabled:=false;
  	chkSVGE.Enabled:=false;
  	txtWidthE.Enabled:=false;
  	txtHeightE.Enabled:=false;
  	txtXE.Enabled:=false;
  	txtYE.Enabled:=false;
  	cmdSaveE.Enabled:=false;

    // Inhalt Löschen
    CleanEdit();
  end
else
	begin
  // Wenn etwas ausgewählt wurde
  	txtTitleE.Enabled:=true;
  	lsCommandsE.Enabled:=true;
  	cmdAddE.Enabled:=true;
  	cmdEditE.Enabled:=true;
  	cmdDelE.Enabled:=true;
  	txtIconE.Enabled:=true;
  	cmdIconE.Enabled:=true;
  	chkSVGE.Enabled:=true;
  	txtWidthE.Enabled:=true;
  	txtHeightE.Enabled:=true;
  	txtXE.Enabled:=true;
  	txtYE.Enabled:=true;
  	cmdSaveE.Enabled:=true;
  end;
end;

// Inhalt der einzelnen Felder löschen (Tab Anlegen)
procedure TMain.CleanAdd();
begin
		txtTitle.Text:='';
  	lsCommands.Clear;
  	txtIcon.Text:='';
  	chkSVG.Checked:=false;
  	txtWidth.Text:='';
  	txtHeight.Text:='';
  	txtX.Text:='';
  	txtY.Text:='';
end;

// Inhalt der einzelnen Felder löschen (Tab Editieren)
procedure TMain.CleanEdit();
begin
		txtTitleE.Text:='';
  	lsCommandsE.Clear;
  	txtIconE.Text:='';
  	chkSVGE.Checked:=false;
  	txtWidthE.Text:='';
  	txtHeightE.Text:='';
  	txtXE.Text:='';
  	txtYE.Text:='';
end;

procedure TMain.cmdEditEClick(Sender: TObject);
begin
// Wenn Daten vorhanden
if((lsCommandsE.Items.Count > 0) and (lsCommandsE.ItemIndex <> -1)) then
	// Editieren
  frmEditCommand.Index:=lsCommandsE.ItemIndex; // Index der Auswahl
	EditCommand.ShowModal;
end;

procedure TMain.cmdDelClick(Sender: TObject);
begin
// Wenn Einträge vorhanden und etwas ausgewählt
if((lsCommands.Items.Count > 0) and (lsCommands.ItemIndex <> -1)) then
	// Nachfragen
  if(MessageDlg('','Eintrag Entfernen?',mtConfirmation,[mbYes,mbNo],0) = mrYes) then
  	// Löschen
    lsCommands.Items.Delete(lsCommands.ItemIndex);
end;

procedure TMain.cmdDelAllClick(Sender: TObject);
begin
// Wenn Einträge vorhanden sind
if(lsCommands.Items.Count > 0) then
	// Nachfragen
  if(MessageDlg('','Alle Löschen?',mtConfirmation,[mbYes,mbNo],0) = mrYes) then
    // Alle Einträge entfernen
  	lsCommands.Items.Clear;
end;

procedure TMain.chkSDirClick(Sender: TObject);
begin
// Textbox Aktivieren oder Deaktivieren
if(chkSDir.checked=true) then
	txtiDeskDir.Enabled:=false
else
	txtiDeskDir.Enabled:=true;
end;

procedure TMain.lblGPLMouseEnter(Sender: TObject);
begin
lblGPL.Font.Color:=clBlue;
end;

procedure TMain.lblGPLMouseLeave(Sender: TObject);
begin
lblGPL.Font.Color:=clBlack;
end;

procedure TMain.cmdConvertStartClick(Sender: TObject);
var
	i: Integer;
begin
// Nachfragen
if(lsKDEIcons.SelCount>0) and (MessageDlg('Sollen die Ausgewählten Links konvertiert werden?',mtConfirmation,[mbYes,mbNo],0) = mrYes) then
	begin
		// Konvertierung Starten
    StatusBar.Position:=0;
    StatusBar.Max:=lsKDEIcons.SelCount;
    for i:=0 to lsKDEIcons.Items.Count -1 do
    	begin
      	if lsKDEIcons.Selected[i] = true then
      		begin
          	StatusBar.Caption:='Konvertiere ' + lsKDEIcons.Items.Strings[i];
      			ConvertKDELink(HomeDir+'/Desktop/'+lsKDEIcons.Items.Strings[i]);
            StatusBar.Position:=StatusBar.Position+1;
        		Application.ProcessMessages;
          end;
      	// Fertig
        StatusBar.Caption:='Konvertierung Abgeschlossen.';
      end;
  end;
end;

// Kde .desktop Link Konvertieren
procedure TMain.ConvertKDELink(Link: String);
var
	TempFile: Textfile;
  Line: String;
  iDeskLnk: String;
  Title: String;
begin
AssignFile(TempFile,Link);
Reset(TempFile);
// Datei Einlesen
  Try
    While Not EOF(TempFile) do // Bis das Ende erreicht ist
      begin
        // Auswerten
      	Readln(TempFile,Line); // Zeile Einlesen
        // Caption
        if lowercase(Functions.Left(Line,5)) = 'name=' then // Wenn vorhanden
           begin
           	rKde.Caption:=Functions.Mid(Line,pos('=',Line)+1,strlen(pchar(Line))-pos('=',Line));
           end;
        // Command
        if lowercase(Functions.Left(Line,5)) = 'exec=' then // Wenn vorhanden
           begin
           	rKde.Command:=Functions.Mid(Line,pos('=',Line)+1,strlen(pchar(Line))-pos('=',Line));
           end;
        // Icon
        if lowercase(Functions.Left(Line,5)) = 'icon=' then // Wenn vorhanden
           begin
           	rKde.Icon:=Functions.Mid(Line,pos('=',Line)+1,strlen(pchar(Line))-pos('=',Line));
           end;
        // X-KDE-Username (Falls Root)
        if lowercase(Functions.Left(Line,15)) = 'x-kde-username=' then // Wenn vorhanden
           begin
           	if lowercase(Functions.Mid(Line,pos('=',Line)+1,strlen(pchar(Line))-pos('=',Line))) = 'root' then
           		rKde.Command:='kdesu ' + rKde.Command;
           end;
			end;
  Finally
    CloseFile(TempFile);
  end;

// Lnk Datei Schreiben
Title:=rKde.Caption;
iDeskLnk:='table Icon' + chr(10) +
					'	Caption: ' + rKde.Caption + chr(10) +
          ' Command: ' + rKde.Command + chr(10) +
          ' Icon: ' + rKde.Icon + chr(10) +
          ' SVG: false' + chr(10) +
          ' X: 0' + chr(10) +
          ' Y: 0' + chr(10) +
          'end';
	try
		Title:=stringreplace(Title,' ','',[rfReplaceAll]);
  	AssignFile(TempFile, HomeDir+'/.idesktop/'+'/'+Title+'.lnk'); // Datei bestimmen
  	ReWrite(TempFile);
  	Writeln(TempFile, iDeskLnk); // Schreiben
  	Closefile(TempFile); // Datei Schließen
	except
		// Bei einem Fehler
  	MessageDlg('',Meldung.MSG2,mtError,[mbOk],0);
	end;
end;

// Alle Markieren
procedure TMain.AlleMakieren1Click(Sender: TObject);
var
	i: Integer;
begin
for i:=0 to lsKDEIcons.Items.Count -1 do
	begin
		lsKDEIcons.Selected[i]:=true;
	end;
end;

// Markierung Umkehren
procedure TMain.MarkierungUmkehren1Click(Sender: TObject);
var
	i: Integer;
begin
for i:=0 to lsKDEIcons.Items.Count -1 do
	begin
  	if lsKDEIcons.Selected[i]=true then
			lsKDEIcons.Selected[i]:=false
    else
    	lsKDEIcons.Selected[i]:=true;
	end;
end;

end.
