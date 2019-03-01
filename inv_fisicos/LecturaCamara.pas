unit LecturaCamara;

{
  * Copyright 2015 E Spelt for test project stuff
  *
  * Licensed under the Apache License, Version 2.0 (the "License");
  * you may not use this file except in compliance with the License.
  * You may obtain a copy of the License at
  *
  *      http://www.apache.org/licenses/LICENSE-2.0
  *
  * Unless required by applicable law or agreed to in writing, software
  * distributed under the License is distributed on an "AS IS" BASIS,
  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  * See the License for the specific language governing permissions and
  * limitations under the License.

  * Implemented by E. Spelt for Delphi
}
interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.Math.Vectors,
  System.Actions,
  System.Threading,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Objects,
  FMX.StdCtrls,
  FMX.Media,
  FMX.Platform,
  FMX.MultiView,
  FMX.ListView.Types,
  FMX.ListView,
  FMX.Layouts,
  FMX.ActnList,
  FMX.TabControl,
  FMX.ListBox,
  FMX.Controls.Presentation,
  FMX.ScrollBox,
  FMX.Memo,
  FMX.Controls3D,
  ZXing.BarcodeFormat,
  ZXing.ReadResult,
  ZXing.ScanManager, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FMX.Edit, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.Ani;

type
  TMainForm = class(TForm)
    btnStartCamera: TButton;
    btnStopCamera: TButton;
    lblScanStatus: TLabel;
    imgCamera: TImage;
    ToolBar1: TToolBar;
    btnMenu: TButton;
    Layout2: TLayout;
    ToolBar3: TToolBar;
    CameraComponent1: TCameraComponent;
    openDlg: TOpenDialog;
    Camera1: TCamera;
    Layout1: TLayout;
    Layout3: TLayout;
    Switch1: TSwitch;
    FDQuery1: TFDQuery;
    FDQueryInsert: TFDQuery;
    Edit2: TEdit;
    BtnIngresar: TSpeedButton;
    Cantidad: TLabel;
    Edit1: TEdit;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    Rectangle4: TRectangle;
    Line1: TLine;
    fltnmtn1: TFloatAnimation;
    Layout9: TLayout;
    Arc1: TArc;
    Arc2: TArc;
    Layout10: TLayout;
    Label1: TLabel;
    Switch2: TSwitch;
    Layout6: TLayout;
    Layout4: TLayout;
    Image7: TImage;
    Image2: TImage;
    lblNombre: TLabel;
    Layout5: TLayout;
    Image8: TImage;
    Image6: TImage;
    lblCantidad: TLabel;
    Layout7: TLayout;
    Image10: TImage;
    Image5: TImage;
    lblPrecio: TLabel;
    Layout8: TLayout;
    Image9: TImage;
    Image4: TImage;
    lblUnidad: TLabel;
    Image3: TImage;
    Image11: TImage;
    Image1: TImage;
    procedure btnStartCameraClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnStopCameraClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CameraComponent1SampleBufferReady(Sender: TObject;
    const ATime: TMediaTime);
    procedure FormHide(Sender: TObject);
    //Colectora
    procedure Nuevo_Inventario;
    procedure Buscar_Inventario;
    procedure Switch1Switch(Sender: TObject);
    procedure Insertar;
    procedure BtnIngresarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Switch2Switch(Sender: TObject);

  private
    { Private declarations }
    FPermissionCamera : String;
    FScanManager: TScanManager;
    FScanInProgress: Boolean;
    FFrameTake: Integer;
    procedure GetImage();
    procedure ExplainReason(Sender: TObject; const APermissions: TArray<string>; const APostRationaleProc: TProc);
    procedure BuscarArticulo;
    procedure InsertarArticulo;
    procedure InsertarArticuloConCantidad;
    procedure ContarCantidadArticulo;
    procedure Act_Ins;
    procedure MostrarArticulo;
    procedure Modo_Manual;




    public
    ReadResult: TReadResult;
    Existe: Boolean;
    ARTICULO_CODIGO :string;
    ARTICULO_CODIGO2 :string;
    ARTICULO_ID :string;
    EXP_ART_NOMBRE :string;
    EXP_ART_UNIDAD :string;
    EXP_ART_PRECIO :string;
    EXP_ART_SEGUIMIENTO :string;
    EXP_LINEA_ART_NOMBRE :string;
    ID_REGISTRO :integer;
    CANTIDAD_ARTICULO :string;
    ULTIMO_REGISTRO :integer;
    NUEVO_REGISTRO :integer;
    MOMENTO_DIA: String;
    ENVIADO: String;
    Hoy :TDateTime;
    ULTIMO_ID: Integer;
    procedure Crear_Inventario;
  end;

