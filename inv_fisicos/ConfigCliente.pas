unit ConfigCliente;
//Aqui se ingresa y se guarda la conexion ip,
interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, ClientModuleUnit1, FMX.Objects, System.ImageList, FMX.ImgList, Datasnap.DSClientRest,
  System.IOutils, Data.DBXDataSnap, Data.DBXCommon, IPPeerClient, Data.DB,
  Data.SqlExpr, FMX.Layouts, FMX.VirtualKeyboard,FMX.Platform,System.Math;

type
  TfConfigCliente = class(TForm)
    iImagen: TImageList;
    Connection: TDSRestConnection;
    SQLConnection1: TSQLConnection;
    Brush1: TBrushObject;
    Image1: TImage;
    Image2: TImage;
    Layout2: TLayout;
    txtIpServidor: TEdit;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Direccion: TLabel;
    txtPuerto: TEdit;
    Layout1: TLayout;
    VertScrollBox1: TVertScrollBox;
    MainLayout1: TLayout;
    procedure btn1Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormFocusChanged(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
  private
    { Private declarations }
    conMensaje:Boolean;
    FKBBounds: TRectF;
    FNeedOffset: Boolean;
    procedure CalcContentBoundsProc(Sender: TObject;
                                    var ContentBounds: TRectF);
    procedure RestorePosition;
    procedure UpdateKBBounds;

  public
    { Public declarations }
   // Ip:String;
   // Puerto:String;
    function ProbarConexion:Boolean;
    procedure GuardarArchivoConexion;
    procedure ActualizarArchivoConexion;

  end;

var
  fConfigCliente: TfConfigCliente;

implementation

uses

   Usuario, MainActivity, FGX.Toasts, FGX.Toasts.Android;

{$R *.fmx}
{$R *.NmXhdpiPh.fmx ANDROID}
//Actualiza la base de datos con la nueva IP asignada
procedure TfConfigCliente.ActualizarArchivoConexion;
begin
  try
    with fMainActivity.FDQueryConfiguracion,SQL do
    begin
      Active :=  False;
      Clear;
      Add('Update EXP_CONFIGURACION SET IP_SERVIDOR='+''''+txtIpServidor.Text+''''+',PUERTO_SERVIDOR='+''''+txtPuerto.Text+'''');
      fMainActivity.FDQueryConfiguracion.ExecSQL;
    end;
    except
    on E:exception do
    showmessage(e.Message);
  end;
end;

procedure TfConfigCliente.btn1Click(Sender: TObject);
begin
  //Busca la IP En la bd
  fMainActivity.BuscarArchivoConexion;
  //Si no hay IP se inserta, si si la hay solo la actualiza
  if fMainActivity.IP<>('') then ActualizarArchivoConexion else GuardarArchivoConexion ;
  //if Puerto<>('') then ActualizarArchivoConexion else GuardarArchivoConexion ;
  //Vuelve a traer la nueva IP
  fMainActivity.BuscarArchivoConexion;
  //Elimina la anterior IP asignada en el componente de conexion
  ClientModule1.SQLConnection1.Params.Delete(1);
  ClientModule1.SQLConnection1.Params.Delete(0);
  //Establece la nueva IP
  ClientModule1.SQLConnection1.Params.Insert(1,'HostName='+fMainActivity.IP);
  ClientModule1.SQLConnection1.Params.Insert(0,'Port='+fMainActivity.Puerto);
  //Sale de la unidad configCliente
  if fMainActivity.USUARIO_NOMBRE.Equals('') then
  begin
     User:=TUser.Create(nil);
     try
       User.Show;
     finally
       User.Free;
     end;
  end
  else fMainActivity.Show;
end;

//Sale de la unidad
procedure TfConfigCliente.btn2Click(Sender: TObject);
begin
  begin
     User:=TUser.Create(nil);
     try
       User.Show;
     finally
       User.Free;
     end;
  end
end;
//Ejecuta el metodo que prueba la conexion con el server
procedure TfConfigCliente.btn3Click(Sender: TObject);
begin
  conMensaje := True;
  ProbarConexion;
end;

procedure TfConfigCliente.CalcContentBoundsProc(Sender: TObject;
  var ContentBounds: TRectF);
begin
  if FNeedOffset and (FKBBounds.Top > 0) then
  begin
    ContentBounds.Bottom := Max(ContentBounds.Bottom,
                                30 * ClientHeight - FKBBounds.Top);
  end;
end;

procedure TfConfigCliente.FormCreate(Sender: TObject);
begin
  txtIpservidor.Text:=fMainActivity.IP;
  VKAutoShowMode := TVKAutoShowMode.Always;
  VertScrollBox1.OnCalcContentBounds := CalcContentBoundsProc;
end;

procedure TfConfigCliente.FormFocusChanged(Sender: TObject);
begin
  UpdateKBBounds;
end;

procedure TfConfigCliente.FormShow(Sender: TObject);
begin
  txtIpservidor.Text:=fMainActivity.IP;
end;

procedure TfConfigCliente.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  FKBBounds.Create(0, 0, 0, 0);
  FNeedOffset := False;
  RestorePosition;
  Layout1.Align := TAlignLayout.Bottom;
end;

procedure TfConfigCliente.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  //Image1.Visible:=False;
  Layout1.Align := TAlignLayout.Top;
  FKBBounds := TRectF.Create(Bounds);
  FKBBounds.TopLeft := ScreenToClient(FKBBounds.TopLeft);
  FKBBounds.BottomRight := ScreenToClient(FKBBounds.BottomRight);
  UpdateKBBounds;
end;

//Inserta la ip en la bd
procedure TfConfigCliente.GuardarArchivoConexion;
BEGIN
  try
    with fMainActivity.FDQueryConfiguracion,SQL do
    begin
      Active :=  False;
      Clear;
      Add('Insert into EXP_CONFIGURACION (IP_SERVIDOR,PUERTO_SERVIDOR) VALUES ('+''''+txtIpServidor.Text+''''+','+''''+TxtPuerto.Text+''''+')');
      fMainActivity.FDQueryConfiguracion.ExecSQL;
    end;
    except
    on E:exception do
    showmessage(e.Message);
  end;
end;

procedure TfConfigCliente.Image3Click(Sender: TObject);
begin
  conMensaje := True;
  ProbarConexion;
end;

procedure TfConfigCliente.Image4Click(Sender: TObject);
var
  KeyboardService: IFMXVirtualKeyboardService;
begin
   if txtIpServidor.Text.Equals('') then ShowMessage('Ingrese la IP')
   else
   begin
      //Busca la IP En la bd
      fMainActivity.BuscarArchivoConexion;
      //Si no hay IP se inserta, si si la hay solo la actualiza
      if fMainActivity.IP<>('') then ActualizarArchivoConexion else GuardarArchivoConexion ;
      //if Puerto<>('') then ActualizarArchivoConexion else GuardarArchivoConexion ;
      //Vuelve a traer la nueva IP
      fMainActivity.BuscarArchivoConexion;
      //Elimina la anterior IP asignada en el componente de conexion
      ClientModule1.SQLConnection1.Params.Delete(1);
      ClientModule1.SQLConnection1.Params.Delete(0);
      //Establece la nueva IP
      ClientModule1.SQLConnection1.Params.Insert(1,'HostName='+fMainActivity.IP);
      ClientModule1.SQLConnection1.Params.Insert(0,'Port='+fMainActivity.Puerto);
      if TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(KeyboardService)) then KeyboardService.HideVirtualKeyboard;
      if fMainActivity.USUARIO_NOMBRE.Equals('') then
      begin
        User:=TUser.Create(nil);
        try
          User.Show;
        finally
          User.Free;
        end;
      end
      else fMainActivity.Show;
   end;


end;

procedure TfConfigCliente.Image5Click(Sender: TObject);
begin
  begin
     User:=TUser.Create(nil);
     try
       User.Show;
     finally
       User.Free;
     end;
  end
end;

//Prueba la conexion con el servidor, hay que recalcar que este metodo se conectara con el servidor hhtp
//No con el tcp/ip, pero al ejecutarse en conjunto y en la misma maquina la ip debe ser la misma
function TfConfigCliente.ProbarConexion: Boolean;
begin
  Result := False;
  if (txtIpServidor.Text)<>('') then
  begin
    Connection.Host := txtIpServidor.Text;
    try
      Connection.TestConnection([toNoLoginPrompt]);
      if conMensaje then
      begin
        ShowMessage('La conexión fue exitosa.');
        conMensaje := false;
      end;
      Result := True;
      except
      on E: Exception do
      begin
        ShowMessage('No se pudo establecer la conexión con el servidor.' + #13 + 'Verifique que el servidor este iniciado.');
        conMensaje := false;
      end;
    end;
  end
  else
  ShowMessage('Es necesario especificar una dirección IP para la conexión.');
end;


procedure TfConfigCliente.RestorePosition;
begin
  VertScrollBox1.ViewportPosition := PointF(VertScrollBox1.ViewportPosition.X, 0);
  MainLayout1.Align := TAlignLayout.Client;
  VertScrollBox1.RealignContent;
end;

procedure TfConfigCliente.UpdateKBBounds;
var
  LFocused : TControl;
  LFocusRect: TRectF;
begin
   FNeedOffset := False;
  if Assigned(Focused) then
  begin
    LFocused := TControl(Focused.GetObject);
    LFocusRect := LFocused.AbsoluteRect;
    LFocusRect.Offset(VertScrollBox1.ViewportPosition);
    if (LFocusRect.IntersectsWith(TRectF.Create(FKBBounds))) and
       (LFocusRect.Bottom > FKBBounds.Top) then
    begin
      FNeedOffset := True;
      MainLayout1.Align := TAlignLayout.Horizontal;
      VertScrollBox1.RealignContent;
      Application.ProcessMessages;
      VertScrollBox1.ViewportPosition :=
      PointF(VertScrollBox1.ViewportPosition.X,
      LFocusRect.Bottom - FKBBounds.Top);
    end;
  end;
  if not FNeedOffset then
    RestorePosition;
end;

//Despues de 1 segundo de iniciada la app, este timer asigna la ip guardada en el componente de conexion
//Se hace despues de 1 segundo pues si se intenta directamente al iniciar la app esta se cuelga.
end.
