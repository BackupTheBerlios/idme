unit frmIconPos;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls, QExtCtrls;

type
  TIconPos = class(TForm)
    imgIcon: TImage;
    procedure FormCreate(Sender: TObject);
    procedure imgIconMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  IconPos: TIconPos;
	MDown: Boolean;

implementation

uses frmMain;

{$R *.xfm}

procedure TIconPos.FormCreate(Sender: TObject);
begin
// Fenstergröße = Screen Größe / 2
IconPos.Width:=(Screen.Width div 2);
IconPos.Height:=(Screen.Height div 2);

// Icongröße = Icongröße / 2
imgIcon.Width:=48 div 2;
imgIcon.Height:=48 div 2;
end;

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
	// Position Übernehmen
  Main.txtX.Text:=inttostr(imgIcon.Left*2);
  Main.txtY.Text:=inttostr(imgIcon.Top*2);
end;

end.
