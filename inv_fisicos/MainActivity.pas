unit MainActivity;
//Esta es la unidad principal, desde aqui se accede a las demas unidades, practicamente es la unidad de navegacion
//Tambien cuenta con algunos metodos, especialmente descargar articulos y animacion de subida y bajada de datos
//Aqui tambien se encuentran variables globales utiles en demas unidades y metodos de uso comun
interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListBox, FMX.Layouts, FMX.MultiView, FMX.ExtCtrls, FMX.Objects,
  FMX.Controls.Presentation, System.ImageList, FMX.ImgList, FMX.Ani, FMX.Effects,
  FMX.Filter.Effects, FGX.ProgressDialog, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.FMXUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.Client, Data.DB, FireDAC.Comp.DataSet,System.IOUtils,
  FMX.Media;

type
  TfMainActivity = class(TForm)
    Image2: TImage;
    Image4: TImage;
    Image1: TImage;
    Image5: TImage;
    Image6: TImage;
    Label2: TLabel;
    Label3: TLabel;
    FloatAnimation1: TFloatAnimation;
    BlurEffect2: TBlurEffect;
    BlurEffect3: TBlurEffect;
    BlurEffect4: TBlurEffect;
    BlurEffect5: TBlurEffect;
    Line1: TLine;
    ShadowEffect4: TShadowEffect;
    Layout1: TLayout;
    Image7: TImage;
    FloatAnimation2: TFloatAnimation;
    FDConnection1: TFDConnection;
    Iconos: TImageList;
    FDMemArticulos: TFDMemTable;
    FDMemTable1EXP_ART_NOMBRE: TStringField;
    FDMemTable1EXP_ART_ID: TStringField;
    FDMemTable1EXP_ART_CODIGO: TStringField;
    FDMemTable1EXP_ART_UNIDAD: TStringField;
    FDMemTable1EXP_LINEA_ART_ID: TStringField;
    FDMemTable1EXP_LINEA_ART_NOMBRE: TStringField;
    FDMemTable1EXP_ART_PRECIO: TStringField;
    FDMemArticulosEXP_ART_SEGUIMIENTO: TStringField;
    FDQueryInsert: TFDQuery;
    FDQueryAlmacen: TFDQuery;
    FDQueryBorrar: TFDQuery;
    FDQueryConfiguracion: TFDQuery;
    FDMemAlmacen: TFDMemTable;
    FDMemAlmacenALMACEN_ID: TStringField;
    FDMemAlmacenNOMBRE: TStringField;
    FDQueryBuscar: TFDQuery;
    Timer1: TTimer;
    Logo: TImage;
    TimerPresentacion: TTimer;
    Layout4: TLayout;
    Layout3: TLayout;
    Almacen: TLabel;
    LabelAlmacen: TLabel;
    Layout2: TLayout;
    labelUsuario: TLabel;
    LabelUser: TLabel;
    MediaPlayer1: TMediaPlayer;
    TimerConexion: TTimer;
    Image9: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    SpeedButton2: TImage;
    Layout5: TLayout;
    Rectangle1: TLayout;
    Image3: TImage;
    Rectangle4: TLayout;
    procedure Image5Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image6Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure Rectangle44MouseLeave(Sender: TObject);
    procedure Image7MouseLeave(Sender: TObject);
    procedure MuestraIconos;
    procedure AnimacionDescarga;
    procedure Borrar_Articulos;
    procedure Borrar_Almacenes;
    procedure AnimacionSubida;
    procedure FormCreate(Sender: TObject);
    procedure Descargar_Articulos;
    procedure FDConnection1AfterConnect(Sender: TObject);
    procedure FDConnection1BeforeConnect(Sender: TObject);
    procedure Descargar_Almacenes;
    procedure Borrar_Usuario;
    Procedure EnviarDetalleInventario;
    Procedure EnviarInventario;
    procedure Obtener_Usuario;
    procedure Contar_Articulos;
    procedure SpeedButton2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton14Click(Sender: TObject);
    procedure Chequeo;
    procedure TimerPresentacionTimer(Sender: TObject);
    procedure BtnEliminarClick(Sender: TObject);
    procedure Eliminar_Registros;
    procedure FormPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
    procedure ReproducirAudio(ResourceID: string);
    procedure Button2Click(Sender: TObject);
    procedure BuscarArchivoConexion;
    procedure TimerConexionTimer(Sender: TObject);
    procedure Image9Click(Sender: TObject);
    procedure Image10Click(Sender: TObject);
    procedure Image11Click(Sender: TObject);
    procedure Image12Click(Sender: TObject);
    procedure Image13Click(Sender: TObject);
    procedure FormTap(Sender: TObject; const Point: TPointF);

  private
   FActivityDialogThread: TThread;
    { Private declarations }
  public
  Hoy :TDateTime;
  USUARIO_NOMBRE:String;
  USUARIO_PASS:string;
  CANTIDAD_ARTICULOS:String;
  Timer:String;
  MOMENTO_PARA_ENVIAR:string;
  Ip:String;
  Puerto:String;
    { Public declarations }
  end;

