unit Usuario;
//En esta unidad se inicia sesion con el usuario de microsip
interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, System.ImageList, FMX.ImgList, FMX.Ani, FMX.Objects,System.IOUtils,
  FMX.Effects, FMX.Layouts,FMX.Platform, FMX.VirtualKeyboard,FMX.Memo,  FMX.ListBox, FMX.ScrollBox,System.Math;

type
  TUser = class(TForm)
    FDConnection1: TFDConnection;
    FDQueryUser: TFDQuery;
    FloatAnimation1: TFloatAnimation;
    Iconos: TImageList;
    ColorAnimation1: TColorAnimation;
    txtpass: TEdit;
    txtuser: TEdit;
    Image1: TImage;
    Layout1: TLayout;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Layout2: TLayout;
    Layout3: TLayout;
    Label1: TLabel;
    Label2: TLabel;
    VertScrollBox1: TVertScrollBox;
    MainLayout1: TLayout;
    procedure Button1Click(Sender: TObject);
    procedure FDConnection1AfterConnect(Sender: TObject);
    procedure FDConnection1BeforeConnect(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormFocusChanged(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
  private
    { Private declarations }
    FKBBounds: TRectF;
    FNeedOffset: Boolean;
    procedure CalcContentBoundsProc(Sender: TObject;
                                    var ContentBounds: TRectF);
    procedure RestorePosition;
    procedure UpdateKBBounds;
  public
    { Public declarations }
  end;

var
  User: TUser;

implementation

{$R *.fmx}

uses Presentacion, ClientClassesUnit1, ClientModuleUnit1,
  FGX.Toasts.Android, FGX.Toasts, ConfigCliente, MainActivity, Configuracion;
procedure TUser.Button1Click(Sender: TObject);
var
  Toast: TfgToast;
begin
  if ClientModule1.ServerMethods2Client.Checar_Usuario(txtuser.Text,txtpass.Text)
  then
    begin
    Toast := TfgToast.Create('Bienvenido '+txtuser.Text, TfgToastDuration(Long));
    Toast.Icon:=FMainActivity.Logo.Bitmap;
    Toast.MessageColor := $FF000000;
    Toast.BackgroundColor := $FFFFFF ;
    Toast.Show;
    Toast.Free;
    fMainActivity.Show;
    try
      with FDQueryUser,SQL do
      begin
        fMainActivity.Borrar_Usuario;
        Clear;
        Add('Insert into EXP_USUARIO (NOMBRE) VALUES ('''+txtuser.Text+''')');
        FDQueryUser.ExecSQL;
        fMainActivity.Obtener_Usuario;
        fMainActivity.labelUser.Text:= (FMainActivity.USUARIO_NOMBRE);
      end;
      except
      on E:exception do
      ShowMessage(e.Message);
    end;
  end
  else showmessage('Usuario o contraseña incorrectos')
end;

procedure TUser.Button2Click(Sender: TObject);
begin
  fConfigCliente:=TfConfigCliente.Create(nil);
  try
    fConfigCliente.Show;
  finally
    fConfigCliente.free;
  end;
end;

procedure TUser.Button3Click(Sender: TObject);
var
  Toast: TfgToast;
begin
  fMainActivity.Borrar_Usuario;
  fMainActivity.USUARIO_NOMBRE:=('');
  fMainActivity.LabelUser.Text:=('');
  Toast := TfgToast.Create('Saliste ', TfgToastDuration(Short));
  Toast.Icon:=FMainActivity.Logo.Bitmap;
  Toast.MessageColor := $FF000000;
  Toast.BackgroundColor := $FFFFFF ;
  Toast.Show;
  Toast.Free;
  fMainActivity.Show;
  txtuser.Text:=('');
  txtpass.Text:=('');
end;

procedure TUser.CalcContentBoundsProc(Sender: TObject;
  var ContentBounds: TRectF);
begin
   if FNeedOffset and (FKBBounds.Top > 0) then
  begin
    ContentBounds.Bottom := Max(ContentBounds.Bottom,
                                30 * ClientHeight - FKBBounds.Top);
  end;
end;

procedure TUser.FDConnection1AfterConnect(Sender: TObject);
begin
  FDConnection1.ExecSQL('CREATE TABLE IF NOT EXISTS EXP_USUARIO (NOMBRE TEXT)');
end;

procedure TUser.FDConnection1BeforeConnect(Sender: TObject);
begin
  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  FDConnection1.Params.Values['Database'] :=
  TPath.Combine(TPath.GetDocumentsPath, 'Colectora.s3db');
  {$ENDIF}
end;

procedure TUser.FormCreate(Sender: TObject);
begin
  VKAutoShowMode := TVKAutoShowMode.Always;
  VertScrollBox1.OnCalcContentBounds := CalcContentBoundsProc;
end;

procedure TUser.FormFocusChanged(Sender: TObject);
begin
  UpdateKBBounds;
end;

procedure TUser.FormShow(Sender: TObject);
begin
  txtuser.Text:=fMainActivity.USUARIO_NOMBRE;
  txtpass.Text:=fMainActivity.USUARIO_PASS;
  if fMainActivity.USUARIO_NOMBRE.Equals('') then Image4.Enabled:=True else Image2.Enabled:=True;

end;

procedure TUser.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  FKBBounds.Create(0, 0, 0, 0);
  FNeedOffset := False;
  RestorePosition;
  Image5.Visible:=true;
  Layout1.Align := TAlignLayout.Bottom;
end;

procedure TUser.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  Image5.Visible:=False;
  Layout1.Align := TAlignLayout.Top;
  FKBBounds := TRectF.Create(Bounds);
  FKBBounds.TopLeft := ScreenToClient(FKBBounds.TopLeft);
  FKBBounds.BottomRight := ScreenToClient(FKBBounds.BottomRight);
  UpdateKBBounds;
end;

procedure TUser.Image2Click(Sender: TObject);
var
  Toast: TfgToast;
begin
  fMainActivity.Borrar_Usuario;
  fMainActivity.USUARIO_NOMBRE:=('');
  fMainActivity.USUARIO_Pass:=('');
  fMainActivity.LabelUser.Text:=('');
  Toast := TfgToast.Create('Saliste ', TfgToastDuration(Short));
  Toast.Icon:=FMainActivity.Logo.Bitmap;
  Toast.MessageColor := $FF000000;
  Toast.BackgroundColor := $FFFFFF ;
  Toast.Show;
  Toast.Free;
  fMainActivity.Show;
  txtuser.Text:=('');
  txtpass.Text:=('');
end;

procedure TUser.Image3Click(Sender: TObject);
begin
  fConfigCliente:=TfConfigCliente.Create(nil);
  try
    fConfigCliente.Show;
  finally
    fConfigCliente.free;
  end;
end;

procedure TUser.Image4Click(Sender: TObject);
var
  Toast: TfgToast;
  KeyboardService: IFMXVirtualKeyboardService;
begin
  fMainActivity.BuscarArchivoConexion;
  if fMainActivity.Ip.Equals('') then ShowMessage('Ingresa la IP del servidor')
  else if txtuser.Text.Equals('') or txtpass.Text.Equals('') then ShowMessage('Ingrese usuario y contraseña')
  else if ClientModule1.ServerMethods2Client.Checar_Usuario(txtuser.Text,txtpass.Text)
  then
  begin

    try
      with FDQueryUser,SQL do
      begin
        fMainActivity.Borrar_Usuario;
        Clear;
        Add('Insert into EXP_USUARIO (NOMBRE,PASS) VALUES ('+''''+txtuser.Text+''''+','+''''+txtpass.Text+''''+')');
        FDQueryUser.ExecSQL;
        fMainActivity.Obtener_Usuario;
        fMainActivity.labelUser.Text:= (FMainActivity.USUARIO_NOMBRE);
        if TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(KeyboardService)) then
        KeyboardService.HideVirtualKeyboard;
        Toast := TfgToast.Create('Bienvenido '+txtuser.Text, TfgToastDuration(Long));
        Toast.Icon:=FMainActivity.Logo.Bitmap;
        Toast.MessageColor := $FF000000;
        Toast.BackgroundColor := $FFFFFF ;
        Toast.Show;
        Toast.Free;
        fMainActivity.Show;
      end;

      except
      on E:exception do
      ShowMessage(e.Message);
    end;
  end
  else showmessage('Usuario o contraseña incorrectos')
end;
procedure TUser.RestorePosition;
begin
  VertScrollBox1.ViewportPosition := PointF(VertScrollBox1.ViewportPosition.X, 0);
  MainLayout1.Align := TAlignLayout.Client;
  VertScrollBox1.RealignContent;
end;

procedure TUser.UpdateKBBounds;
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

end.
