unit ShellProcess; 
 
 interface 
 
 uses 
 {$IFDEF MSWINDOWS} 
  Windows, 
 {$ENDIF} 
 {$IFDEF LINUX} 
  Libc, 
 {$ENDIF} 
  Classes, SysUtils; 
 
 type 
  EProcessError = class(Exception); 
 
  TOutputEvent = procedure(Sender: TObject; const AOutput: String) of object; 
 
  TShellProcess = class(TComponent) 
  private 
   FFileName: String; 
   FParams: String; 
 {$IFDEF MSWINDOWS} 
   FIOFile: THandle; 
 {$ENDIF} 
 {$IFDEF LINUX} 
   FIOFile: PIOFile; 
 {$ENDIF} 
   FOnOutput: TOutputEvent; 
  public 
   destructor Destroy; override; 
   function Execute(const AFileName: String = ''; const AParams: String = ''): Boolean; 
   procedure CloseProcess; 
  published 
   property FileName: String read FFileName write FFileName; 
   property Params: String read FParams write FParams; 
   property OnOutput: TOutputEvent read FOnOutput write FOnOutput; 
  end; 
 
 procedure Register; 
 
 implementation 
 
 uses 
  StrUtils; 
 
 {$IFDEF LINUX} 
 const 
  OUT_TO = '2>&1'; 
 {$ENDIF} 
 
 { TShellProcess } 
 
 procedure TShellProcess.CloseProcess; 
 begin 
 {$IFDEF MSWINDOWS} 
  if FIOFile <> 0 then 
  begin 
   TerminateProcess(FIOFile, 0); 
   CloseHandle(FIOFile); 
   FIOFile := 0; 
  end; 
 {$ENDIF} 
 {$IFDEF LINUX} 
  if Assigned(FIOFile) then 
  begin 
   pclose(FIOFile); 
   FIOFile := nil; 
  end; 
 {$ENDIF} 
 end; 
 
 destructor TShellProcess.Destroy; 
 begin 
  CloseProcess; 
  inherited; 
 end; 
 
 {$IFDEF MSWINDOWS} 
 function TShellProcess.Execute(const AFileName, AParams: String): Boolean; 
 var 
  com, str, txt: String; 
  PipeRead, PipeWrite: THandle; 
  ProcessInfo: TProcessInformation; 
  StartupInfo: TStartupInfo; 
  SecAttr: TSecurityAttributes; 
  rb, TotalBytes: Cardinal; 
  ps: Integer; 
 begin 
  Result := False; 
  if FIOFile <> 0 then 
   raise EProcessError.Create('A process is already running.'); 
 
  if AFileName <> '' then FFileName := AFileName; 
  if AParams <> '' then FParams := AParams; 
 
  FFileName := Trim(FFileName); 
  FParams := Trim(FParams); 
 
  if FFileName = '' then 
   raise EProcessError.Create('Property "FileName" is empty.'); 
 
  com := FFileName + ' ' + FParams; 
 
  SecAttr.nLength := SizeOf(TSecurityAttributes); 
  SecAttr.bInheritHandle := True; 
  SecAttr.lpSecurityDescriptor := nil; 
 
  if not CreatePipe(PipeRead, PipeWrite, @SecAttr, 0) then 
   RaiseLastOSError; 
 
  FillChar(StartupInfo, SizeOf(TStartupInfo), 0); 
  StartupInfo.cb := SizeOf(TStartupInfo); 
  StartupInfo.wShowWindow := SW_HIDE; 
  StartupInfo.hStdInput := PipeRead; 
  StartupInfo.hStdOutput := PipeWrite; 
  StartupInfo.hStdError := PipeWrite; // StdError auch auf StdOut 
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES; 
 
  if not CreateProcess(nil, PChar(com), @SecAttr, @SecAttr, True, CREATE_NO_WINDOW, nil, 
            nil, StartupInfo, ProcessInfo) then 
   Exit; // return False 
  try 
   CloseHandle(ProcessInfo.hThread); // wird nicht bentigt 
 
   repeat 
    Result := WaitForSingleObject(ProcessInfo.hProcess, 10) = WAIT_OBJECT_0; 
    TotalBytes := 0; 
    PeekNamedPipe(PipeRead, nil, 0, nil, @TotalBytes, nil); 
    if TotalBytes > 0 then 
    begin 
     rb := Length(txt); 
     SetLength(txt, rb + TotalBytes); 
     ReadFile(PipeRead, txt[rb + 1], TotalBytes, rb, nil); 
 
     ps := Pos(#10, txt); 
     while ps > 0 do 
     begin 
      str := copy(txt, 1, ps - 1); 
      if (str <> '') and (str[Length(str)] = #13) then 
       SetLength(str, Length(str) - 1); 
      if Assigned(FOnOutput) then FOnOutput(Self, str); 
      Delete(txt, 1, ps); 
      ps := Pos(#10, txt); 
     end; 
    end; 
   until (TotalBytes = 0) and (Result); 
 
  finally 
   CloseHandle(PipeRead); 
   CloseHandle(PipeWrite); 
 
   CloseHandle(ProcessInfo.hProcess); 
  end; 
 
  if txt <> '' then 
   if Assigned(FOnOutput) then FOnOutput(Self, txt); 
 end; 
 {$ENDIF} 
 {$IFDEF LINUX} 
 function TShellProcess.Execute(const AFileName, AParams: String): Boolean; 
 const 
  BUF_SIZE = 1000; 
 var 
  line: PChar; 
  com, str, txt: String; 
  rb: Integer; 
  ps: Integer; 
 begin 
  if Assigned(FIOFile) then 
   raise EProcessError.Create('A process is already running.'); 
 
  if AFileName <> '' then FFileName := AFileName; 
  if AParams <> '' then FParams := AParams; 
 
  FFileName := Trim(FFileName); 
  FParams := Trim(FParams); 
 
  if FFileName = '' then 
   raise EProcessError.Create('Property "FileName" is empty.'); 
 
  com := FFileName + ' ' + FParams; 
  if RightStr(com, Length(OUT_TO)) <> OUT_TO then com := com + ' ' + OUT_TO; 
 
  FIOFile := popen(PChar(com), 'r'); 
  if not Assigned(FIOFile) then 
   raise EProcessError.Create(String(strerror(errno))); 
 
  GetMem(line, BUF_SIZE); 
  try 
   while FEOF(FIOFile) = 0 do 
   begin 
    rb := fread(line, 1, BUF_SIZE, FIOFile); 
    SetLength(Txt, Length(txt) + rb); 
    MemCpy(@txt[Length(txt) - (rb - 1)], line, rb); 
 
    ps := Pos(#10, txt); 
    while ps > 0 do 
    begin 
     str := copy(txt, 1, ps - 1); 
     if (str <> '') and (str[Length(str)] = #13) then 
      SetLength(str, Length(str) - 1); 
     if Assigned(FOnOutput) then FOnOutput(Self, str); 
     Delete(txt, 1, ps); 
     ps := Pos(#10, txt); 
    end; 
   end; 
 
   if txt <> '' then 
    if Assigned(FOnOutput) then FOnOutput(Self, txt); 
 
   CloseProcess; 
   wait(nil); 
  finally 
   Freemem(line, BUF_SIZE); 
  end; 
 
  Result := True; 
 end; 
 {$ENDIF} 
 
 procedure Register; 
 begin 
  RegisterComponents('ShellProcess', [TShellProcess]); 
 end; 
 
 end.
