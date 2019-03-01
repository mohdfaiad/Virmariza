unit Colectora;
//Esta es una de las unidades mas importantes, es quien se encarga de colectar e insertar los articulos escaneados
//Cuenta con un modo automatico que lee y un modo manual en el que el usuario ingresa el codigo y la cantidad manualmente
interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.TabControl,
  FMX.StdCtrls, FMX.Gestures, FMX.Controls.Presentation, FMX.Edit, FMX.Layouts,
  FMX.ListBox, Data.DbxSqlite, Data.FMTBcd, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.SqlExpr, Data.Bind.Components, Data.Bind.DBScope,
  Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, System.ImageList, FMX.ImgList, FMX.Objects,System.IOUtils,FMX.VirtualKeyboard,FMX.Platform,
  FMX.Effects;

type
  TForm4 = class(TForm)
  Cantidad: TLabel;
  FDQuery1: TFDQuery;
  FDQueryInsert: TFDQuery;
  Edit2: TEdit;
  Switch1: TSwitch;
  FondoExpertos: TBrushObject;
  Layout1: TLayout;
  Layout2: TLayout;
  lblNombre: TLabel;
  Layout3: TLayout;
  lblCantidad: TLabel;
  Layout4: TLayout;
  lblPrecio: TLabel;
  Layout5: TLayout;
  lblUnidad: TLabel;
  BtnIngresar: TSpeedButton;
  Edit1: TEdit;
  Layout6: TLayout;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Image10: TImage;
    Image11: TImage;
  procedure FormShow(Sender: TObject);
  procedure Edit2Typing(Sender: TObject);
  procedure Switch1Switch(Sender: TObject);
  procedure Image2Click(Sender: TObject);
  procedure Nuevo_Inventario;
  procedure Buscar_Inventario;
  procedure Image4Click(Sender: TObject);
  procedure BtnIngresarClick(Sender: TObject);
  procedure FormHide(Sender: TObject);
  procedure Timer1Timer(Sender: TObject);
  private
  procedure BuscarArticulo;
  procedure InsertarArticulo;
  procedure InsertarArticuloConCantidad;
  procedure ContarCantidadArticulo;
  procedure Act_Ins;
  procedure MostrarArticulo;
  procedure Modo_Manual;

   { Private declarations }
  public
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
  NUEVO_REGISTRO :integer;
  ENVIADO: String;
  Hoy :TDateTime;
  ULTIMO_ID: Integer;
  ULTIMO_REGISTRO :integer;
  MOMENTO_DIA: String;
  procedure Crear_Inventario;
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.fmx}
uses    FGX.Toasts.Android, FGX.Toasts, MainActivity, Configuracion, EditarInventario;

//Este Procedimiento decide que hacer dependiendo del codigo leido con el verificador
procedure TForm4.Act_Ins;
begin
  BuscarArticulo;
  //Si la busqueda retorna nulo en el id del articulo significa que el articulo no existe
  if ARTICULO_ID.Equals('')then
  begin
    showmessage('El artículo no existe o está inactivo');
    Edit2.SetFocus;
  end
  //De otra forma Busca el articulo en el inventario, lo muestra,y establece el Edit text en nulo
  else
  begin
    ContarCantidadArticulo;
    MostrarArticulo;
    if Switch1.IsChecked then Modo_Manual else InsertarArticulo;
  end;
end;

//Busca la cantidad de registros de X articulo usando como condicion el codigo del articulo y el usuario que lo inserto
procedure TForm4.ContarCantidadArticulo;
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

procedure TForm4.Buscar_Inventario;
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


procedure TForm4.Crear_Inventario;
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

//En este procedimiento se ejecutan diversos metodos al leer el articulo
procedure TForm4.Edit2Typing(Sender: TObject);
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

procedure TForm4.FormHide(Sender: TObject);
begin
  fConfiguracion.combobox1.Clear;
  fConfiguracion.Obtener_Almacenes;
  Buscar_Inventario;
