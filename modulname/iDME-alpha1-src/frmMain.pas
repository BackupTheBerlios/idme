unit frmMain;

(*
#####################################################
#            iDME - iDesk Menu Editor               #
#             Written by Andre Hauke                #
#                                                   #
#                Version Alpha 0.1                  #
#                                                   #
#          webmaster@gamersunderground.de           #
#          http://www.gamersunderground.de          #
#####################################################
*)

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls, QComCtrls, QButtons, QMenus, QExtCtrls;

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
    Image1: TImage;
    lblGFX: TLabel;
    lblHTTP1: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    chkUpdateCheck: TCheckBox;
    lbliDeskDir: TLabel;
    txtiDeskDir: TEdit;
    chkSDir: TCheckBox;
    chkiDeskVCheck: TCheckBox;
    fraInfo: TGroupBox;
    mInfo: TMemo;
    chkBugLog: TCheckBox;
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
    procedure Label2Click(Sender: TObject);
  private
    procedure GetLnk(const Directory: string;
		const FileMask: string = '*.*');
  public
    { Public-Deklarationen }
  end;

var
  Main: TMain;

implementation

uses frmAddCommand,frmGPL;

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
OpenIcon.InitialDir:=sysutils.GetEnvironmentVariable('HOME'); // Home Verzeichnis

if OpenIcon.Execute then
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
  i: Integer;

  Commands: String;
  SVG: String;
begin
// iDesk Verzeichnis
iDeskDir:=sysutils.GetEnvironmentVariable('HOME')+'/.idesktop';

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
				Commands:=Commands + 'Command[' + inttostr(i) + ']: ' + lsCommands.Items.Strings[i] + chr(10);
  		end;
  end
else
	begin
   	if(lsCommands.Items.Count<>0) then // Wenn nicht leer
    	Commands:='Command: ' + lsCommands.Items.Text;
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
  AssignFile(Lnk, iDeskDir+'/'+txtTitle.Text+'.lnk'); // Datei bestimmen
  ReWrite(Lnk);
	Writeln(Lnk, iDeskLnk); // Schreiben
	Closefile(Lnk); // Datei Schließen

  // Meldung
  MessageDlg('','Verknüpfung zu ' + txtTitle.Text + ' wurde angelegt.',mtInformation,[mbOK],0)
except
	// Bei einem Fehler
  MessageDlg('','Konnte Verknüpfung nicht erstellen!',mtError,[mbOk],0);
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
  	LnkDir:=sysutils.GetEnvironmentVariable('HOME')+'/.idesktop';
  	GetLnk(LnkDir,'*.lnk');
	end;
end;

// Vorhandene Verknüpfungen Auslesen
procedure TMain.GetLnk(const Directory: string;
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
        lsLnks.Items.Add(SearchRec.Name)
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
iDeskLnk:=sysutils.GetEnvironmentVariable('HOME')+'/.idesktop/'+lsLnks.Items.Strings[lsLnks.ItemIndex];

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
if(MessageDlg('','Soll der Link gelöscht werden?',mtconfirmation,[mbYes,mbNo],0)=mrYes) then
  // Link Verzeichnis
  LnkDir:=sysutils.GetEnvironmentVariable('HOME') + '/.idesktop';
	// Welcher Eintrag
  Index:=lsLnks.ItemIndex;
  // Löschen
  if(DeleteFile(LnkDir + '/' + lsLnks.Items.Strings[Index])=false) then
    begin
  		// Konnte nicht gelöscht werden
    	MessageDlg('','Der Link konnte nicht gelöscht werden.',mtError,[mbOk],0);
    end
	else
  	begin
    	// Wurde gelöscht
    	MessageDlg('','Link wurde gelöscht.',mtInformation,[mbOk],0);
    end;

  // Liste Aktualisieren
  lsLnks.Clear; // Alte Daten Löschen
  // Vorhandene Verknüpfungen Auslesen
  GetLnk(LnkDir,'*.lnk');
end;

procedure TMain.cmdAbortClick(Sender: TObject);
begin
// Nachfragen
if(MessageDlg('','Wollen Sie wirklich alle Eingaben zurücksetzen?',mtconfirmation,[mbYes,mbNo],0)=mrYes) then
	txtTitle.Text:='';
  lsCommands.Clear;
  txtIcon.Text:='';
  chkSVG.Checked:=false;
  txtWidth.Text:='';
  txtHeight.Text:='';
  txtX.Text:='';
  txtY.Text:='';
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

procedure TMain.Label2Click(Sender: TObject);
begin
// GPL Laden
if(gpl.LoadGPL=1)	then
	// GPL Anzeigen
	GPl.ShowModal;
end;

end.
