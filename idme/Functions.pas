unit Functions;

{
    !**************************************
    ! Name: Replace,InStr,Left,Right,LeftTri
    !     m,RightTrim,Reverse,Split,Replace,Mid Fu
    !     nctions
    ! Description:This is just like the name
    !     says, The Following Vb functions for Del
    !     phi all coded/translated by me:
    RightTrim
    LeftTrem
    InStr
    Mid
    Left
    Right
    Replace
    Split
    Reverse
    ! By: Tanner Ezell (aka Lord Nova Ice)
    !
    !This code is copyrighted and has    ! limited warranties.Please see http://w
    !     ww.Planet-Source-Code.com/vb/scripts/Sho
    !     wCode.asp?txtCodeId=382&lngWId=7    !for details.    !**************************************
}

interface

uses
SysUtils, Classes;

function RightTrim(const s:String):String;
function LeftTrim(const s:String):String;
function InStr(Start: integer; Source: string; SourceToFind: string): integer;
function Mid(Source: string; Start: integer; Length: integer): string;
function Left(Source: string; Length: integer): string;
function Right(Source: string; Lengths: integer): string;
function Replace(sData: String; sSubstring: String; sNewsubstring: string): String;
function Split(Source, Deli: string; StringList: TStringList): TStringList;
function Reverse(Line: string): string;

implementation


function Reverse(Line: string): string;
var
i: integer;
a: string;
begin
For i := 1 To Length(Line) do
	begin
    a := Right(Line, i);
    Result := Result + Left(a, 1);
  end;
end;


function Split(Source, Deli: string; StringList: TStringList): TStringList;
var
	EndOfCurrentString: byte;
begin
repeat
	EndOfCurrentString := Pos(Deli, Source);
	if EndOfCurrentString = 0 then
    StringList.add(Source)
  else
    StringList.add(Copy(Source, 1, EndOfCurrentString - 1));
    Source := Copy(Source, EndOfCurrentString + length(Deli), length(Source) - EndOfCurrentString);
    until EndOfCurrentString = 0;
  		result := StringList;
end;


function Replace(sData: String; sSubstring: String; sNewsubstring: string): String;
var
	i: integer;
	lSub: Longint;
	lData: Longint;
begin
i := 1;
lSub := Length(sSubstring);
lData := Length(sData);
repeat
	begin
    i := InStr(i, sData, sSubstring);
    If i = 0 Then
    	begin
    	sNewSubString := sData;
    	Exit
    	end
    Else
    	sData := Copy(sData, 1, i - 1) + sNewsubstring + Copy(sData, i + lSub, lData);
    	i := i + lSub;
    End;

    Until i > lData;
    	Replace := sData;
end;


function Left(Source: string; Length: integer): string;
begin
	Result := copy(Source,1,Length);
end;

function Right(Source: string; Lengths: integer): string;
begin
	Result := copy(source,Length(Source) - Lengths,Lengths);
end;

function Mid(Source: string; Start: integer; Length: integer): string;
begin
	Result := copy(Source,Start,Length);
end;

function InStr(Start: integer; Source: string; SourceToFind: string): integer;
begin
	Result := pos(SourceToFind,copy(Source,Start,Length(Source) - (Start - 1)));
end;

function RightTrim(const s:String):String;
var
	i:integer;
begin
i:=length(s);
while (i>0) and (s[i]<=#32) do
	Dec(i);
  result:=Copy(s,1,i);
end;

function LeftTrim(const s:String):String;
var
	i, L:integer;
begin
L:=length(s);
i:=1;
while (i<=L) and (s[i]<=#32) do
	Inc(i);
	result:=Copy(s,i, MaxInt);
end;

end.
 