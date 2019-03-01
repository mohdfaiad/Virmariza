unit EditarInventario;
//Esta unidad es la encargada de permitir la modificacion a los registros realizados
//Como verlos, borrarlos, editarlos,enviarlos etc. Borrar almacenes completos entre mas opciones
interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, System.ImageList,
  FMX.ImgList, FMX.Layouts, FMX.ExtCtrls, FMX.Effects, System.Rtti,
  FMX.Grid.Style, FMX.ListBox, FMX.Grid, FMX.ScrollBox, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.Edit;

type
  TfEditarInventario = class(TForm)
    FDMemArt: TFDMemTable;
    DataSource1: TDataSource;
    FDMemTable1Nombre: TStringField;
    BindingsList1: TBindingsList;
    EditClave: TEdit;
    StringGrid1: TStringGrid;
    BindSourceDB1: TBindSourceDB;
    LinkGridToDataSourceBindSourceDB12: TLinkGridToDataSource;
    LabelCantidad: TLabel;
    Timer1: TTimer;
    Label3: TLabel;
    Layout1: TLayout;
    Label5: TLabel;
    ComboBox1: TComboBox;
    Enviar: TSpeedButton;
    FDMemArtID: TStringField;
    SpeedButton3: TSpeedButton;
    BtnAceptar: TSpeedButton;
    btnBorrar: TImage;
    ComboBox2: TComboBox;
    StringGrid2: TStringGrid;
    FDMemArtLinea: TFDMemTable;
    FDMemArtLineaFecha: TStringField;
    FDMemArtLineaNombre: TStringField;
    FDMemArtLineaID: TStringField;
    BindSourceDB2: TBindSourceDB;
    LinkGridToDataSourceBindSourceDB2: TLinkGridToDataSource;
    BtnBorrarLinea: TImage;
    Layout2: TLayout;
    FDMemArtLineaCantidad: TStringField;
    FDMemArtFecha: TStringField;
    FDMemArtCantidad: TStringField;
    Label2: TLabel;
    Layout3: TLayout;
    btnBorrarInv: TImage;
    TimerSubir: TTimer;
    Label6: TLabel;
    SpeedButton1: TSpeedButton;
    btnEditar: TImage;
    EditCantidad: TEdit;
    Image1: TImage;
    Layout5: TLayout;
    Layout6: TLayout;
    EditCantidadLinea: TEdit;
    Image2: TImage;
    Layout7: TLayout;
    procedure btnBorrarInvClick(Sender: TObject);
    procedure SpeedButton55Click(Sender: TObject);
    procedure Llenar_Tabla;
    procedure Llenar_Tabla_Linea;
    procedure Obtener_Total;
    procedure EnviarClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Obtener_Inventarios;
    procedure FormShow(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure BuscarAlmacenXNombre;
    procedure StringGrid1CellClick(const Column: TColumn; const Row: Integer);
    procedure BtnAceptarClick(Sender: TObject);
    procedure BorrarArticulo;
    procedure EditarArticulo;
    procedure EditarArticulLinea;
    procedure BorrarArticuloLinea;
    procedure ObtenerLineas;
    procedure SpeedButton3Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure StringGrid2CellClick(const Column: TColumn; const Row: Integer);
    procedure btnBorrarClick(Sender: TObject);
    procedure BtnBorrarLineaClick(Sender: TObject);
    procedure HouseClick(Sender: TObject);
    function Checar_Enviado: Boolean;
    procedure Mostrar_Fecha_Almacen;
    procedure Marcar_Como_Enviado_Final;
    Procedure BorrarInventario;
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure TimerSubirTimer(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    function Contar_Registros: Boolean;
  private
    Ultimo_Almacen_Enviado: String;
    IDROW_SELECCIONADO: String;
    ENVIADO: String;
    ENVIADO_FINAL: String;
    ENVIADO_CON_ALMACEN: String;
    CLAVE_LEIDA:String;
    { Private declarations }
  public
  { Public declarations }
    Almacen_ID: String;
    Final: Boolean;
    Vacio:string;
    procedure Marcar_Como_Enviado;
  end;

var
  fEditarInventario: TfEditarInventario;

implementation

{$R *.fmx}
{$R *.NmXhdpiPh.fmx ANDROID}

uses MainActivity, Configuracion, FGX.Toasts.Android, FGX.Toasts, Colectora;

procedure TfEditarInventario.BtnBorrarLineaClick(Sender: TObject);
var
  Toast: TfgToast;
begin
  begin
    MessageDlg('¿Está seguro de eliminar el registro?', System.UITypes.TMsgDlgType.mtInformation,
    [
    System.UITypes.TMsgDlgBtn.mbOk,
    System.UITypes.TMsgDlgBtn.mbNo
    ], 0,
    procedure(const AResult: System.UITypes.TModalResult)
    begin
      case AResult of
        mrOk:
        begin
          BorrarArticulolinea;
          Toast := TfgToast.Create('Registro eliminado', TfgToastDuration(Long));
          Toast.Icon:=FMainActivity.Logo.Bitmap;
          Toast.MessageColor := $FF000000;
          Toast.BackgroundColor :=  $FFFFFF ;
          Toast.Show;
          Toast.Free;
        end;
        mrNo:
      end;
    end);
  end;
end;


procedure TfEditarInventario.btnEditarClick(Sender: TObject);
begin
  MessageDlg('¿Desea editar la cantidad?', System.UITypes.TMsgDlgType.mtInformation,
  [
  System.UITypes.TMsgDlgBtn.mbOk,
  System.UITypes.TMsgDlgBtn.mbNo
  ], 0,
  procedure(const AResult: System.UITypes.TModalResult)
  begin
    case AResult of
      mrOk:
      begin
        if StringGrid1.Visible then
        begin
          if EditCantidad.Text.Equals('') then showmessage('Ingrese la cantidad') else if IDROW_SELECCIONADO.Equals('') then showmessage('Seleccione un registro') else EditarArticulo;
        end
        else if StringGrid2.Visible then
        begin
          if EditCantidadLinea.Text.Equals('') then showmessage('Ingrese la cantidad') else if IDROW_SELECCIONADO.Equals('') then showmessage('Seleccione un registro') else EditarArticulLinea;
        end;
      end;
      mrNo:
    end;
  end);
end;


procedure TfEditarInventario.BuscarAlmacenXNombre;
var
  before, after : string;
begin
  try
    before := ComboBox1.Selected.ToString;
    after  := StringReplace(before, 'TListBoxItem','',
    [rfReplaceAll, rfIgnoreCase]);
    with fMainActivity.FDQueryInsert,SQL do
    begin
      Active :=  False;
      Clear;
      Add('Select * From EXP_ALMACEN Where NOMBRE='+after);
      Close;
      Open;
      begin
        try
          begin
           // ALMACEN_ELEGIDO_ID:=(Fields[0].AsString);
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



procedure TfEditarInventario.Button2Click(Sender: TObject);
begin
  Checar_Enviado ;
end;

procedure TfEditarInventario.Button3Click(Sender: TObject);
begin
  BorrarInventario;
end;

function TfEditarInventario.Checar_Enviado: Boolean;
begin
  try
    with fMainActivity.FDQueryBuscar,SQL do
    begin
      Active :=  False;
      Clear;
      Add('Select ENVIADO From EXP_INVENTARIO_FISICO Where Almacen='+Almacen_ID+' and U_CAPTURA='+''''+fMainActivity.USUARIO_NOMBRE+'''');
      Close;
      Open;
      Enviado:= (Fields[0].AsString);
    end;
    except
    on E:exception do
    showmessage(e.Message);
  end;
end;


procedure TfEditarInventario.ComboBox1Change(Sender: TObject);
begin
  layout1.Visible:=true;
  Mostrar_Fecha_Almacen;
  Label5.Visible:=true;
  Checar_Enviado;
  if Enviado.Equals('S') then Label5.Text:=('Este inventario ya se envió') else Label5.Text:=('Este inventario no ha sido enviado');
  btnBorrarInv.Visible:=true;
end;


procedure TfEditarInventario.ComboBox2Change(Sender: TObject);
begin
  Layout6.Visible:=true;
  StringGrid2.Visible:=true;
  Llenar_Tabla_Linea;
end;

function TfEditarInventario.Contar_Registros: Boolean;
begin
  try
    with fMainActivity.FDQueryBorrar,SQL do
    begin
      Active :=  False;
      Clear;
      Add('Select count(*) from EXP_INVENTARIO_FISICO_DET WHERE ALMACEN='+Almacen_ID+' and U_CAPTURA='+''''+fMainActivity.USUARIO_NOMBRE+'''');
      Close;
      Open;
      if Fields[0].AsInteger=0 then result:=true else result:=false;
    end;
    except
    on E:exception do
    showmessage(e.Message);
  end;
end;

procedure TfEditarInventario.FormShow(Sender: TObject);
begin
  combobox1.Clear;
  Obtener_Inventarios;
  layout1.Visible:=false;
end;

procedure TfEditarInventario.HouseClick(Sender: TObject);
begin
  fMainActivity.Show;
  fEditarInventario.Hide;
end;

procedure TfEditarInventario.Image2Click(Sender: TObject);
begin
  if SpeedButton3.IsVisible then fMainActivity.Show
  else
  begin
     //Ocultar
    BtnEditar.Visible:=false;
    layout3.Visible:=false;
    layout5.Visible:=false;
    layout6.Visible:=false;
    EditCantidad.Visible:=false;
    EditCantidadLinea.Visible:=false;
    layout1.Visible:=false;
    StringGrid1.Visible:=false;
    StringGrid2.Visible:=false;
    BtnBorrarLinea.Visible:=false;
    Btnaceptar.Visible:=false;
    EditClave.Visible:=false;
    labelCantidad.Visible:=false;
    BtnBorrarLinea.Visible:=false;
    BtnBorrar.Visible:=false;
    //Borrar
    ComboBox2.Clear;
    IDROW_SELECCIONADO:=('');

    //Mostrar
    SpeedButton1.Visible:=true;
    Speedbutton3.Visible:=true;
    layout2.Visible:=true;
    Layout1.Visible:=true;
    Enviar.Visible:=true;
    btnBorrarInv.Visible:=true;
    Label3.Visible:=true;
  end;
end;

procedure TfEditarInventario.btnBorrarInvClick(Sender: TObject);
begin
  Checar_Enviado;
  if Enviado.Equals('S')  then
  begin
    MessageDlg('¿Está seguro de borrar el inventario seleccionado? ', System.UITypes.TMsgDlgType.mtInformation,
    [
    System.UITypes.TMsgDlgBtn.mbOk,
    System.UITypes.TMsgDlgBtn.mbNo
    ], 0,
    procedure(const AResult: System.UITypes.TModalResult)
    begin
      case AResult of
        mrOk:
        begin
          layout1.Visible:=false;
          BorrarInventario;
          Combobox1.Clear;
          Obtener_Inventarios;
          Label6.Text:=('');
          label5.Text:=('');
          Almacen_id:= ('');
          btnBorrarInv.Visible:=False;
        end;
        mrNo:
        fEditarInventario.Show;
      end;
    end);
  end
  else if Enviado.Equals('N') then
  begin
    MessageDlg('No se ha enviado el inventario, ¿Está seguro que desea borrarlo? ', System.UITypes.TMsgDlgType.mtInformation,
    [
    System.UITypes.TMsgDlgBtn.mbOk,
    System.UITypes.TMsgDlgBtn.mbNo
    ], 0,
    procedure(const AResult: System.UITypes.TModalResult)
    begin
      case AResult of
        mrOk:
        begin
          layout1.Visible:=false;
          BorrarInventario;
          Combobox1.Clear;
          Obtener_Inventarios;
          Label6.Text:=('');
          label5.Text:=('');
          Almacen_id:= ('');
        end;
        mrNo:
        fEditarInventario.Show;
      end;
    end);
  end

end;

procedure TfEditarInventario.Llenar_Tabla;
begin
  try
    Timer1.Enabled:=false;
    FDMemART.Close;
    FDMemArT.Open;
    with FMainActivity.FDQueryBuscar,SQL do
    begin
      Active :=  False;
      Clear;
      Add('select IFD.rowid ,ART.EXP_ART_NOMBRE,IFD.F_Captura,IFD.CANTIDAD FROM EXP_ARTICULOS art JOIN EXP_INVENTARIO_FISICO_DET IFD ON IFD.ARTICULO_CLAVE= art.EXP_ART_CODIGO WHERE ARTICULO_CLAVE='+Clave_Leida+' and Almacen ='+Almacen_id+' and U_CAPTURA='+''''+fMainActivity.USUARIO_NOMBRE+'''');
      close;
      Open;
      while not Eof do
      begin
        FDMemART.Append;
        (FDMemART.FieldByName('ID') as TStringField).AsString:= Fields[0].AsString;
        (FDMemART.FieldByName('Nombre') as TStringField).AsString:= Fields[1].AsString;
        (FDMemART.FieldByName('Fecha') as TStringField).AsString:= Fields[2].AsString;
        (FDMemART.FieldByName('Cantidad') as TStringField).AsString:= Fields[3].AsString;
        FDMemART.Post;
        Next;
      end;
    end;
    except
    on E:Exception do
    showmessage(E.Message);
  end;
end;

procedure TfEditarInventario.Llenar_Tabla_Linea;
begin
  try
    Timer1.Enabled:=false;
    FDMemARTLinea.Close;
    FDMemArTLinea.Open;
    with FMainActivity.FDQueryBuscar,SQL do
    begin
      Active :=  False;                                                                                                    //
      Clear;
      Add('select IFD.rowid ,ART.EXP_ART_NOMBRE,IFD.F_Captura,IFD.CANTIDAD FROM EXP_ARTICULOS art JOIN EXP_INVENTARIO_FISICO_DET IFD ON IFD.ARTICULO_CLAVE= art.EXP_ART_CODIGO WHERE EXP_LINEA_ART_NOMBRE='+ ''''+ComboBox2.Selected.Text +''''+ ' and Almacen ='+Almacen_id+' and U_CAPTURA='+''''+fMainActivity.USUARIO_NOMBRE+'''');
      close;
      Open;
      while not Eof do
      begin
        FDMemARTLinea.Append;
        (FDMemARTLinea.FieldByName('ID') as TStringField).AsString:= Fields[0].AsString;
        (FDMemARTLinea.FieldByName('Nombre') as TStringField).AsString:= Fields[1].AsString;
        (FDMemARTLinea.FieldByName('Fecha') as TStringField).AsString:= Fields[2].AsString;
        (FDMemARTLinea.FieldByName('Cantidad') as TStringField).AsString:= Fields[3].AsString;
        FDMemARTLinea.Post;
        Next;
      end;
    end;
    EditClave.Text:=('');
    except
    on E:Exception do
    showmessage(E.Message);
  end;
end;

procedure TfEditarInventario.Marcar_Como_Enviado;
begin
  try
    TimerSubir.Enabled:=false;
    with FMainActivity.FDQueryBorrar,SQL do
    begin
      clear;
      Add('Update  exp_inventario_fisico set Enviado=''S'' Where ALMACEN='+Almacen_ID);
      FMainActivity.FDQueryBorrar.ExecSQL();
    end;
    except
    on E:Exception do
    showmessage(E.Message);
  end;
end;

procedure TfEditarInventario.Marcar_Como_Enviado_Final;
begin
  try
    TimerSubir.Enabled:=false;
    with FMainActivity.FDQueryBorrar,SQL do
    begin
      clear;
      Add('Update  exp_inventario_fisico set Enviado_Fin=''S'' Where ALMACEN='+Almacen_ID);
      FMainActivity.FDQueryBorrar.ExecSQL();
    end;

    except
    on E:Exception do
    showmessage(E.Message);
  end;
end;

procedure TfEditarInventario.Mostrar_Fecha_Almacen;
begin
  try
    with fMainActivity.FDQueryBuscar,SQL do
    begin
      Active :=  False;
      Clear;
      Add('select EIF.fecha_hora_creacion,EIF.almacen from EXP_INVENTARIO_FISICO EIF join EXP_ALMACEN EA on EA.ALMACEN_ID=EIF.ALMACEN  where EA.NOMBRE='+''''+Combobox1.Selected.Text+''''+' and EIF.U_CAPTURA='+''''+fMainActivity.USUARIO_NOMBRE+'''');
      Close;
      Open;
      label6.Text:= ('Creación: '+Fields[0].AsString);
      Almacen_id:= (Fields[1].AsString);
    end;
   // BuscarAlmacenXNombre;
    except
    on E:exception do
    showmessage(e.Message);
  end;
end;

procedure TfEditarInventario.ObtenerLineas;
begin
  try
    with fMainActivity.FDQueryBuscar,SQL do
    begin
      Active :=  False;
      Clear;
      Add('select distinct ART.EXP_LINEA_ART_NOMBRE FROM EXP_ARTICULOS ART JOIN EXP_INVENTARIO_FISICO_DET IFD ON IFD.ARTICULO_CLAVE= art.EXP_ART_CODIGO WHERE ALMACEN ='+Almacen_id+' and U_CAPTURA='+''''+fMainActivity.USUARIO_NOMBRE+'''');
      Close;
      Open;
      while not eof do
      begin
        try
          begin
            ComboBox2.Items.Add(Fields[0].AsString);
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

procedure TfEditarInventario.Obtener_Inventarios;
begin
  try
    with fMainActivity.FDQueryBuscar,SQL do
    begin
      Active :=  False;
      Clear;
      Add('select NOMBRE from EXP_ALMACEN EA JOIN EXP_INVENTARIO_FISICO EIF ON EIF.ALMACEN=EA.ALMACEN_ID WHERE EIF.U_CAPTURA= '+''''+fMainActivity.USUARIO_NOMBRE+'''');
      Close;
      Open;
      while not eof do
      begin
        try
          begin
            ComboBox1.Items.Add(Fields[0].AsString);
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

procedure TfEditarInventario.Obtener_Total;
begin
  try
    FDMemART.Close;
    FDMemArT.Open;
    with FMainActivity.FDQueryBuscar,SQL do
    begin
      Active :=  False;
      Clear;
      Add('select sum (cantidad) from exp_inventario_fisico_det where ARTICULO_CLAVE='+CLAVE_LEIDA +' and Almacen ='+Almacen_id+' and U_CAPTURA='+''''+fMainActivity.USUARIO_NOMBRE+'''');
      close;
      Open;
      LabelCantidad.Text:= ('Cantidad de registros: '+Fields[0].AsString);
    end;

  except
    on E:Exception do
    showmessage(E.Message);
  end;
end;

procedure TfEditarInventario.SpeedButton55Click(Sender: TObject);
begin
  EditClave.Visible:=true;
  BtnAceptar.Visible:=true;
  SpeedButton3.Visible:=false;
  Enviar.Visible:=false;
  label5.Visible:=false;
  Speedbutton1.Visible:=false;
  btnBorrarInv.Visible:=false;
end;

procedure TfEditarInventario.SpeedButton1Click(Sender: TObject);
begin
  if Almacen_id <> ('')
  then
  begin
    if Contar_Registros then showmessage('Este almacén no contiene registros')
    else
      begin
      //Ocultar
      layout2.Visible:=false;
      layout1.Visible:=false;
      SpeedButton3.Visible:=false;
      Enviar.Visible:=false;
      Speedbutton1.Visible:=false;
      btnBorrarInv.Visible:=false;
      //Mostrar
      EditClave.Visible:=true;
      EditClave.SetFocus;
      BtnAceptar.Visible:=true;
    end
  end
  else showmessage('Seleccione un almacen');
end;

procedure TfEditarInventario.SpeedButton2Click(Sender: TObject);
begin
  if Almacen_ID.Equals('') then showmessage('Seleccione el inventario a enviar')
  else
  begin
    if  Ultimo_Almacen_Enviado.Equals(Combobox1.Selected.Text) then
    begin
      MessageDlg('Ya se subió este inventario, ¿Está seguro de volver a subirlo?', System.UITypes.TMsgDlgType.mtInformation,
      [
      System.UITypes.TMsgDlgBtn.mbOk,
      System.UITypes.TMsgDlgBtn.mbNo
      ], 0,
      procedure(const AResult: System.UITypes.TModalResult)
      begin
        case AResult of
          mrOk:
          begin
            Final:=True;
            Ultimo_Almacen_Enviado:=Combobox1.Selected.Text;
            fMainActivity.AnimacionSubida;
            fMainActivity.Timer1.Enabled:=true;
            fMainActivity.Timer:='Subir';
            TimerSubir.Enabled:=true;
          end;
          mrNo:
          fEditarInventario.Show;
        end;
      end);
      end

      else
      begin
      Final:=True;
      fMainActivity.AnimacionSubida;
      fMainActivity.Timer1.Enabled:=true;
      fMainActivity.Timer:='Subir';
      Ultimo_Almacen_Enviado:=Combobox1.Selected.Text;
      TimerSubir.Enabled:=true;
    end;

  end;
end;

procedure TfEditarInventario.SpeedButton3Click(Sender: TObject);
begin
  if Almacen_id <> ('')
  then
  begin
    if Contar_Registros then showmessage('Este almacén no contiene registros')
    else
    begin
      SpeedButton1.Visible:=false;
      layout2.Visible:=false;
      Layout1.Visible:=false;
      Enviar.Visible:=false;
      SpeedButton3.Visible:=false;
      layout3.Visible:=true;
      ObtenerLineas;
      btnBorrarInv.Visible:=false;
    end
  end
  else showmessage('Seleccione un almacen');
end;

procedure TfEditarInventario.EditarArticulLinea;
var
  Toast: TfgToast;
begin
  try
    with FMainActivity.FDQueryBorrar,SQL do
    begin
      clear;
      //Add('Delete from exp_inventario_fisico_det where rowid='+IDROW_SELECCIONADO);
      Add('Update exp_inventario_fisico_det set Cantidad='+EditCantidadLinea.Text+' where rowid='+IDROW_SELECCIONADO);
      FMainActivity.FDQueryBorrar.ExecSQL();
      Toast := TfgToast.Create('Registro editado', TfgToastDuration(Long));
      Toast.Icon:=FMainActivity.Logo.Bitmap;
      Toast.MessageColor := $FF000000;
      Toast.BackgroundColor :=  $FFFFFF ;
      Toast.Show;
      Toast.Free;
    end;
    Llenar_Tabla_Linea;
    except
    on E:Exception do
    showmessage(E.Message);
  end;
end;

procedure TfEditarInventario.EditarArticulo;
var
  Toast: TfgToast;
begin
   try
      with FMainActivity.FDQueryBorrar,SQL do
      begin
        clear;
        //Add('Delete from exp_inventario_fisico_det where rowid='+IDROW_SELECCIONADO);
        Add('Update exp_inventario_fisico_det set Cantidad='+EditCantidad.Text+' where rowid='+IDROW_SELECCIONADO);
        FMainActivity.FDQueryBorrar.ExecSQL();
        Obtener_Total;
        Timer1.Enabled:=true;
        Toast := TfgToast.Create('Registro editado', TfgToastDuration(Long));
        Toast.Icon:=FMainActivity.Logo.Bitmap;
        Toast.MessageColor := $FF000000;
        Toast.BackgroundColor :=  $FFFFFF ;
        Toast.Show;
        Toast.Free;
       // Almacen_Id:= Fields[1].AsString;
      end;

    except
      on E:Exception do
        showmessage(E.Message);
    end;
end;

procedure TfEditarInventario.EnviarClick(Sender: TObject);

begin
  if Almacen_ID.Equals('') then showmessage('Seleccione el inventario a enviar')
  else
  begin
    if Contar_Registros then
    begin
      MessageDlg('Este almacen no contiene ningun registro, ¿Está seguro de subirlo?', System.UITypes.TMsgDlgType.mtInformation,
      [
      System.UITypes.TMsgDlgBtn.mbOk,
      System.UITypes.TMsgDlgBtn.mbNo
      ], 0,
      procedure(const AResult: System.UITypes.TModalResult)
      begin
        case AResult of
          mrOk:
          begin
            if  Label5.Text.Equals('Este inventario ya se envió') then
            begin
              MessageDlg('Ya se subió este inventario, ¿Está seguro de volver a subirlo?', System.UITypes.TMsgDlgType.mtInformation,
              [
              System.UITypes.TMsgDlgBtn.mbOk,
              System.UITypes.TMsgDlgBtn.mbNo
              ], 0,
              procedure(const AResult: System.UITypes.TModalResult)
              begin
                case AResult of
                  mrOk:
                  begin
                    Vacio:='S';
                    Final:=false;
                    Ultimo_Almacen_Enviado:=Combobox1.Selected.Text;
                    fMainActivity.AnimacionSubida;
                    fMainActivity.Timer1.Enabled:=true;
                    fMainActivity.Timer:='Subir';
                    TimerSubir.Enabled:=true;
                    end;
                  mrNo:
                  fEditarInventario.Show;
                end;
              end);
            end

            else
            begin
              Vacio:='S';
              Final:=false;
              fMainActivity.AnimacionSubida;
              fMainActivity.Timer1.Enabled:=true;
              fMainActivity.Timer:='Subir';
              Ultimo_Almacen_Enviado:=Combobox1.Selected.Text;
              TimerSubir.Enabled:=true;
              Mostrar_Fecha_Almacen;
            end;
          end;
          mrNo:
          fEditarInventario.Show;
        end;
      end);
      end
      else
      begin
      if  Label5.Text.Equals('Este inventario ya se envió') then
      begin
        MessageDlg('Ya se subió este inventario, ¿Está seguro de volver a subirlo?', System.UITypes.TMsgDlgType.mtInformation,
        [
        System.UITypes.TMsgDlgBtn.mbOk,
        System.UITypes.TMsgDlgBtn.mbNo
        ], 0,
        procedure(const AResult: System.UITypes.TModalResult)
        begin
          case AResult of
            mrOk:
            begin
              Vacio:='N';
              Final:=false;
              Ultimo_Almacen_Enviado:=Combobox1.Selected.Text;
              fMainActivity.AnimacionSubida;
              fMainActivity.Timer1.Enabled:=true;
              fMainActivity.Timer:='Subir';
              TimerSubir.Enabled:=true;
            end;
            mrNo:
            fEditarInventario.Show;
          end;
        end);
        end
        else
        begin
        Vacio:='N';
        Final:=false;
        fMainActivity.AnimacionSubida;
        fMainActivity.Timer1.Enabled:=true;
        fMainActivity.Timer:='Subir';
        Ultimo_Almacen_Enviado:=Combobox1.Selected.Text;
        TimerSubir.Enabled:=true;
        Mostrar_Fecha_Almacen;
      end;
    end;




  end;
end;



procedure TfEditarInventario.BorrarArticulo;
begin
  try
    with FMainActivity.FDQueryBorrar,SQL do
    begin
      clear;
      Add('Delete from exp_inventario_fisico_det where rowid='+IDROW_SELECCIONADO);
      FMainActivity.FDQueryBorrar.ExecSQL();
      Obtener_Total;
      Timer1.Enabled:=true;
    end;
    except
    on E:Exception do
    showmessage(E.Message);
  end;
end;

procedure TfEditarInventario.BorrarArticuloLinea;
begin
  try
    with FMainActivity.FDQueryBorrar,SQL do
    begin
      clear;
      Add('Delete from exp_inventario_fisico_det where rowid='+IDROW_SELECCIONADO);
      FMainActivity.FDQueryBorrar.ExecSQL();
      //Obtener_Total;
      Llenar_Tabla_Linea;
      // Almacen_Id:= Fields[1].AsString;
    end;

    except
    on E:Exception do
    showmessage(E.Message);
  end;
end;

procedure TfEditarInventario.BorrarInventario;
begin
  try
    with FMainActivity.FDQueryBorrar,SQL do
    begin
      clear;
      Add('Delete from exp_inventario_fisico_det where Almacen= '+Almacen_ID+' AND U_CAPTURA='+''''+fMainActivity.USUARIO_NOMBRE+'''');
      FMainActivity.FDQueryBorrar.ExecSQL();
      clear;
      Add('Delete from exp_inventario_fisico where  Almacen= '+Almacen_ID+' AND U_CAPTURA='+''''+fMainActivity.USUARIO_NOMBRE+'''');
      FMainActivity.FDQueryBorrar.ExecSQL();
    end;
    Showmessage('Inventario Eliminado');
    except
    on E:Exception do
    showmessage(E.Message);
  end;
end;

procedure TfEditarInventario.BtnAceptarClick(Sender: TObject);
begin
  if EditClave.Text.Equals('') then showmessage('Ingresa o escanea una clave') else
  begin
    Layout5.Visible:=true;
    Clave_Leida:=Editclave.Text;
    LabelCantidad.Visible:=true;
    StringGrid1.Visible:=true;
    Obtener_Total;
    Timer1.Enabled:=true;
  end;
end;

procedure TfEditarInventario.btnBorrarClick(Sender: TObject);
var
  Toast: TfgToast;
begin
  begin
    MessageDlg('¿Está seguro de eliminar el registro?', System.UITypes.TMsgDlgType.mtInformation,
    [
    System.UITypes.TMsgDlgBtn.mbOk,
    System.UITypes.TMsgDlgBtn.mbNo
    ], 0,
    procedure(const AResult: System.UITypes.TModalResult)
    begin
      case AResult of
        mrOk:
        begin
          BorrarArticulo;
          Obtener_Total;
          Toast := TfgToast.Create('Registro eliminado', TfgToastDuration(Long));
          Toast.Icon:=FMainActivity.Logo.Bitmap;
          Toast.MessageColor := $FF000000;
          Toast.BackgroundColor :=  $FFFFFF ;
          Toast.Show;
          Toast.Free;
        end;
        mrNo:

      end;
    end);
  end;
end;

procedure TfEditarInventario.StringGrid1CellClick(const Column: TColumn;
  const Row: Integer);
begin
  btnEditar.Visible:=true;
  EditCantidad.Visible:=true;
  btnEditar.Visible:=true;
  btnBorrar.Visible:=true;
  IDROW_SELECCIONADO:=FDMemART.FieldByName('ID').AsString;
end;

procedure TfEditarInventario.StringGrid2CellClick(const Column: TColumn;
  const Row: Integer);
begin
  btnEditar.Visible:=true;
  EditCantidadLinea.Visible:=true;
  BtnBorrarLinea.Visible:=true;
  IDROW_SELECCIONADO:=FDMemARTlinea.FieldByName('ID').AsString;
end;

procedure TfEditarInventario.Timer1Timer(Sender: TObject);
begin
  Llenar_Tabla;
end;

procedure TfEditarInventario.TimerSubirTimer(Sender: TObject);
begin
   Checar_Enviado;
   if Enviado.Equals('S') then Label5.Text:=('Este inventario ya se envió') else Label5.Text:=('Este inventario no ha sido enviado');
end;

end.

