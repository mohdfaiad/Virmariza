
unit Funciones_Android;

interface
uses SysUtils,System.Types, System.UITypes,Classes, Math,FMX.VirtualKeyboard,FMX.Platform,FMX.Types,FMX.Media,System.IOUtils
, FGX.ProgressDialog,FMX.Graphics,FGX.Toasts.Android;
Const
  Dias:Array[0..7] of String=('Ninguno','Domingo','Lunes','Martes','Miércoles',
  'Jueves','Viernes','Sábado');
  Meses:Array[0..13] of String=('Ninguno','Enero','Febrero','Marzo','Abril',
  'Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre','Presupuesto');
  Mes:Array[0..12] of String=('Ninguno','Ene','Feb','Mar','Abr',
  'May','Jun','Jul','Ago','Sep','Oct','Nov','Dic');
  CRLF = #13#10;
Const
  msgAviso      = 'Aviso del sistema';

Const
  // Codigos de escape
  cpCutPaper      = #29+#86+#48;
  cpDoubleWidth   = #27+#33+#32;
  cpNormal        = #27+#33+#1;
  cpReverseFeed   = #27+#101+#2;
  cpOpenCashBox   = #27+#112+#0+#25+#100;
  //cpDoubleStrike = #27+'G'+#1;
  //cpDoubleOff    = #27+'G'+#0;
  cpDoubleStrike  = '';
  cpDoubleOff     = '';

Var
  dDias:Array[1..12] of Byte;
  fPrinter:TextFile;
  FootNote,Direccion:String;
  LStrings:TStrings;
  LocalAnchoTicket:Integer;
  LocalAnchoTicketHead:Integer;
  NTCode:Integer;
  FmtSettings:TFormatSettings;
  MediaPlayer1:TMediaPlayer;
  fgActivityDialog: TfgActivityDialog;
  FActivityDialogThread: TThread;
procedure BusquedaLibreLista(Lista:TStrings; Busca:String; WildCard:String);

{Elimina todos los espacios}
Function Trim(const Texto:String):String;

{Devuelve true si la cadena esta vacia o contiene solo espacios}
Function Empty(Texto:String):Boolean;

{Devuelve una cadena repetida  Strg('A',5)='AAAAA' }
Function Strg(C:String; Count:Integer):string;overload;

{Convierte una cadena a entero}
Function Str2Int(T:String):Longint;

Function Str2Float(T:String):Extended;
Function Float2Str(Valor: Double; Precision: Byte=2):String;

// Igual que Fecha2 pero para una fecha especifica
function Date2Str(vFecha:TDateTime):String;

Function Bisiesto:Boolean;
Function FillZero(What:Integer):String; inline;
// Regresa una cantidad expresada en texto (1,500 -> Un Mil Quinientos Pesos)
// Este si jala
function Num2Letra(Numero: Extended; cGenero: Char='M'): String;

function CompareFloat(v1,v2:Extended; Delta:Integer=1):ShortInt;
function NoStr(Source:String; LookStr:String):String;
//function RoundCurr(Value:Currency):Currency;
procedure AddListToSQL(Field:String; List,SQL:TStrings);
function GetDelimitedText(List:TStrings; Comma:String='"'; Delimiter:String=','):String;
procedure Center(Texto:String; W:Integer=40);
function Date2StrS(vFecha:TDateTime):string;
function Date2Strt(vFecha:TDateTime):string;
function CompararVersion(V1,V2:String):Integer;
procedure Split(const Delimiter: Char; Input: string; const Strings: TStrings);
{Convierte la cadena a mayusculas}
function UCase(Texto:String):String;
{Elimina los espacios a la izquierda}
Function LTrim(Texto:String):String;
{Elimina los espacios a la derecha}
Function RTrim(Texto:String):String;
function FormatCurr(Valor:Currency; Decimales:Byte=2; Signo:Boolean=false):String;
function ValidateRFC(const s: string):String;
function DaysPerMonth(AYear, AMonth: Integer): Integer;
{Oculta el teclado virtual (Android)}
procedure OcultarTeclado;
{Desactiva el teclado virtual (Android) Es decir que no se mostrara a menos que se enfoque otro edit}
procedure DesactivarTeclado;
{Fecha a String}
function StrFecha(fecha:TDateTime):String;
{Fecha y hora a String}
function StrFecha_Hora(fecha_Hora: TDateTime):String;
{Reproduce un audio}
procedure ReproducirAudio(ResourceID: string ;Nombre:String);
{Animacion de progreso, Util al descargar, subir, insertar archivos, bloquea la app con una animacion}
procedure AnimacionProgreso(Titulo: string ;msg1:String;Tiempo1:Integer;msg2:String;Tiempo2:Integer;msg3:String;Tiempo3:Integer;msg4:String;Tiempo4:Integer;msg5:String;Tiempo5:Integer);
{Muestra un mensaje en la parte inferior de la pantalla con una imagen}
procedure ToastImagen(Mensaje:string ;Duracion:Boolean;Imagen:TBitmap;colorFondo:TAlphaColor;colorTexto:TAlphaColor);
implementation