var
  MainForm: TMainForm;

implementation
uses
{$IFDEF ANDROID}
  Androidapi.Helpers,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.Os,
{$ENDIF}
  FMX.DialogService, EditarInventario, Configuracion, MainActivity, FGX.Toasts, FGX.Toasts.Android;

{$R *.fmx}

procedure TMainForm.FormCreate(Sender: TObject);

begin
  lblScanStatus.Text := '';
  FFrameTake := 0;
  FScanManager := TScanManager.Create(TBarcodeFormat.Auto, nil);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FScanManager.Free;
end;


procedure TMainForm.FormHide(Sender: TObject);
begin
  CameraComponent1.TorchMode := TTorchMode.ModeOff;
  Switch2.IsChecked:=False;
  CameraComponent1.Active := false;
  imgCamera.Visible:=False;
  fConfiguracion.combobox1.Clear;
  fConfiguracion.Obtener_Almacenes;
  Buscar_Inventario;
  //Ocultar
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  Buscar_Inventario;
  if ULTIMO_REGISTRO=0 then Crear_Inventario
  else if  ULTIMO_REGISTRO.ToString.Equals('') then Crear_Inventario;
end;

procedure TMainForm.ExplainReason(Sender: TObject; const APermissions: TArray<string>; const APostRationaleProc: TProc);
begin
  TDialogService.ShowMessage('The app needs to access the camera to scan barcodes ...',
  procedure(const AResult: TModalResult)
  begin
    APostRationaleProc;
  end)
end;



procedure TMainForm.Act_Ins;
begin
  BuscarArticulo;
  //Si la busqueda retorna nulo en el id del articulo significa que el articulo no existe
  if ARTICULO_ID.Equals('')then showmessage('El artículo no existe o está inactivo')
  //De otra forma Busca el articulo en el inventario, lo muestra,y establece el Edit text en nulo
  else
  begin
    ContarCantidadArticulo;
    MostrarArticulo;
    if Switch1.IsChecked then Modo_Manual else InsertarArticulo;
  end;
end;

procedure TMainForm.BtnIngresarClick(Sender: TObject);
begin
  if Edit2.Text.Equals('') or Edit1.Text.Equals('') then showmessage('Ingresa cantidad y clave de articulo') else
  begin
    ARTICULO_CODIGO2:=ARTICULO_CODIGO;
    if ARTICULO_CODIGO2.Equals (Edit2.Text) then
    begin
      BuscarArticulo;
      ContarCantidadArticulo;
      MostrarArticulo;
      Modo_Manual;
    end
    else
    Act_Ins;

  end;
end;

procedure TMainForm.btnStartCameraClick(Sender: TObject);
begin
  //  PermissionsService.RequestPermissions([FPermissionCamera], CameraPermissionRequestResult, ExplainReason);
  CameraComponent1.Quality := FMX.Media.TVideoCaptureQuality.MediumQuality;
  if Switch2.IsChecked then CameraComponent1.TorchMode := TTorchMode.ModeOn else CameraComponent1.TorchMode := TTorchMode.ModeOff;
  imgCamera.Visible:=True;
  CameraComponent1.Kind := FMX.Media.TCameraKind.BackCamera;
  // CameraComponent1.FocusMode := FMX.Media.TFocusMode.ContinuousAutoFocus;
  CameraComponent1.FocusMode := FMX.Media.TFocusMode.ContinuousAutoFocus;
  CameraComponent1.Active := True;
  lblScanStatus.Text := '';
  //Memo1.Lines.Clear;  end;
end;

procedure TMainForm.btnStopCameraClick(Sender: TObject);
begin
  CameraComponent1.Active := false;
end;

