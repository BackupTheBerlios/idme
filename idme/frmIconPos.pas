unit frmIconPos;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls, QExtCtrls;

type
  TIconPos = class(TForm)
    imgIcon: TImage;
    lsDummy: TListBox;
    procedure imgIconMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
  private
    procedure LoadIcons();
  public
    IconPath: String;
    IconHeight, IconWidth: Integer;
  end;

var
  IconPos: TIconPos;
	MDown: Boolean;

implementation

uses frmMain;

{$R *.xfm}

procedure TIconPos.imgIconMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
	if MDown=false then
		MDown:=true
  else
  	MDown:=false;
end;

procedure TIconPos.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
if MDown=true then
begin
	imgIcon.Left:=X;
	imgIcon.Top:=Y;
end;
end;

procedure TIconPos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	// Position �bernehmen
  Main.txtX.Text:=inttostr(imgIcon.Left*2);
  Main.txtY.Text:=inttostr(imgIcon.Top*2);
end;

// Vorhandene Desktop Icons Laden und Anzeigen
procedure TIconPos.LoadIcons();
var
	X,Y: String;
  Icon: String;
  iDeskLnk: String;
  TempFile: Textfile;
  Line: String;
  i: Integer;
  Image: TImage;
begin
	// Ausgew�hlte Datei Laden
	iDeskLnk:=Main.HomeDir+'/.idesktop/';

  // Vorhandene Icons Laden
	Main.GetLnk(lsDummy,Main.HomeDir+'/.idesktop/','*.lnk');

  // Einzelne Icons Laden und positionieren
  for i:=0 to lsDummy.Items.Count -1 do
  	begin
			AssignFile(TempFile,iDeskLnk+lsDummy.Items.Strings[i]);
			Reset(TempFile);

  		Try
    		While Not EOF(TempFile) do // Bis das Ende erreicht ist
      		begin
      			Readln(TempFile,Line); // Zeile Einlesen
        		// Icon
        		If Pos('icon',lowercase(Line))<>0 then
          	Icon:=Copy(Line,pos('icon:',lowercase(Line))+6,length(Line));
        		// X
        		If Pos('x',lowercase(Line))<>0 then
          	X:=Copy(Line,pos('x:',lowercase(Line))+3,length(Line));
        		// Y
        		If Pos('y',lowercase(Line))<>0 then
          	Y:=Copy(Line,pos('y:',lowercase(Line))+3,length(Line));
      		end;
  		Finally
    		CloseFile(TempFile);
  		end;

      // Icon Laden und Anzeigen
      Image:=TImage.Create(IconPos);
      Image.Picture.LoadFromFile(Icon);
      Image.Left:=strtoint(X) div 2;
      Image.Top:=strtoint(Y) div 2;
      Image.Parent:=IconPos;
    end;
end;

procedure TIconPos.FormActivate(Sender: TObject);
begin
// Fenstergr��e = Screen Gr��e / 2
IconPos.Width:=(Screen.Width div 2);
IconPos.Height:=(Screen.Height div 2);

// Icon Laden
ShowMessage(IconPath);
imgIcon.Picture.LoadFromFile(IconPath);

// Icongr��e = Icongr��e / 2
//imgIcon.Width:=IconX div 2;
//imgIcon.Height:=IconY div 2;

// Icons Laden
LoadIcons;

// Icon nach Vorne Bringen
imgIcon.BringToFront;
end;

end.