end;

procedure TForm4.FormShow(Sender: TObject);
var
  KeyboardService: IFMXVirtualKeyboardService;
begin
  Buscar_Inventario;
  if ULTIMO_REGISTRO=0 then Crear_Inventario
  else if  ULTIMO_REGISTRO.ToString.Equals('') then Crear_Inventario;
  if TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(KeyboardService)) then
  Edit2.SetFocus;
  KeyboardService.HideVirtualKeyboard;
  FMX.Types.VKAutoShowMode :=TVKAutoShowMode.Never;
end;
//Inserta Un registro del articulo  mostrando informacion del producto al finalizar
procedure TForm4.Image2Click(Sender: TObject);
begin
  FMainActivity.Show;
  form4.Close;
end;

procedure TForm4.Image4Click(Sender: TObject);
begin
  FConfiguracion.Show;
end;

procedure TForm4.InsertarArticulo;
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

procedure TForm4.InsertarArticuloConCantidad;
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


//El modo manual multiplica la cantidad de registros por lo que el usuario decida
procedure TForm4.Modo_Manual;
begin
  InsertarArticuloConCantidad;
end;

//Este procedimiento Le muestra al usuario la informacion del articulo como el nombre,precio, linea y cantidad
procedure TForm4.MostrarArticulo;
begin
  lblNombre.Text:= EXP_ART_NOMBRE;
  lblPrecio.Text:= EXP_ART_PRECIO;
  lblUnidad.Text:= EXP_ART_UNIDAD;
  lblCantidad.Text:=CANTIDAD_ARTICULO;
end;
procedure TForm4.Nuevo_Inventario;
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

//Le indica al usuario cuando activa el modo manual o lo desactiva
procedure TForm4.Switch1Switch(Sender: TObject);
begin
  if Switch1.IsChecked then
  begin
    showmessage('Ingresa cantidad y clave del artículo ');
    Edit2.SetFocus;
    Edit1.Visible:=true;
    Edit2.Align :=  TAlignLayout.MostTop;
    BtnIngresar.Visible:=true;
    Edit2.TextPrompt:=('Escanear o ingresar la clave del articulo');
  end
  else
  begin
    showmessage('Modo manual desactivado');
    Cantidad.Text:=('');
    BtnIngresar.Visible:=false;
    Edit2.Align :=  TAlignLayout.Bottom;
    Edit2.SetFocus;
    Edit2.Text:=('');
    Edit1.Text:=('');
    Edit1.Visible:=false;
  end;
end;
procedure TForm4.Timer1Timer(Sender: TObject);
begin
  Edit2.SetFocus;
end;

//Este procedimiento obtiene la informacion del articulo en la base de datos y la pone en variables
procedure TForm4.BtnIngresarClick(Sender: TObject);
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

procedure TForm4.BuscarArticulo;
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
      Articulo_ID:=('');
      ARTICULO_CODIGO:=('');
      Existe:=false;
    end;
  end;
end;

end.


//Para serial y lote
{*
 procedure TForm4.Ingresar_Lote;
begin
     BuscarArticulo;
     BuscarInventario;
     MostrarArticulo;
     Switch1.IsChecked:=false;
     Edit2.SetFocus;
     Edit1.Text:=('');
     Cantidad.Text:=('');
     Edit1.Visible:=True;
     Edit1.SetFocus;
     Edit1.TextPrompt:= ('Ingresa el Lote del articulo');
end;

procedure TForm4.Ingresar_Serie;
begin
    BuscarArticulo;
    BuscarInventario;
    MostrarArticulo;
    Switch1.IsChecked:=false;
    Edit2.SetFocus;
    Edit1.Text:=('');
    Cantidad.Text:=('');
    Edit1.Visible:=True;
    Edit1.SetFocus;
    Edit1.TextPrompt:= ('Ingresa la serie del articulo');
end;
*}