procedure TMainForm.BuscarArticulo;
begin
   try
    with FDQuery1,SQL do
    begin
      Active :=  False;
      Clear;
      Add('select EXP_ART_ID,EXP_ART_CODIGO,EXP_ART_NOMBRE,EXP_ART_UNIDAD,EXP_ART_PRECIO,EXP_LINEA_ART_NOMBRE,EXP_ART_SEGUIMIENTO  from exp_articulos where exp_art_codigo ='+''''+Edit2.Text+'''');
      Close;
      Open;
      ARTICULO_ID:=FDQuery1.Fields[0].AsString;
      ARTICULO_CODIGO:= FDQuery1.Fields[1].AsString;
      EXP_ART_NOMBRE:= FDQuery1.Fields[2].AsString;
      EXP_ART_UNIDAD:= FDQuery1.Fields[3].AsString;
      EXP_ART_PRECIO:= FDQuery1.Fields[4].AsString;
      EXP_LINEA_ART_NOMBRE:=FDQuery1.Fields[5].AsString;
      EXP_ART_SEGUIMIENTO:=FDQuery1.Fields[6].AsString;
      Existe:=true;
    end;

  except
    on E:exception do
    begin
      //showmessage('Error en busqueda');
      Articulo_ID:=('');
      ARTICULO_CODIGO:=('');
      Existe:=false;
    end;
  end;
end;

procedure TMainForm.Buscar_Inventario;
begin
  try
    with FDQuery1,SQL do
    begin
      Active :=  False;
      Clear;
      Add('select  FOLIO_ID,ENVIADO from exp_inventario_fisico where Almacen='+fConfiguracion.ALMACEN_ELEGIDO_ID+' And U_Captura='+''''+FmainActivity.USUARIO_NOMBRE+'''');//' order by FOLIO_ID  DESC LIMIT 1');
      Close;
      Open;
      ULTIMO_REGISTRO:=Fields[0].AsInteger;
      ENVIADO:= Fields[1].AsString;
      Clear;
      Add('select ultimo_id  from EXP_CONFIGURACION_DET' );
      Close;
      Open;
      ULTIMO_ID:= Fields[0].AsInteger;
    end;
    except
    on E:exception do
     showmessage('Error' +e.Message);
  end;
end;

procedure TMainForm.CameraComponent1SampleBufferReady(Sender: TObject;
  const ATime: TMediaTime);
begin
  TThread.Synchronize(TThread.CurrentThread, GetImage);
end;

procedure TMainForm.ContarCantidadArticulo;
begin
  try
    with FDQuery1,SQL do
    begin
      Active :=  False;
      Clear;
      Add('select sum (cantidad) from EXP_INVENTARIO_FISICO_DET where U_CAPTURA ='''+FMainActivity.USUARIO_NOMBRE+''' and ARTICULO_ID='+ARTICULO_ID+' and FOLIO ='+ULTIMO_REGISTRO.ToString+' and ALMACEN ='+fConfiguracion.ALMACEN_ELEGIDO_ID);
      Close;
      Open;
      CANTIDAD_ARTICULO:=FDQuery1.Fields[0].AsString;
    end;
    except
    on E:exception do
    showmessage(e.Message);
  end;
end;

procedure TMainForm.Crear_Inventario;
begin
   try
    with FDQueryInsert,SQL do
    begin
      Hoy := Now;
      Clear;
      Add('UPDATE EXP_CONFIGURACION_DET SET ULTIMO_ID ='+(ULTIMO_ID+1).toString);
      FDQueryInsert.ExecSQL;
      ULTIMO_ID:=(ULTIMO_ID+1);
      Clear;
      Add('Insert into EXP_INVENTARIO_FISICO (FOLIO_ID,FECHA_CREACION,FECHA_HORA_CREACION,ALMACEN,ENVIADO,ENVIADO_FIN,U_CAPTURA) VALUES ('+(ULTIMO_ID).ToString+','+ '''' +((formatdatetime('d.m.y', Hoy))+ '''' +','+'''' +((formatdatetime('d.m.y', Hoy)))+(FormatDATETime(' hh:mm', Hoy)) )+ '''' +','+fConfiguracion.ALMACEN_ELEGIDO_ID+ ',''N'',''N'','+''''+FMainActivity.USUARIO_NOMBRE+''''+')');
      FDQueryInsert.ExecSQL;
    end;
    except
    on E:exception do
    ShowMessage(e.Message);
  end;
end;

procedure TMainForm.GetImage;
var
  scanBitmap: TBitmap;


begin
  CameraComponent1.SampleBufferToBitmap(imgCamera.Bitmap, True);

  if (FScanInProgress) then
  begin
    exit;
  end;

  { This code will take every 4 frame. }
  inc(FFrameTake);
  if (FFrameTake mod 1 <> 0) then
  begin
    exit;
  end;

  scanBitmap := TBitmap.Create();
  scanBitmap.Assign(imgCamera.Bitmap);
  ReadResult := nil;

  TTask.Run(
    procedure
    begin
      try
        FScanInProgress := True;
        try
          ReadResult := FScanManager.Scan(scanBitmap);
        except
          on E: Exception do
          begin
            TThread.Synchronize(nil,
              procedure
              begin
                lblScanStatus.Text := E.Message;
              end);

            exit;
          end;
        end;

        TThread.Synchronize(nil,
        procedure
         begin

            if (length(lblScanStatus.Text) > 10) then
            begin
              lblScanStatus.Text := '*';
            end;

            lblScanStatus.Text := lblScanStatus.Text + '*';
            if (ReadResult <> nil) then
            begin
             fMainActivity.ReproducirAudio('Resource_1');
             Edit2.Text:=ReadResult.Text;
             CameraComponent1.Active := false;
             Insertar;
            end;

         end);

      finally
        ReadResult.Free;
        scanBitmap.Free;
        FScanInProgress := false;
      end;
    end);

end;

procedure TMainForm.Insertar;
begin
  if Switch1.IsChecked then   else
  begin
    //Debido a que nesesito el nuevo y el viejo articulo leido para compararlos y saber si es el mismo
    //Por eso recorro el articulo mas recientemente leido con el anterior
    ARTICULO_CODIGO2:=ARTICULO_CODIGO;
    BuscarArticulo;
    //Checa si el articulo usa seguimiento con serial o lote
    // if EXP_ART_SEGUIMIENTO.Equals('S') then Ingresar_Serie else  if EXP_ART_SEGUIMIENTO.Equals('L') then Ingresar_Lote else
    //Si el penultimo articulo leido es el mismo que el ultimo entonces
    if ARTICULO_CODIGO2.Equals (Edit2.Text) then
    begin
      //Busca y muestra la informacion
      BuscarArticulo;
      if Existe then
      begin
        ContarCantidadArticulo;
        MostrarArticulo;
        InsertarArticulo;
      end;
    end
    //Entra al metodo que decide que hacer dependiendo del articulo leido
    else
    Act_Ins;
    Edit2.Text:='';
  end;
end;

procedure TMainForm.InsertarArticulo;
begin
  try
    with FDQueryInsert,SQL do
    begin
      Hoy := Now;
      Clear;
      Add('Insert into EXP_INVENTARIO_FISICO_DET (ARTICULO_ID,ARTICULO_CLAVE,F_CAPTURA,U_CAPTURA,FOLIO,CANTIDAD,ALMACEN) VALUES ('+ARTICULO_ID+','+''''+ARTICULO_CODIGO+''''+','+ '''' +((formatdatetime('d.m.y', Hoy))+(FormatDATETime(' hh:mm', Hoy)) )+ '''' +','+''''+FMainActivity.USUARIO_NOMBRE+''''+','+Ultimo_Registro.ToString+',1 ,' +fConfiguracion.ALMACEN_ELEGIDO_ID+')');
      FDQueryInsert.ExecSQL;
      ContarCantidadArticulo;
      BuscarArticulo;
      MostrarArticulo;
    end;
    except
    on E:exception do
    ShowMessage('No se pudo insertar el artículo '+e.Message);
  end;
end;

procedure TMainForm.InsertarArticuloConCantidad;
var
  Toast: TfgToast;
begin
  try
    with FDQueryInsert,SQL do
    begin
      Hoy := Now;
      Clear;
      Add('Insert into EXP_INVENTARIO_FISICO_DET (ARTICULO_ID,ARTICULO_CLAVE,F_CAPTURA,U_CAPTURA,FOLIO,CANTIDAD,ALMACEN) VALUES ('+ARTICULO_ID+','+''''+ARTICULO_CODIGO+''''+','+ '''' +((formatdatetime('d.m.y', Hoy))+(FormatDATETime(' hh:mm', Hoy)) )+ '''' +','+''''+FMainActivity.USUARIO_NOMBRE+''''+','+Ultimo_Registro.ToString+','+Edit1.Text+','+fConfiguracion.ALMACEN_ELEGIDO_ID+')');
      FDQueryInsert.ExecSQL;
      BuscarArticulo;
      ContarCantidadArticulo;
      MostrarArticulo;
    end;
    Toast := TfgToast.Create('Registro ingresado', TfgToastDuration(Long));
    Toast.Icon:=FMainActivity.Logo.Bitmap;
    Toast.MessageColor := $FF000000;
    Toast.BackgroundColor :=  $FFFFFF ;
    Toast.Show;
    Toast.Free;
    Edit1.Text:=('');
    Edit2.SetFocus;
    except
    on E:exception do
    //ShowMessage(e.Message);
    ShowMessage('El artículo no se pudo insertar correctamente verifica que este bien escrito');
  end;
end;

procedure TMainForm.Modo_Manual;
begin
  InsertarArticuloConCantidad;
end;

procedure TMainForm.MostrarArticulo;
begin
  lblNombre.Text:= EXP_ART_NOMBRE;
  lblPrecio.Text:= EXP_ART_PRECIO;
  lblUnidad.Text:= EXP_ART_UNIDAD;
  lblCantidad.Text:=CANTIDAD_ARTICULO;
end;

procedure TMainForm.Nuevo_Inventario;
begin
  try
    with FDQueryInsert,SQL do
    begin
      Nuevo_Registro:=Ultimo_Registro+1;
      Hoy := Now;
      BEGIN
        Clear;
        Add('Insert into EXP_INVENTARIO_FISICO (FOLIO_ID,FECHA_CREACION,FECHA_HORA_CREACION,ALMACEN,ENVIADO,ENVIADO_FIN,U_CAPTURA) VALUES ('+Nuevo_Registro.ToString+','+ '''' +(formatdatetime('d.m.y', Hoy))+ '''' +','+'''' +( (formatdatetime('d.m.y', Hoy))+(FormatDATETime(' hh:mm', Hoy)) )+ '''' +','+fConfiguracion.ALMACEN_ELEGIDO_ID+ ', ''N'',''N'','+''''+FMainActivity.USUARIO_NOMBRE+''''+')');
        FDQueryInsert.ExecSQL;
      END
    end;
    except
    on E:exception do
    ShowMessage(e.Message);
  end;
end;



procedure TMainForm.Switch1Switch(Sender: TObject);
begin
if Switch1.IsChecked then
  begin
    btnStartCamera.Text:=('Ingresar');
    showmessage('Ingresa cantidad y clave del artículo ');
    BtnIngresar.Visible:=True;
    imgCamera.Visible:=False;
    Edit2.Visible:=True;
    Edit2.SetFocus;
    Edit2.Align :=  TAlignLayout.MostTop;
    Edit1.Visible:=true;
    Edit2.TextPrompt:=('Escanea o escribe la clave del artículo');
    CameraComponent1.Active := false;
    btnStartCamera.Visible:=false;
    CameraComponent1.TorchMode := TTorchMode.ModeOff;
    Layout10.Visible:=False;
  end
  else
  begin
    showmessage('Modo manual desactivado');
    btnStartCamera.Text:=('Escanear');
    Cantidad.Text:=('');
    Edit2.Text:=('');
    Edit1.Text:=('');
    Edit1.Visible:=false;
    Edit2.Visible:=False;
    BtnIngresar.Visible:=False;
    btnStartCamera.Visible:=true;
    Layout10.Visible:=true;
  end;
end;

procedure TMainForm.Switch2Switch(Sender: TObject);
begin
  if Switch2.IsChecked then CameraComponent1.TorchMode := TTorchMode.ModeOn else CameraComponent1.TorchMode := TTorchMode.ModeOff
end;


{procedure TMainForm.Switch2Switch(Sender: TObject);
begin

end;

procedure TMainForm.Switch2Switch(Sender: TObject);
begin

end;

procedure TMainForm.Switch2Switch(Sender: TObject);
begin

end;

procedure TMainForm.Switch1Switch(Sender: TObject);
begin

end;

procedure TMainForm.Switch1Switch(Sender: TObject);
begin

end;

proceprocedure TMainForm.Nuevo_Inventario;
begin

end;

dprocedure TMainForm.Switch1Switch(Sender: TObject);
begin

end;

uprocedure TMainForm.Timer1Timer(Sender: TObject);
begin

end;

re TMainForm.LeidoClick(Sender: TObject);
begin

end;

 Make sure the camera is released if you're going away. }
 {*
function TMainForm.AppEvent(AAppEvent: TApplicationEvent;
AContext: TObject): Boolean;
begin
  case AAppEvent of
    TApplicationEvent.WillBecomeInactive, TApplicationEvent.EnteredBackground,
    TApplicationEvent.WillTerminate:
    CameraComponent1.Active := false;
  end;
end;
 *}
end.
