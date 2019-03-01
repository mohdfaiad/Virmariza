unit Configuracion;
//Esta unidad solo es la liga a la unidad de usuario, conexion y proximamente otras mas si se agregan mas opciones de configuracion
interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, System.ImageList, FMX.ImgList, FMX.Layouts,
  FMX.ExtCtrls, FMX.ListBox, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.Objects, FMX.Effects,Androidapi.JNI.GraphicsContentViewText,
  FMX.Helpers.Android,Androidapi.Helpers;

type
  TfConfiguracion = class(TForm)
    ComboBox1: TComboBox;
    Layout2: TLayout;
    Image2: TImage;
    Switch1: TSwitch;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image1: TImage;
    Image7: TImage;
    Layout1: TLayout;
    SpeedButton1: TSpeedButton;
    Layout3: TLayout;
    Layout4: TLayout;
    SpeedButton2: TSpeedButton;
    procedure Image1Click(Sender: TObject);
    procedure Obtener_Almacenes;
    procedure Actualizar_Almacen;
    procedure Guardar_Almacen;
    procedure BuscarAlmacenElegido;
    procedure BuscarAlmacenXNombre;
    procedure Eliminar_Dia_Anterior;
    procedure Checar_Enviado;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Buscar_Inventario;
    procedure Image4Click(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure Image7Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure ComboBox1Click(Sender: TObject);
    procedure Image6Gesture(Sender: TObject; const EventInfo: TGestureEventInfo;
      var Handled: Boolean);
  private
    { Private declarations }
  public
  ALMACEN_ELEGIDO_ID:String;
  ALMACEN_ELEGIDO:String;
  COMBO_SELECCIONADO:Boolean;
  CAMARA:string;
  ENVIADO:String;
  ULTIMO_ID: Integer;
  ULTIMO_REGISTRO :integer;
  MOMENTO_DIA: String;
  Almacenes_Descargados:string;
    { Public declarations }
  end;

var
  fConfiguracion: TfConfiguracion;

implementation

{$R *.fmx}

uses ConfigCliente, Usuario, MainActivity, FGX.Toasts.Android, FGX.Toasts,
  ClientModuleUnit1, Colectora;
procedure TfConfiguracion.Actualizar_Almacen;
begin
  try
    with fMainActivity.FDQueryConfiguracion,SQL do
    begin
      Active :=  False;
      Clear;
      Add('select ultimo_id  from EXP_CONFIGURACION_DET' );
      Close;
      Open;
      ULTIMO_ID:= Fields[0].AsInteger;
      Clear;
      Add('Update  EXP_CONFIGURACION_DET set ALMACEN_ELEGIDO_ID='+''''+ALMACEN_ELEGIDO_ID+''''+ ',ALMACEN_ELEGIDO='+''''+ComboBox1.Selected.Text+''''+ ',CAMARA='+''''+CAMARA+''''+ ',ULTIMO_ID='+ULTIMO_ID.ToString);
      fMainActivity.FDQueryConfiguracion.ExecSQL;
      Clear;
      Add('select ultimo_id  from EXP_CONFIGURACION_DET' );
      Close;
      Open;
      ULTIMO_ID:= Fields[0].AsInteger;
    end;
    except
    on E:exception do
    showmessage('Aqui'+e.Message);
  end;
end;

procedure TfConfiguracion.BuscarAlmacenElegido;
begin
  try
    with fMainActivity.FDQueryBuscar,SQL do
    begin
      Active :=  False;
      Clear;
      Add('Select Almacen_elegido,Almacen_elegido_id,Camara From EXP_CONFIGURACION_DET');
      Close;
      Open;
      ALMACEN_ELEGIDO:=(Fields[0].AsString);
      ALMACEN_ELEGIDO_ID:=(Fields[1].AsString);
      CAMARA:=(Fields[2].AsString);
    end;
    except
    on E:exception do
    showmessage(e.Message);
  end;
end;

procedure TfConfiguracion.BuscarAlmacenXNombre;
var
  before, after : string;
begin
  try
    before := ComboBox1.Selected.ToString;
    after  := StringReplace(before, 'TListBoxItem','',
    [rfReplaceAll, rfIgnoreCase]);
    with fMainActivity.FDQueryBuscar,SQL do
    begin
      Active :=  False;
      Clear;
      Add('Select * From EXP_ALMACEN Where NOMBRE='+after);
      Close;
      Open;
      begin
        try
          begin
            ALMACEN_ELEGIDO_ID:=(Fields[0].AsString);
          end;

        except
        on e: Exception do
          begin
            ShowMessage(e.Message);
          end;
        end;
      end;
    end;
    except
    on E:exception do
    showmessage(e.Message);
  end;
end;

procedure TfConfiguracion.Buscar_Inventario;
begin
   try
      with fMainActivity.FDQueryBuscar,SQL do
      begin
        Active :=  False;
        Clear;
        Add('select  FOLIO_ID,MOMENTO_DIA,ENVIADO from exp_inventario_fisico where Almacen='+ALMACEN_ELEGIDO_ID+' order by FOLIO_ID  DESC LIMIT 1');
        Close;
        Open;
        ULTIMO_REGISTRO:=Fields[0].AsInteger;
        MOMENTO_DIA:= Fields[1].AsString;
        ENVIADO:= Fields[2].AsString;
        Clear;
        Add('select ultimo_id  from EXP_CONFIGURACION_DET' );
        Close;
        Open;
        ULTIMO_ID:=(Fields[0].AsInteger);
      end;
      except
      on E:exception do
      // showmessage( e.Message);
    end;
end;

procedure TfConfiguracion.Checar_Enviado;
begin
  try
    with fMainActivity.FDQueryBuscar,SQL do
    begin
      Active :=  False;
      Clear;
      Add('Select ENVIADO From EXP_INVENTARIO_FISICO Where Almacen='+Almacen_Elegido_ID);
      Close;
      Open;
      Enviado:= (Fields[0].AsString);
    end;
    except
    on E:exception do
    showmessage(e.Message);
  end;
end;

procedure TfConfiguracion.ComboBox1Change(Sender: TObject);
begin
  COMBO_SELECCIONADO:=True;
end;

procedure TfConfiguracion.ComboBox1Click(Sender: TObject);
begin
  if Almacenes_Descargados.Equals('') then
  begin
     fMainActivity.AnimacionDescarga;
     fMainActivity.Timer:='BajarAlmacenes';
     fMainActivity.Timer1.Enabled:=true;
  end;
end;

procedure TfConfiguracion.Eliminar_Dia_Anterior;
begin
  try
    with fMainActivity.FDQueryBorrar,SQL do
    begin
      Active :=  False;
      Clear;
      Add('delete from EXP_INVENTARIO_FISICO_DET WHERE ALMACEN='+ALMACEN_ELEGIDO_ID+' AND U_CAPTURA='+''''+fMainActivity.USUARIO_NOMBRE+'''');
      fMainActivity.FDQueryBorrar.ExecSQL;
      Clear;
      Add('delete from EXP_INVENTARIO_FISICO WHERE ALMACEN='+ALMACEN_ELEGIDO_ID+' AND U_CAPTURA='+''''+fMainActivity.USUARIO_NOMBRE+'''');
      fMainActivity.FDQueryBorrar.ExecSQL;
    end;
    except
    on E:exception do
    showmessage(e.Message);
  end;
end;

procedure TfConfiguracion.FormCreate(Sender: TObject);
begin
  Obtener_Almacenes;
  fMainActivity.labelUser.Text:= (FMainActivity.USUARIO_NOMBRE);
  BuscarAlmacenElegido;
  fMainActivity.labelAlmacen.Text:= (ALMACEN_ELEGIDO);
  if ALMACEN_ELEGIDO_ID<>('') then  else Guardar_Almacen;
  if CAMARA.Equals('1') then Switch1.ischecked:=True else Switch1.ischecked:=False;
end;

procedure TfConfiguracion.FormShow(Sender: TObject);
begin
 Combobox1.SetFocus;
end;

procedure TfConfiguracion.Guardar_Almacen;
begin
  try
    with fMainActivity.FDQueryConfiguracion,SQL do
    begin
      Active :=  False;
      Clear;
      Add('Insert or ignore into EXP_CONFIGURACION_DET (ALMACEN_ELEGIDO_ID,ALMACEN_ELEGIDO,ULTIMO_ID,CAMARA) VALUES ('+''''+'0'+''''+','+''''+''+''''+','+''''+'0'+''''+','+''''+'0'+''''  + ')');
      fMainActivity.FDQueryConfiguracion.ExecSQL;
    end;
    except
    on E:exception do
    showmessage(e.Message);
  end;
end;

procedure TfConfiguracion.Image1Click(Sender: TObject);
begin
  ComboBox1.SetFocus;
end;
procedure TfConfiguracion.Image4Click(Sender: TObject);
begin
  fConfigCliente:=TfConfigCliente.Create(nil);
  try
    fConfigCliente.Show;
  finally
    fConfigCliente.free;
  end;
end;

procedure TfConfiguracion.Image5Click(Sender: TObject);
begin
  User:=TUser.Create(nil);
  try
    User.Show;
  finally
    User.Free;
  end;
end;

procedure TfConfiguracion.Image6Gesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
   MessageDlg('¿Desea descargar los almacenes nuevamente?', System.UITypes.TMsgDlgType.mtInformation,
  [
  System.UITypes.TMsgDlgBtn.mbOK,
  System.UITypes.TMsgDlgBtn.mbNo
  ], 0,
  procedure(const AResult: System.UITypes.TModalResult)
  begin
    case AResult of
      mrOk:
      begin
        fMainActivity.AnimacionDescarga;
        fMainActivity.Timer:='BajarAlmacenes';
        fMainActivity.Timer1.Enabled:=true;
      end;
      mrNo:
    end;
  end);
end;

procedure TfConfiguracion.Image7Click(Sender: TObject);
begin
  if COMBO_SELECCIONADO then
  begin
    //Relacionado a camara
    if Switch1.IsChecked then CAMARA:='1' else CAMARA:='0';
    //Relacionado a almacen
    BuscarAlmacenXNombre;
    Actualizar_Almacen;
    BuscarAlmacenXNombre;
    Buscar_Inventario;
    fMainActivity.Obtener_Usuario;
    FMainActivity.labelUser.Text:= (FMainActivity.USUARIO_NOMBRE);
    BuscarAlmacenElegido;
    FMainActivity.labelAlmacen.Text:= (ALMACEN_ELEGIDO);
    Buscar_Inventario;
    fMainActivity.Show;
  end
  else ShowMessage('Seleccione un almacén');
end;

procedure TfConfiguracion.Obtener_Almacenes;
begin
  try
    with fMainActivity.FDQueryBuscar,SQL do
    begin
      Active :=  False;
      Clear;
      Add('Select * From EXP_ALMACEN');
      Close;
      Open;

      while not eof do
      begin
        try
          begin
            ComboBox1.Items.Add(Fields[1].AsString);
            Almacenes_Descargados:=Fields[1].AsString;
            Next;
          end;
        except
          on e: Exception do
          begin
            ShowMessage(e.Message);
          end;
        end;
      end;

    end;
    except
    on E:exception do
    showmessage(e.Message);
  end;
end;

procedure TfConfiguracion.SpeedButton1Click(Sender: TObject);
var
  Intent: JIntent;
begin
  Intent := TJIntent.Create;
  Intent.setAction(TJIntent.JavaClass.ACTION_VIEW);
  Intent.setData(StrToJURI('http://www.expertospv.com/'));
  SharedActivity.startActivity(Intent);
end;

procedure TfConfiguracion.SpeedButton2Click(Sender: TObject);
var
  Intent: JIntent;
begin
  Intent := TJIntent.Create;
  Intent.setAction(TJIntent.JavaClass.ACTION_DIAL);
  Intent.setData(StrToJURI('tel:871 716 5854 '));
  SharedActivity.startActivity(Intent);
end;

end.