uses
  FGX.Toasts, Androidapi.JNI.Toasts;
(**********************************************************************)
{Recibe el mensaje, la duracion como boleano (true para largo, false para corto), la imagen que debe estar en el proyecto,y los colores en hexadecimal}
procedure ToastImagen(Mensaje:string ;Duracion:Boolean;Imagen:TBitmap;colorFondo:TAlphaColor;colorTexto:TAlphaColor);
var
  Toast: TfgToast;
begin
  if Duracion then  Toast := TfgToast.Create(Mensaje,TfgToastDuration(Long))
  else Toast := TfgToast.Create(Mensaje,TfgToastDuration(Short));
  Toast.Icon:=Imagen;
  Toast.MessageColor := ColorTexto;
  Toast.BackgroundColor := colorFondo;
  Toast.Show;
  Toast.Free;
end;

(**********************************************************************)
{El proceso requiere de 5 strings y 4 tiempos, el primer string es el titulo del mensaje y sera visible hasta que se termine
todo el proceso, los 4 restantes son cada uno un mensaje diferente seguidos de su tiempo de duracion en milisegundos,
Para ejecutar uno o mas procesos de fondo hasta ahora la unica forma que encontre fue que el proceso de fondo se ejecute
con un timer pasado x tiempo para que coincida con algun mensaje,Pero lo primero que se debe ejecutar es la animacion.}
procedure AnimacionProgreso(Titulo: string ;msg1:String;Tiempo1:Integer;msg2:String;Tiempo2:Integer;msg3:String;Tiempo3:Integer;msg4:String;Tiempo4:Integer;msg5:String;Tiempo5:Integer);
begin
   fgActivityDialog:=TfgActivityDialog.Create(nil);
  if not fgActivityDialog.IsShown then
  begin
    FActivityDialogThread := TThread.CreateAnonymousThread(procedure
    begin
      try
        TThread.Synchronize(nil, procedure
        begin
          fgActivityDialog.Title := Titulo;
          fgActivityDialog.Message := msg1;
          fgActivityDialog.Show;
        end);
        Sleep(Tiempo1);
        if TThread.CheckTerminated then
        Exit;

        TThread.Synchronize(nil, procedure
        begin
          fgActivityDialog.Message :=msg2;
        end);
        Sleep(Tiempo2);
        if TThread.CheckTerminated then
        Exit;

        TThread.Synchronize(nil, procedure
        begin
          fgActivityDialog.Message := msg3;
        end);
        Sleep(Tiempo3);
        if TThread.CheckTerminated then
        Exit;

        TThread.Synchronize(nil, procedure
        begin
          fgActivityDialog.Message := msg4;
        end);
        Sleep(Tiempo4);
        if TThread.CheckTerminated then
        Exit;

        TThread.Synchronize(nil, procedure
        begin
          fgActivityDialog.Message := msg5;
        end);
        Sleep(Tiempo5);

        if TThread.CheckTerminated then
        Exit;
        finally
        if not TThread.CheckTerminated then
        TThread.Synchronize(nil, procedure
        begin
          fgActivityDialog.Hide;
        end);
      end;
    end);
    FActivityDialogThread.FreeOnTerminate := False;
    FActivityDialogThread.Start;
  end;
end;
(**********************************************************************)
{El archivo se importa en Project/Resources and images/,si es audio debe ser formato 3gp y tipo RCDATA
Los parametros que se envian son el ID que se le asigno al archivo al insertarlo y su nombre completo incluyendo extension
ejemplo 'ReproducirAudio('Resource_1','beep_025sec.3gp');'}
procedure ReproducirAudio(ResourceID: string ;Nombre:String);
var
  ResStream: TResourceStream;
  TmpFile: string;