var
  fMainActivity: TfMainActivity;

implementation

{$R *.fmx}

uses Presentacion, ClientModuleUnit1, Colectora, ClientClassesUnit1,
  ConfigCliente, Usuario, Androidapi.JNI.Toasts, FGX.Toasts.Android, FGX.Toasts, FGX.ProgressDialog.Types,
  Configuracion, EditarInventario, EnviarInventario, LecturaCamara;

//Crea la animacion de descarga que le advierte al usuario y bloquea la app mientras se descargan articulos y almacenes
procedure TfMainActivity.AnimacionDescarga;
begin
  if not fgActivityDialog.IsShown then
  begin
    FActivityDialogThread := TThread.CreateAnonymousThread(procedure
    begin
      try
        TThread.Synchronize(nil, procedure
        begin
          fgActivityDialog.Message := 'Por favor, espere';
          fgActivityDialog.Show;
        end);
        Sleep(1000);
        if TThread.CheckTerminated then
        Exit;

        TThread.Synchronize(nil, procedure
        begin
          fgActivityDialog.Message := 'Conectando con la base de datos';
        end);
        Sleep(1000);
        if TThread.CheckTerminated then
        Exit;

        TThread.Synchronize(nil, procedure
        begin
          fgActivityDialog.Message := 'Descargando información ';
        end);
        Sleep(1000);
        if TThread.CheckTerminated then
        Exit;

        TThread.Synchronize(nil, procedure
        begin
          fgActivityDialog.Message := 'Insertando información';
        end);
        Sleep(1000);
        if TThread.CheckTerminated then
        Exit;

        TThread.Synchronize(nil, procedure
        begin
          fgActivityDialog.Message := 'Finalizando';
        end);
        Sleep(500);

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



//Crea la animacion de subida que le advierte al usuario y bloquea la app mientras se suben los registros
procedure TfMainActivity.AnimacionSubida;
begin
  if not fgActivityDialog.IsShown then
  begin
    FActivityDialogThread := TThread.CreateAnonymousThread(procedure
    begin
      try
        TThread.Synchronize(nil, procedure
        begin
          fgActivityDialog.Title := 'Enviando Información';
          fgActivityDialog.Message := 'Por favor, espere';
          fgActivityDialog.Show;
        end);
        Sleep(1000);
        if TThread.CheckTerminated then
        Exit;

        TThread.Synchronize(nil, procedure
        begin
          fgActivityDialog.Message := 'Conectando con la base de datos';
        end);
        Sleep(1000);
        if TThread.CheckTerminated then
        Exit;

        TThread.Synchronize(nil, procedure
        begin
         fgActivityDialog.Message := 'Subiendo Inventario ';
        end);
        Sleep(1000);
        if TThread.CheckTerminated then
        Exit;

        TThread.Synchronize(nil, procedure
        begin
          fgActivityDialog.Message := 'Finalizando';
        end);
        Sleep(500);

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

//Elimina los almacenes e inmediatamente despues ejecuta la descarga de los nuevos
procedure TfMainActivity.Borrar_Almacenes;
begin
  try
    with FDQueryBorrar,SQL do
    begin
      Timer1.Enabled:=false;
      Active :=  False;
      Clear;
      Add('drop table exp_almacen');
      FDQueryBorrar.ExecSQL;
    end;
    FDConnection1.ExecSQL('CREATE TABLE IF NOT EXISTS EXP_ALMACEN (ALMACEN_ID INTEGER PRIMARY KEY, NOMBRE TEXT)');
    Descargar_Almacenes;
    except
    on E:exception do
    showmessage(e.Message);
  end;
end;
//Elimina los articulos e inmediatamente despues ejecuta la descarga de los nuevos
procedure TfMainActivity.Borrar_Articulos;
begin
  try
    with FDQueryBorrar,SQL do
    begin
      Timer1.Enabled:=false;
      Active :=  False;
      Clear;
      Add('drop table exp_articulos');
      FDQueryBorrar.ExecSQL;
    end;
    FDConnection1.ExecSQL('CREATE TABLE IF NOT EXISTS EXP_ARTICULOS (EXP_ART_ID INTEGER,EXP_ART_NOMBRE TEXT,EXP_ART_UNIDAD TEXT,EXP_ART_CODIGO TEXT,EXP_ART_PRECIO TEXT,EXP_LINEA_ART_ID INTEGER ,EXP_LINEA_ART_NOMBRE TEXT, EXP_ART_SEGUIMIENTO TEXT)');
    Descargar_Articulos;
    except
    on E:exception do
    showmessage(e.Message);
  end;
end;
//Elimina al usuario de la base de datos cuando este cierra sesion
procedure TfMainActivity.Borrar_Usuario;
begin
  try
    with FDQueryBorrar,SQL do
    begin
      Active :=  False;
      Clear;
      Add('drop table exp_usuario');
      FDQueryBorrar.ExecSQL;
    end;
    FDConnection1.ExecSQL('CREATE TABLE IF NOT EXISTS EXP_USUARIO(NOMBRE TEXT NOT NULL,PASS TEXT NOT NULL)');
    except
    on E:exception do
    showmessage(e.Message);
  end;
end;


//Elimina todos los registros
procedure TfMainActivity.BtnEliminarClick(Sender: TObject);
begin
  MessageDlg('¿Deseas eliminar todos los registros? ', System.UITypes.TMsgDlgType.mtInformation,
  [
  System.UITypes.TMsgDlgBtn.mbOK,
  System.UITypes.TMsgDlgBtn.mbNo
  ], 0,
  procedure(const AResult: System.UITypes.TModalResult)
  begin
    case AResult of
      mrOk:
      begin
        Eliminar_Registros;
        SpeedButton2.Visible:=false;
        fEditarInventario.ComboBox1.Clear;
        fEditarInventario.Obtener_Inventarios;
        fEditarInventario.layout1.Visible:=false;
        fEditarInventario.Label6.Text:=('');
        fEditarInventario.label5.Text:=('');
        fEditarInventario.Almacen_id:= ('');
      end;
      mrNo:
    end;
  end);
end;



procedure TfMainActivity.BuscarArchivoConexion;
begin
   try
    with fMainActivity.FDQueryConfiguracion,SQL do
    begin
      Active :=  False;
      Clear;
      Add('select IP_SERVIDOR,PUERTO_SERVIDOR from  EXP_CONFIGURACION');
      Close;
      Open;
      IP:=Fields[0].asstring;
      Puerto:=Fields[1].AsString;
    end;
    except
    on E:exception do
    showmessage(e.Message);
  end;
end;

procedure TfMainActivity.Button2Click(Sender: TObject);
begin

end;

//Verifica si el usuario ya inicio sesion
procedure TfMainActivity.Chequeo;
begin
  if CANTIDAD_ARTICULOS.Equals('') then Showmessage('Descargar artículos')
  else
  if USUARIO_NOMBRE.Equals('') then Showmessage('Iniciar sesión')
  else
  begin
    try
      with form4.FDQuery1,SQL do
      begin
        Form4.show ;
        Form4.Buscar_Inventario;
        Form4.Nuevo_Inventario;
        Form4.Buscar_Inventario;
      end;
      except
      on E:exception do
      showmessage('Selecciona un almacen');
    end;
  end;
end;
//Cuenta la cantidad de articulos para verificar si ya fueron descargados
procedure TfMainActivity.Contar_Articulos;
begin
  try
    with FDQueryBorrar,SQL do
    begin
      Active :=  False;
      Clear;
      Add('Select count(*) from EXP_ARTICULOS');
      Close;
      Open;
      CANTIDAD_ARTICULOS:=(Fields[0].asString);
    end;
    except
    on E:exception do
    showmessage(e.Message);
  end;
end;
//Descarga los almacenes
procedure TfMainActivity.Descargar_Almacenes;
begin
  with ClientModule1.ServerMethods2Client.Almacen do
  begin
    while not eof do
    begin
      try
        begin
          FDQueryAlmacen.ParamByName('ALMACEN_ID').AsInteger := Fields[0].asInteger;
          FDQueryAlmacen.ParamByName('NOMBRE').AsString := Fields[1].asString;
          FDQueryAlmacen.ExecSQL();
          Next;
        end;

        except
        on e: Exception do
        begin
          fgActivityDialog.Hide;
          ShowMessage(e.Message);
        end;
      end;
    end;
    //En esta seccion se puede dar un mensaje de Finalizacion de la descarga
    fgActivityDialog.Hide;
    fConfiguracion.ComboBox1.Clear;
    fConfiguracion.Obtener_Almacenes;
    fConfiguracion.COMBO_SELECCIONADO:=False;
  end;
end;
//Descarga los articulos
procedure TfMainActivity.Descargar_Articulos;
var
  Toast: TfgToast;
begin
  try
    begin
      Timer1.Enabled:=false;
      FDMemArticulos.Open;
      FDMemArticulos.Edit;
      FDMemArticulos.CopyDataSet(ClientModule1.ServerMethods2Client.Articulos);
      with FDMemArticulos do
      begin
        while not eof do
        begin
          try
            begin
              FDQueryInsert.ParamByName('EXP_ART_NOMBRE').AsString := Fields[0].asstring;
              FDQueryInsert.ParamByName('EXP_ART_ID').AsString := Fields[1].asString;
              FDQueryInsert.ParamByName('EXP_ART_CODIGO').AsString := Fields[2].asstring;
              FDQueryInsert.ParamByName('EXP_ART_UNIDAD').AsString := Fields[3].asstring;
              FDQueryInsert.ParamByName('EXP_LINEA_ART_ID').AsString := Fields[4].AsString;
              FDQueryInsert.ParamByName('EXP_LINEA_ART_NOMBRE').AsString := Fields[5].asstring;
              FDQueryInsert.ParamByName('EXP_ART_PRECIO').AsString := Fields[6].asstring;
              FDQueryInsert.ParamByName('EXP_ART_SEGUIMIENTO').AsString := Fields[7].asstring;
              FDQueryInsert.ExecSQL();
              Next;
            end;
            except
            on e: Exception do
            begin
              ShowMessage(e.Message);
              fgActivityDialog.Hide;
            end;
          end;
        end;
        //En esta seccion se puede dar un mensaje de Finalizacion de la descarga
        Toast := TfgToast.Create('Artículos descargados', TfgToastDuration(Long));
        Toast.Icon:=Logo.Bitmap;
        Toast.MessageColor := $FF000000;
        Toast.BackgroundColor :=  $FFFFFF ;
        Toast.Show;
        Toast.Free;
        Contar_Articulos;
        //borrar_almacenes;
      end;
      end;
      except
      on e: Exception do
      begin
        ShowMessage(e.Message);
        fgActivityDialog.Hide;
      end;
  end;
end;

procedure TfMainActivity.Eliminar_Registros;
var
  Toast: TfgToast;
begin
  try
    with FDQueryBorrar,SQL do
    begin
      Timer1.Enabled:=false;
      Active :=  False;
      Clear;
      Add('drop table exp_inventario_fisico');
      FDQueryBorrar.ExecSQL;
      Clear;
      Add('drop table exp_inventario_fisico_det');
      FDQueryBorrar.ExecSQL;
    end;
    FDConnection1.ExecSQL('CREATE TABLE IF NOT EXISTS EXP_INVENTARIO_FISICO(FOLIO_ID INTEGER,FECHA_CREACION TEXT,FECHA_HORA_CREACION TEXT,FECHA_MODIFICACION TEXT,ALMACEN INTEGER,ENVIADO TEXT, MOMENTO_DIA TEXT,ENVIADO_FIN TEXT,U_CAPTURA TEXT)');
    FDConnection1.ExecSQL('CREATE TABLE IF NOT EXISTS EXP_INVENTARIO_FISICO_DET(ARTICULO_ID INTEGER NOT NULL,F_CAPTURA TEXT NOT NULL,U_CAPTURA TEXT,ARTICULO_CLAVE TEXT,SERIAL TEXT,LOTE TEXT,FOLIO INTEGER NOT NULL,CANTIDAD TEXT,ALMACEN INTEGER,MOMENTO TEXT)');
    Toast := TfgToast.Create('Registros eliminados', TfgToastDuration(Long));
    Toast.Icon:=Logo.Bitmap;
    Toast.MessageColor := $FF000000;
    Toast.BackgroundColor :=  $FFFFFF ;
    Toast.Show;
    Toast.Free;
    except
    on E:exception do
    showmessage(e.Message);
  end;
end;
//Envia el detalle de inventario es decir donde estan todos los articulos insertados
procedure TfMainActivity.EnviarDetalleInventario;
begin
  try
    with FDQueryBuscar,SQL do
    begin
      Timer1.Enabled:=false;
      Active :=  False;
      Clear;
      Add('select ARTICULO_ID,F_CAPTURA,ARTICULO_CLAVE,U_CAPTURA,ALMACEN,FOLIO from EXP_INVENTARIO_FISICO_DET where U_CAPTURA ='+''''+USUARIO_NOMBRE+''''+' and Almacen='+fEditarInventario.Almacen_ID);
      Close;
      Open;
      while not eof do
      begin
        ClientModule1.ServerMethods2Client.Recibir_Inventario(Fields[0].asstring,Fields[1].asstring ,Fields[2].asstring,Fields[3].asstring,Fields[4].asstring,Fields[5].asstring);
        Next;
      end;
      EnviarInventario;
    end;
    except
    on E:exception do
    showmessage(e.Message);
  end;
end;
//Envia la informacion del inventario
procedure TfMainActivity.EnviarInventario;
var
  Toast: TfgToast;
  Fecha_creacion: String;
  Fecha_envio:string;
begin
  try
    with FDQueryBuscar,SQL do
    begin
      Hoy := Now;
      Active :=  False;
      Clear;
      Add('select FECHA_HORA_CREACION,FOLIO_ID from EXP_INVENTARIO_FISICO where  Almacen='+fEditarInventario.Almacen_ID+' and U_CAPTURA ='+''''+USUARIO_NOMBRE+'''');
      Close;
      Open;
      Fecha_creacion:=Fields[0].AsString;
      Fecha_envio:=( (formatdatetime('d.m.y', Hoy))+(FormatDATETime(' hh:mm', Hoy)) );
      while not eof do
      begin
        ClientModule1.ServerMethods2Client.Recibir_Inventario_2(Fields[1].AsString,fEditarInventario.Almacen_ID,fEditarInventario.ComboBox1.Selected.Text,Fecha_creacion,Fecha_envio,fEditarInventario.Vacio,MOMENTO_PARA_ENVIAR);
        Next;
      end;
      fEditarInventario.Marcar_Como_Enviado;
    end;
    Toast := TfgToast.Create('Inventario enviado', TfgToastDuration(Long));
    Toast.Icon:=Logo.Bitmap;
    Toast.MessageColor := $FF000000;
    Toast.BackgroundColor :=  $FFFFFF ;
    Toast.Show;
    Toast.Free;
    except
    on E:exception do
    showmessage(e.Message);
  end;
end;

//Crea las tablas en la base de datos
procedure TfMainActivity.FDConnection1AfterConnect(Sender: TObject);
begin
  FDConnection1.ExecSQL('CREATE TABLE IF NOT EXISTS EXP_ARTICULOS (EXP_ART_ID INTEGER,EXP_ART_NOMBRE TEXT,EXP_ART_UNIDAD TEXT,EXP_ART_CODIGO TEXT,EXP_ART_PRECIO TEXT,EXP_LINEA_ART_ID INTEGER ,EXP_LINEA_ART_NOMBRE TEXT,EXP_ART_SEGUIMIENTO TEXT )');
  FDConnection1.ExecSQL('CREATE TABLE IF NOT EXISTS EXP_ALMACEN(ALMACEN_ID INTEGER NOT NULL, NOMBRE TEXT,ID_SELECCIONADO INTEGER NOT NULL PRIMARY KEY)');
  FDConnection1.ExecSQL('CREATE TABLE IF NOT EXISTS EXP_CONFIGURACION(IP_SERVIDOR TEXT NOT NULL,PUERTO_SERVIDOR TEXT NOT NULL)'); //DEFAULT ''192.168.2.107''
  FDConnection1.ExecSQL('CREATE TABLE IF NOT EXISTS EXP_USUARIO(NOMBRE TEXT NOT NULL,PASS TEXT NOT NULL)');
  FDConnection1.ExecSQL('CREATE TABLE IF NOT EXISTS EXP_CONFIGURACION_DET(ALMACEN_ELEGIDO_ID INTEGER NOT NULL,ALMACEN_ELEGIDO TEXT NOT NULL,ULTIMO_ID INTEGER NOT NULL,CAMARA INTEGER NOT NULL)');
  FDConnection1.ExecSQL('CREATE TABLE IF NOT EXISTS EXP_INVENTARIO_FISICO_DET(ARTICULO_ID INTEGER NOT NULL,F_CAPTURA TEXT NOT NULL,U_CAPTURA TEXT,ARTICULO_CLAVE TEXT,SERIAL TEXT,LOTE TEXT,FOLIO INTEGER NOT NULL,CANTIDAD TEXT,ALMACEN INTEGER,MOMENTO TEXT)');
  FDConnection1.ExecSQL('CREATE TABLE IF NOT EXISTS EXP_INVENTARIO_FISICO(FOLIO_ID INTEGER,FECHA_CREACION TEXT,FECHA_HORA_CREACION TEXT,FECHA_MODIFICACION TEXT,ALMACEN INTEGER,ENVIADO TEXT, MOMENTO_DIA TEXT,ENVIADO_FIN TEXT,U_CAPTURA TEXT)');
end;
//Establece conexion con la base de datos elegida
procedure TfMainActivity.FDConnection1BeforeConnect(Sender: TObject);
begin
  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  FDConnection1.Params.Values['Database'] :=
  TPath.Combine(TPath.GetDocumentsPath, 'Colectora.s3db');
  {$ENDIF}
end;

procedure TfMainActivity.FormCreate(Sender: TObject);
begin
  Obtener_Usuario;
  Contar_Articulos;
  BuscarArchivoConexion;
end;
//Checa si el inventario ya fue enviado y solo en ese caso permite la creacion de uno nuevo mostrando el boton correspondiente
procedure TfMainActivity.FormPaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
  if fConfiguracion.ALMACEN_ELEGIDO_ID<>('0') then
  begin
    if fConfiguracion.ALMACEN_ELEGIDO_ID<>('') then
    begin
      fConfiguracion.Checar_Enviado;
      if fConfiguracion.ENVIADO.Equals('S') then
      begin
        fMainActivity.SpeedButton2.Visible:=True;
      end
      else
      begin
        fMainActivity.SpeedButton2.Visible:=false;
      end;
    end;
  end;


end;

procedure TfMainActivity.FormTap(Sender: TObject; const Point: TPointF);
begin
   Rectangle1.Visible:=false;
   Line1.Visible:=false;
   FloatAnimation1.Enabled:=false;
   FloatAnimation2.Enabled:=false;
   Layout1.Visible:=false;
   Rectangle4.Visible:=true;
   Image7.Visible:=True;
   Image3.Align:=TAlignLayout.Center;
   layout4.Align:=TAlignLayout.Top;
end;

procedure TfMainActivity.Image10Click(Sender: TObject);
begin
  MessageDlg('¿Desea descargar la información? ', System.UITypes.TMsgDlgType.mtInformation,
  [
  System.UITypes.TMsgDlgBtn.mbOK,
  System.UITypes.TMsgDlgBtn.mbNo
  ], 0,
  procedure(const AResult: System.UITypes.TModalResult)
  begin
    case AResult of
      mrOk:
      begin
        Rectangle1.Visible:=false;
        BlurEffect2.Enabled:=false;
        BlurEffect3.Enabled:=false;
        BlurEffect4.Enabled:=false;
        BlurEffect5.Enabled:=false;
        Line1.Visible:=false;
        FloatAnimation1.Enabled:=false;
        FloatAnimation2.Enabled:=false;
        Layout1.Visible:=false;
        Rectangle4.Visible:=true;
        Image3.Align:=TAlignLayout.Center;
        layout4.Align:=TAlignLayout.Top;
        //Inicia el proceso
        AnimacionDescarga;
        Timer:='BajarArticulos';
        Timer1.Enabled:=true;
      end;
      mrNo:
    end;
  end);

end;

procedure TfMainActivity.Image11Click(Sender: TObject);
begin
  if Cantidad_Articulos.Equals('0') then Showmessage('Descarga la informacion primero')
  else
  begin
    fEditarInventario:=TfEditarInventario.Create(nil);
    try
      fEditarInventario.Show;
      finally
      fEditarInventario.Show;
    end;
  end;
end;

procedure TfMainActivity.Image12Click(Sender: TObject);
begin
   MessageDlg('¿Deseas eliminar todos los registros? ', System.UITypes.TMsgDlgType.mtInformation,
  [
  System.UITypes.TMsgDlgBtn.mbOK,
  System.UITypes.TMsgDlgBtn.mbNo
  ], 0,
  procedure(const AResult: System.UITypes.TModalResult)
  begin
    case AResult of
      mrOk:
      begin
        Eliminar_Registros;
        SpeedButton2.Visible:=false;
        fEditarInventario.ComboBox1.Clear;
        fEditarInventario.Obtener_Inventarios;
        fEditarInventario.layout1.Visible:=false;
        fEditarInventario.Label6.Text:=('');
        fEditarInventario.label5.Text:=('');
        fEditarInventario.Almacen_id:= ('');
      end;
      mrNo:
    end;
  end);
end;

procedure TfMainActivity.Image13Click(Sender: TObject);
begin
   if Cantidad_Articulos.Equals('0') then Showmessage('Descarga la informacion primero')
  else
  begin
    MessageDlg('Se borraran los registros anteriores  y se iniciara nueva captura para este almacén. ¿Está seguro? ', System.UITypes.TMsgDlgType.mtInformation,
    [System.UITypes.TMsgDlgBtn.mbOK,System.UITypes.TMsgDlgBtn.mbNo], 0, procedure(const AResult: System.UITypes.TModalResult)
    begin
      case AResult of
        mrOk:
        begin
            fconfiguracion.Eliminar_Dia_Anterior;
            if fConfiguracion.CAMARA.Equals('1') then
           begin
             Mainform:=TMainform.Create(nil);
             try
               Mainform.Show;
             finally
               Mainform.Free;
             end;
           end
           else
            begin
              Form4:=TForm4.Create(nil);
             try
               Form4.Show;
             finally
               Form4.Free;
             end;
           end
        end;
        mrNo:
      end;
    end);
  end;
end;

procedure TfMainActivity.Image1Click(Sender: TObject);
begin
  if USUARIO_NOMBRE.Equals('') then Showmessage('Inicia sesión') else
  begin
    Rectangle1.Visible:=true;
    BlurEffect2.Enabled:=true;
    BlurEffect3.Enabled:=true;
    BlurEffect4.Enabled:=true;
    BlurEffect5.Enabled:=true;
    Line1.Visible:=true;
    FloatAnimation1.Enabled:=true;
    Image3.Align:=TAlignLayout.Top;
    layout4.Align:=TAlignLayout.Bottom;
  end;
end;

procedure TfMainActivity.Image2Click(Sender: TObject);
begin
  User:=TUser.Create(nil);
  try
    User.Show;
  finally
    User.Free;
  end;
end;

procedure TfMainActivity.Image4Click(Sender: TObject);
begin
  fConfiguracion.Show;
end;

procedure TfMainActivity.Image5Click(Sender: TObject);
begin
   Rectangle1.Visible:=false;
end;


procedure TfMainActivity.Image6Click(Sender: TObject);
begin
   Rectangle1.Visible:=false;
end;

procedure TfMainActivity.Image7MouseLeave(Sender: TObject);
begin
  MuestraIconos;
end;

procedure TfMainActivity.Image9Click(Sender: TObject);
begin
  if Cantidad_Articulos.Equals('0') then Showmessage('Descarga la informacion primero')
  else
  begin
    if  fConfiguracion.ALMACEN_ELEGIDO_ID<>('0')  then
    BEGIN
      if  fConfiguracion.ALMACEN_ELEGIDO_ID<>('')  then
      begin
        fConfiguracion.Buscar_Inventario;
        fConfiguracion.Checar_Enviado;
        if fConfiguracion.CAMARA.Equals('1') then
        begin
           Mainform:=TMainform.Create(nil);
           try
             Mainform.Show;
           finally
             Mainform.Free;
           end;
        end
        else
         begin
            Form4:=TForm4.Create(nil);
           try
             Form4.Show;
           finally
             Form4.Free;
           end;
        end
      end
      else
      begin
        ShowMessage('Por favor selecciona un almacen')
      end;
    END
    else
    begin
      ShowMessage('Por favor selecciona un almacen')
    end;
    fMainActivity.Obtener_Usuario;
    FMainActivity.labelUser.Text:= (FMainActivity.USUARIO_NOMBRE);
    fConfiguracion.BuscarAlmacenElegido;
    FMainActivity.labelAlmacen.Text:= (fConfiguracion.ALMACEN_ELEGIDO);
    fConfiguracion.Buscar_Inventario;
  end;
end;

procedure TfMainActivity.MuestraIconos;
begin
   Image7.Visible:=false;
   Layout1.Visible:=true;
   FloatAnimation2.Enabled:=true;
end;

procedure TfMainActivity.Obtener_Usuario;
begin
  try
    with FDQueryBuscar,SQL do
    begin
      Active :=  False;
      Clear;
      Add('select NOMBRE,Pass from EXP_USUARIO ');
      Close;
      Open;
      if Fields[0].asString<>('') then
      begin
        USUARIO_NOMBRE:=(Fields[0].asString);
        USUARIO_PASS:=(Fields[1].asString);
      end;
    end;

    except
    on E:exception do
    showmessage(e.Message);
  end;
end;

procedure TfMainActivity.Rectangle44MouseLeave(Sender: TObject);
begin
 MuestraIconos;
end;

procedure TfMainActivity.ReproducirAudio(ResourceID: string);
var
  ResStream: TResourceStream;
  TmpFile: string;
begin
  ResStream := TResourceStream.Create(HInstance, ResourceID, RT_RCDATA);
  try
    TmpFile := TPath.Combine(TPath.GetDocumentsPath, 'beep_025sec.3gp');
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

procedure TfMainActivity.SpeedButton13Click(Sender: TObject);
begin
  MessageDlg('Vas a descargar almacenes y artículos, ¿Es correcto? ', System.UITypes.TMsgDlgType.mtInformation,
  [
  System.UITypes.TMsgDlgBtn.mbOK,
  System.UITypes.TMsgDlgBtn.mbNo
  ], 0,
  procedure(const AResult: System.UITypes.TModalResult)
  begin
    case AResult of
      mrOk:
      begin
        AnimacionDescarga;
        Timer:='Bajar';
        Timer1.Enabled:=true;
      end;
      mrNo:
    end;
  end);

end;

procedure TfMainActivity.SpeedButton14Click(Sender: TObject);
begin
  fEnviarInventario.Show;
end;

procedure TfMainActivity.SpeedButton1Click(Sender: TObject);
begin
  if Cantidad_Articulos.Equals('0') then Showmessage('Descarga la informacion primero')
  else
  begin
    if  fConfiguracion.ALMACEN_ELEGIDO_ID<>('0')  then
    BEGIN
      if  fConfiguracion.ALMACEN_ELEGIDO_ID<>('')  then
      begin
        fConfiguracion.Buscar_Inventario;
        fConfiguracion.Checar_Enviado;
        if fConfiguracion.CAMARA.Equals('1') then
        begin
           Mainform:=TMainform.Create(nil);
           try
             Mainform.Show;
           finally
             Mainform.Free;
           end;
        end
        else
         begin
            Form4:=TForm4.Create(nil);
           try
             Form4.Show;
           finally
             Form4.Free;
           end;
        end
      end
      else
      begin
        ShowMessage('Por favor selecciona un almacen')
      end;
    END
    else
    begin
      ShowMessage('Por favor selecciona un almacen')
    end;
    fMainActivity.Obtener_Usuario;
    FMainActivity.labelUser.Text:= (FMainActivity.USUARIO_NOMBRE);
    fConfiguracion.BuscarAlmacenElegido;
    FMainActivity.labelAlmacen.Text:= (fConfiguracion.ALMACEN_ELEGIDO);
    fConfiguracion.Buscar_Inventario;
  end;
end;

procedure TfMainActivity.SpeedButton2Click(Sender: TObject);
begin
  if Cantidad_Articulos.Equals('0') then Showmessage('Descarga la informacion primero')
  else
  begin
    MessageDlg('Se borraran los registros anteriores  y se iniciara nueva captura para este almacén. ¿Está seguro? ', System.UITypes.TMsgDlgType.mtInformation,
    [System.UITypes.TMsgDlgBtn.mbOK,System.UITypes.TMsgDlgBtn.mbNo], 0, procedure(const AResult: System.UITypes.TModalResult)
    begin
      case AResult of
        mrOk:
        begin
            fconfiguracion.Eliminar_Dia_Anterior;
            if fConfiguracion.CAMARA.Equals('1') then
           begin
             Mainform:=TMainform.Create(nil);
             try
               Mainform.Show;
             finally
               Mainform.Free;
             end;
           end
           else
            begin
              Form4:=TForm4.Create(nil);
             try
               Form4.Show;
             finally
               Form4.Free;
             end;
           end
        end;
        mrNo:
      end;
    end);
  end;
  end;




procedure TfMainActivity.SpeedButton3Click(Sender: TObject);
begin
  if Cantidad_Articulos.Equals('0') then Showmessage('Descarga la informacion primero')
  else
  begin
    fEditarInventario:=TfEditarInventario.Create(nil);
    try
      fEditarInventario.Show;
      finally
      fEditarInventario.Show;
    end;
  end;
end;

procedure TfMainActivity.SpeedButton8Click(Sender: TObject);
begin
   FloatAnimation1.Enabled:=false;
end;

procedure TfMainActivity.Timer1Timer(Sender: TObject);
begin
  if Timer.Equals('Subir')
  then
  begin
    MOMENTO_PARA_ENVIAR:='I';
    EnviarDetalleInventario;
  end
  else if Timer.Equals('BajarAlmacenes') then
  begin
    Borrar_Almacenes;
  end
  else if Timer.Equals('BajarArticulos') then Borrar_articulos;
end;

procedure TfMainActivity.TimerConexionTimer(Sender: TObject);
begin
   ClientModule1.SQLConnection1.Params.Delete(1);
   ClientModule1.SQLConnection1.Params.Insert(1,'HostName='+fMainActivity.IP);
   ClientModule1.SQLConnection1.Params.Delete(0);
   ClientModule1.SQLConnection1.Params.Insert(0,'Port='+fMainActivity.Puerto);
   TimerConexion.enabled:=False;
end;

procedure TfMainActivity.TimerPresentacionTimer(Sender: TObject);
begin
  fPresentacion:=TfPresentacion.Create(nil);
  try
    fPresentacion.Show;
  finally
    fPresentacion.Free;
  end;
  fConfiguracion.Buscar_Inventario;
end;

end.
