unit frmGPL;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls;

type
  TGPL = class(TForm)
    mGPL: TMemo;
  private
    { Private-Deklarationen }
  public
    function LoadGPL():Integer;
  end;

var
  GPL: TGPL;

implementation

{$R *.xfm}

function TGPL.LoadGPL():Integer;
var
	iDMEDir:String;
begin
// Arbeitsverzeichnis
iDMEDir:=ExtractFilePath(ParamStr(0));
try
	// GPL Laden
	mGPL.Lines.LoadFromFile(iDMEDir + '/GPL.txt');
except
	// Bei einem Fehler
  MessageDlg('','Konnte GPL nicht Laden!' + chr(10) +
  					'Besuchen Sie folgende Seite um die GPL einzusehen:' + chr(10) +
            'http://www.gnu.org/copyleft/gpl.html',mtInformation,[mbOk],0);
	LoadGPL:=0;
  exit;
end;
LoadGPL:=1;
end;

end.