begin
  ResStream := TResourceStream.Create(HInstance, ResourceID, RT_RCDATA);
  try
    MediaPlayer1:=TMediaPlayer.Create(nil);
    TmpFile := TPath.Combine(TPath.GetDocumentsPath,Nombre);
    //TPath.Combine(TPath.GetDocumentsPath, 'filename')  { Internal }
    //TPath.Combine(TPath.GetSharedDocumentsPath, 'filename')  { External }
    ResStream.Position := 0;
    ResStream.SaveToFile(TmpFile);
    MediaPlayer1.FileName := TmpFile;
    MediaPlayer1.Play;
  finally
    ResStream.Free;
  end;
end;
 (**********************************************************************)
function StrFecha(fecha: TDateTime):String;
begin
  Result:=((formatdatetime('d.m.y', fecha)));
end;
(**********************************************************************)
function StrFecha_Hora(fecha_Hora:TDateTime):String;
begin
  Result:=((formatdatetime('d.m.y', fecha_Hora))+(FormatDATETime(' hh:mm', fecha_Hora)));
end;
(**********************************************************************)
procedure OcultarTeclado;
var
  FService: IFMXVirtualKeyboardService;
begin
  TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(FService));
  if (FService <> nil) then
  begin
    FService.HideVirtualKeyboard;
  end;
  end;
(**********************************************************************)
  procedure DesactivarTeclado;
var
  KeyboardService: IFMXVirtualKeyboardService;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(KeyboardService)) then
   KeyboardService.HideVirtualKeyboard;
   FMX.Types.VKAutoShowMode :=TVKAutoShowMode.Never;
end;
(**********************************************************************)
function FormatCurr(Valor:Currency; Decimales:Byte; Signo:Boolean):String;
Var
  F:String;
begin
  if Signo then
    F:='$#,##0'
  else
    F:='#,##0';
  if Decimales>0 then
    F:=F+'.'+Strg('0',Decimales);
  Result:=FormatFloat(F,Valor,FmtSettings);
end;

(*****************************************************************)
function LTrim(Texto:String):String;
begin
  Result:=Texto;
  while (Length(Result)>0) and (Result[1]=#32) do Delete(Result,1,1);
end;


(*****************************************************************)

function RTrim(Texto:String):String;
begin
  Result:=Texto;
  while (Length(Result)>0) and (Result[Length(Result)]=#32) do Delete(Result,Length(Result),1);
end;


(**********************************************************************)

function DaysPerMonth(AYear, AMonth: Integer): Integer;
const
  DaysInMonth: array[1..12] of Integer =
    (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
begin
  Result := DaysInMonth[AMonth];
  if (AMonth = 2) and IsLeapYear(AYear) then Inc(Result); { leap-year Feb is special }
end;

(**********************************************************************)


procedure Split(const Delimiter: Char; Input: string; const Strings: TStrings);
begin
  Assert(Assigned(Strings)) ;
  Strings.Clear;
  Strings.Delimiter := Delimiter;
  Strings.DelimitedText := Input;
end;

(**********************************************************************)

function CompararVersion(V1,V2:String):Integer;
Var
  S1,S2:String;
  L1,L2:TStrings;
  I: Integer;
begin
  L1:=TStringList.Create;
  L2:=TStringList.Create;
  Split('.',V1,L1);
  Split('.',V2,L2);
  S1:='';
  for I := 0 to L1.Count - 1 do
  begin
    L1[I]:=Strg('0',4-Length(L1[I]))+L1[I];
    S1:=S1+L1[I];
  end;
  S2:='';
  for I := 0 to L2.Count - 1 do
  begin
    L2[I]:=Strg('0',4-Length(L2[I]))+L2[I];
    S2:=S2+L2[I];
  end;
  if S1<S2 then
    Result:=-1
  else if S1>S2 then
    Result:=1
  else
    Result:=0;
end;

(**********************************************************************)

procedure BusquedaLibreLista(Lista:TStrings; Busca:String; WildCard:String);
Var
  I:Integer;
begin
  Busca:=UpperCase(Busca);
  Lista.Clear;
  I:=Pos(WildCard,Busca);

  while I>0 do
  begin
    Lista.Add(Copy(Busca,1,I-1));
    Delete(Busca,1,I);
    I:=Pos(WildCard,Busca);
  end;
  if Busca<>'' then
    Lista.Add(Busca);
end;

(**********************************************************************)

function Date2StrS(vFecha:TDateTime):string;
Var
  Year, Month, Day: Word;
begin
  DecodeDate(vFecha,Year,Month,Day);
  Result:=FillZero(Day)+'/'+Mes[Month]+'/'+Copy(IntToStr(Year),3,2);
end;

function Date2Strt(vFecha:TDateTime):string;
Var
  Year, Month, Day: Word;
begin
  DecodeDate(vFecha,Year,Month,Day);
  Result:=FillZero(Day)+'-'+Mes[Month]+'-'+Copy(IntToStr(Year),3,2);
end;

(**********************************************************************)

procedure Center(Texto:String; W:Integer);
begin
  writeln(fprinter,Strg(#32,W div 2 - Length(Texto) div 2),Texto);
end;

(*****************************************************************)


function GetDelimitedText(List:TStrings; Comma:String; Delimiter:String):String;
Var
  I:Integer;
begin
  Result:='';
  if List.Count=0 then
    Result:=Comma+Comma
  else
  begin
    For I:=0 to List.Count-1 do
      Result:=Result+Comma+List[I]+Comma+Delimiter;
    System.Delete(Result,Length(Result),1);
  end;
end;

(*****************************************************************)

procedure AddListToSQL(Field:String; List,SQL:TStrings);
Var
  Temp:String;
  I:Integer;
begin
  if List.Count>0 then
  begin
    Temp:=Field+' in (';
    with SQL do
    begin
      Add(' ('+Temp+List[0]+')');
      For I:=1 to List.Count-1 do
        Add(' or '+Temp+List[I]+')');
      Add(')');
    end;
  end;
end;


(*****************************************************************)

function NoStr(Source:String; LookStr:String):String;
begin
  Result:=Source;
  while Pos(LookStr,Result)>0 do Delete(Result,Pos(LookStr,Result),Length(LookStr));
end;

(*****************************************************************)

function CompareFloat(v1,v2:Extended; Delta:Integer):ShortInt;
//Var
//  R,I1,I2:Int64;
begin
  Result:=CompareValue(v1,v2,Delta/1000);
//  I1:=Trunc(v1*1000);
//  I2:=Trunc(v2*1000);
//  R:=I1-I2;
//  if abs(R)<=Delta then
//    Result:=0
//  else
//    if R>0 then
//      Result:=1
//    else
//      Result:=-1;
end;

(*****************************************************************)


Function FillZero(What:Integer):String;
begin
  Result:=IntToStr(What);
  If (What>=0) and (What<10) then Result:='0'+Result;
end;

(*****************************************************************)

function Date2Str(vFecha:TDateTime):String;
Var
  Year, Month, Day: Word;
begin
  DecodeDate(vFecha,Year,Month,Day);
  Date2Str:=FillZero(Day)+'/'+Mes[Month]+'/'+IntToStr(Year);
end;

(*****************************************************************)

Function Str2Int(T:String):Longint;
Var
  Error:Integer;
begin
  Val(T,Result,Error);
end;

(*****************************************************************)

Function Str2Float(T:String):Extended;
Var
  Error:Integer;
begin
  Val(T,Result,Error);
end;

(*****************************************************************)

function Trim(const Texto:String):String;
Var
  X:Integer;
begin
  Result:=Texto;
  X:=Pos(#32,Result);
  while X<>0 do
  begin
    Delete(Result,X,1);
    X:=Pos(#32,Result);
  end;
  X:=Pos(#13,Result);
  while X<>0 do
  begin
    Delete(Result,X,1);
    X:=Pos(#13,Result);
  end;
  X:=Pos(#10,Result);
  while X<>0 do
  begin
    Delete(Result,X,1);
    X:=Pos(#10,Result);
  end;
end;

(*****************************************************************)

Function Empty(Texto:String):Boolean;
Begin
  Empty:=Length(Trim(Texto))=0;
end;

(*****************************************************************)

Function Strg(C:String; Count:Integer):String;
Var
  A:Integer;
Begin
  Result:='';
  If Count>0 then
    For A:=1 to Count do
      Result:=Result+C;
end;

(*****************************************************************)

Function Bisiesto:Boolean;
Var
  Year,temp:Word;
Begin
  DecodeDate(Now,Year,Temp,Temp);
  If Year mod 4 = 0 then
    If Trunc(Year/100)=(Year/100) then
      Bisiesto:=Trunc(Year/400)=(Year/400)
    else
      Bisiesto:=True
  else
    Bisiesto:=False;
  // Result := (Year mod 4 = 0) and ((Year mod 100 <> 0) or (Year mod 400 = 0));
end;

(*****************************************************************)

Function Float2Str(Valor: Double; Precision: Byte=2):String;
begin
  If Precision<2 then Precision:=2;
  Result:=FloatToStrF(Valor, ffGeneral, Precision, 0);
end;

(*****************************************************************)
function UCase(Texto:String):String;
Var
  A:Integer;
Begin
  For A:=1 to Length(Texto) do
    Texto[A]:=UpCase(Texto[A]);
  UCase:=Texto;
end;

(*****************************************************************)
function ValidateRFC(const s: string):String;
var
I: Integer;
begin
Result:=Ucase(S);
for I:=Length(Result) downto 1 do
  if not (Result[I] in ['A'..'Z','0'..'9','&','@']) then Delete(Result, I, 1);
I:=Length(Result);
if (I<13) and (I>0) then // ver que no sea curp
  case Result[I] of
    'I': Result[I]:='1';
    'B': Result[I]:='8';
    'O': Result[I]:='0';
    'S': Result[I]:='5';
  end;
end;

(**************************************************************)

function Num2Letra(Numero: Extended; cGenero: Char): String;
Const
  Y         = 'y ';
  F         = 'as ';
  M         = 'os ';
  MIL       = 'mil ';
  MILLON    = 'millón ';
  MILLONES  = 'millones ';
  BILLON    = 'billón ';
  BILLONES  = 'billones ';

Var aGrupos:Array[1..5] of String;
    cDecimales, nNumero:String;
    cCentena, cDecena, cUnidad: Char;
    nGrupo:Integer;

  function if_(EStrToIntua:Boolean; S1,S2:String):String;
  begin
    If EStrToIntua then
      Result:=S1
    else
      Result:=S2;
  end;

  function aDecena(Pos1,Pos2:Byte):String;
  begin
    Result:='';
    if Pos2=1 then
      Case Pos1 of
        1: Result:='';
        2: Result:=if_(cUnidad = '0','diez ','');
        3: Result:=if_(cUnidad='0','veinte','veinti');
        4: Result:='treinta '+if_(cUnidad<>'0',Y,'');
        5: Result:='cuarenta '+if_( cUnidad<>'0',Y,'');
        6: Result:='cincuenta '+if_(cUnidad<>'0',Y,'');
        7: Result:='sesenta '+ if_(cUnidad<>'0',Y,'');
        8: Result:='setenta '+ if_(cUnidad<>'0',Y,'');
        9: Result:='ochenta '+ if_(cUnidad<>'0',Y,'');
       10: Result:='noventa '+ if_( cUnidad<>'0',Y,'');
      end
    else
      Case Pos2 of
        2: Result:='once ';
        3: Result:='doce ';
        4: Result:='trece ';
        5: Result:='catorce ';
        6: Result:='quince ';
        7: Result:='dieciseis ';
        8: Result:='diecisiete ';
        9: Result:='dieciocho ';
       10: Result:='diecinueve ';
      end;
  end;


  function aUnidad(Posicion:Byte):String;
  begin
    Result:='';
    Case Posicion of
      1: Result:=if_((Numero = 0) and (nGrupo = 1),'cero','');
      2:
        if cDecena = '1' then
          Result:=aDecena(2, StrToInt(cUnidad) + 1)
        else
          if (aGrupos[nGrupo] = '001') and ((nGrupo = 2) or (nGrupo = 4)) then
            Result:=''
          else
            if nGrupo > 2 then
              Result:='un '
            else
              if cGenero = 'F' then
                Result:='una '
              else
                Result:='un ';
      3:
        Result:=if_(cDecena='1', aDecena(2, StrToInt(cUnidad) + 1),'dos ');
      4:
        Result:=if_(cDecena='1',aDecena(2, StrToInt(cUnidad) + 1),'tres ');
      5:
        Result:=if_(cDecena='1',aDecena(2, StrToInt(cUnidad) + 1),'cuatro ');
      6:
        Result:=if_(cDecena='1',aDecena(2, StrToInt(cUnidad) + 1), 'cinco ');
      7:
        Result:=if_(cDecena='1',aDecena(2, StrToInt(cUnidad) + 1),'seis ');
      8:
        Result:=if_(cDecena='1',aDecena(2, StrToInt(cUnidad) + 1),'siete ');
      9:
        Result:=if_(cDecena='1',aDecena(2, StrToInt(cUnidad) + 1),'ocho ');
     10:
        Result:=if_(cDecena='1',aDecena(2, StrToInt( cUnidad ) + 1),'nueve ');
    end;
  end;

  function aCentenas(Posicion:Byte):String;
  begin
    Result:='';
    Case Posicion of
      2: Result:=if_(cDecena + cUnidad = '00','cien ','ciento ');
      3: Result:='doscient' + if_((nGrupo < 3) and (cGenero = 'F'), F, M );
      4: Result:='trescient' + if_((nGrupo < 3 ) and (cGenero = 'F'), F, M );
      5: Result:='cuatrocient'+if_((nGrupo < 3 ) and (cGenero = 'F'), F, M );
      6: Result:='quinient' + if_((nGrupo < 3 ) and (cGenero = 'F'), F, M );
      7: Result:='seiscient' + if_((nGrupo < 3 ) and (cGenero = 'F'), F, M );
      8: Result:='setecient' + if_((nGrupo < 3 ) and (cGenero = 'F'), F, M );
      9: Result:='ochocient' + if_((nGrupo < 3 ) and (cGenero = 'F'), F, M );
     10: Result:='novecient' + if_((nGrupo < 3 ) and (cGenero = 'F'), F, M );
    end;
  end;

  function aConector(Posicion:Byte):String;
  begin
    Result:='';
    case Posicion of
      2: Result:=if_(aGrupos[2] > '000', MIL , '');
      3: Result:=if_((aGrupos[3] > '000') or (aGrupos[4] > '000'), if_(aGrupos[3] = '001', MILLON,MILLONES), '');
      4: Result:=if_(aGrupos[4] > '000', MIL, '' );
      5: Result:=if_(aGrupos[5] > '000', if_(aGrupos[5] = '001', BILLON,BILLONES), '');
    end;
  end;

begin
  Str(Numero:0:2,nNumero);
  cDecimales:=Copy(nNumero,Length(nNumero)-1,2);
  Delete(nNumero,Length(nNumero)-2,3);
  nNumero:=Strg('0',15-Length(nNumero))+nNumero;

  cGenero:=UpCase(cGenero);

  for nGrupo:=1 to 5 do
    aGrupos[5-nGrupo+1] := Copy(nNumero, (nGrupo-1) * 3 + 1, 3);

  Result:='';
  for nGrupo:=5 Downto 1 do
  begin
    // Extraer cada una de las 3 cifras del Grupo en curso
    cUnidad :=aGrupos[nGrupo][3];
    cDecena :=aGrupos[nGrupo][2];
    cCentena:=aGrupos[nGrupo][1];

    // Componer la cifra en letra del Grupo en curso
    Result:=Result+aCentenas(StrToInt(cCentena)+1) +
                       aDecena(StrToInt(cDecena)+1,1)+
                       aUnidad(StrToInt(cUnidad)+1)+
                       aConector(nGrupo);
  end;
  Result:='Son: '+TrimRight(Result)+' peso';
  if Trunc(Numero)<>1 then Result:=Result+'s ' else Result:=Result+' ';
  Result:=Result+cDecimales+'/100'+' M.N.';
end;

(*****************************************************************)

initialization

  dDias[1]:=31;
  If Bisiesto then dDias[2]:=29 else dDias[2]:=28;
  dDias[3]:=31;
  dDias[4]:=30;
  dDias[5]:=31;
  dDias[6]:=30;
  dDias[7]:=31;
  dDias[8]:=31;
  dDias[9]:=30;
  dDias[10]:=31;
  dDias[11]:=30;
  dDias[12]:=31;

finalization

end.

