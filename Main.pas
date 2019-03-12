unit Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl, FMX.StdCtrls, FMX.Controls.Presentation,
  FMX.Gestures, System.Actions, FMX.ActnList, System.Rtti, FMX.Grid.Style,
  FMX.ScrollBox, FMX.Grid, FMX.Edit, FMX.Layouts, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.FMXUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,System.IOUtils,
  FMX.ListBox, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components,
  Data.Bind.DBScope, Data.Bind.Grid, FMX.DateTimeCtrls, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView;

type
  TMainForm = class(TForm)
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    TabItem4: TTabItem;
    GestureManager1: TGestureManager;
    ActionList1: TActionList;
    NextTabAction1: TNextTabAction;
    PreviousTabAction1: TPreviousTabAction;
    LayoutIngresar: TLayout;
    EditFolio: TEdit;
    EditPrecio: TEdit;
    editCantidad: TEdit;
    btnIngresar: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Cantidad: TLabel;
    StringGrid1: TStringGrid;
    Layout1: TLayout;
    EditDesc: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    btnLinea: TSpeedButton;
    btnEmpleado: TSpeedButton;
    btnArticulos: TSpeedButton;
    Conexion: TFDConnection;
    FDQueryBuscar: TFDQuery;
    FDQueryInsertar: TFDQuery;
    FDQueryActualizar: TFDQuery;
    FdMemArt: TFDMemTable;
    FdMemArtID: TIntegerField;
    FdMemArtNombre: TStringField;
    FdMemArtUnidadMedida: TStringField;
    ComboBoxLinea: TComboBox;
    BindingsList1: TBindingsList;
    BindSourceDB1: TBindSourceDB;
    StringGrid2: TStringGrid;
    LinkGridToDataSourceBindSourceDB12: TLinkGridToDataSource;
    FdMemArtCosto: TStringField;
    FdMemArtPrecio: TStringField;
    FdMemArtMayoreo: TStringField;
    FdMemArtBolero: TStringField;
    FdMemArtEspecial: TStringField;
    FdMemArtP_Precio: TStringField;
    FdMemArtP_Mayoreo: TStringField;
    FdMemArtP_Bolero: TStringField;
    FdMemArtP_Especial: TStringField;
    TimerPresentacion: TTimer;
    Layout2: TLayout;
    Label5: TLabel;
    DateEdit1: TDateEdit;
    Button1: TButton;
    DateEdit2: TDateEdit;
    ComboEmpleado: TComboBox;
    DateEdit3: TDateEdit;
    StringGrid3: TStringGrid;
    ComboBox1: TComboBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    ListView1: TListView;
    BindSourceDB2: TBindSourceDB;
    FDQuery1: TFDQuery;
    LinkFillControlToFieldTrabajo: TLinkFillControlToField;
    procedure GestureDone(Sender: TObject; const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure ConexionBeforeConnect(Sender: TObject);
    procedure ConexionAfterConnect(Sender: TObject);
    procedure btnLineaClick(Sender: TObject);
    procedure btnArticulosClick(Sender: TObject);
    procedure LlenarTabla;
    procedure ObtenerLineas;
    procedure InsertarTrabajo;
    procedure ComboBoxLineaChange(Sender: TObject);
    procedure TimerPresentacionTimer(Sender: TObject);
    procedure StringGrid2CellClick(const Column: TColumn; const Row: Integer);
    procedure Button1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure ComboEmpleadoChange(Sender: TObject);
    procedure btnIngresarClick(Sender: TObject);
  private
   Hoy :TDateTime;
   ComboEmpSelected:Boolean;
    { Private declarations }
  public
  IDROW_SELECCIONADO:string;
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses
  Linea, Articulos, Presentacion;

{$R *.fmx}
{$R *.LgXhdpiTb.fmx ANDROID}

procedure TMainForm.btnArticulosClick(Sender: TObject);
begin
  fArticulos:=TfArticulos.Create(nil);
  try
    fArticulos.Show;
  finally
    fArticulos.Free;
  end;
end;

procedure TMainForm.btnIngresarClick(Sender: TObject);
begin
  if ComboEmpSelected then
  begin
    if (EditFolio.Text.Equals('') and EditDesc.Text.Equals('')) or EditPrecio.Text.Equals('') or editCantidad.Text.Equals('') then
    ShowMessage('Debe ingresar un folio o descripcion del trabajo,con su respectivo precio y cantidad') else
    InsertarTrabajo;
  end
  else ShowMessage('Debe seleccionar un empleado');
end;

procedure TMainForm.btnLineaClick(Sender: TObject);
begin
  Lineas:=TLineas.Create(nil);
  try
    Lineas.Show;
  finally
    Lineas.Free;
  end;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  ShowMessage( DateEdit1.Data.ToString);
end;

procedure TMainForm.ComboBoxLineaChange(Sender: TObject);
begin
   LlenarTabla;
end;
 procedure TMainForm.ComboEmpleadoChange(Sender: TObject);
begin
   ComboEmpSelected:=True;
end;

//Crea las tablas en la inicializacion
procedure TMainForm.ConexionAfterConnect(Sender: TObject);
begin
  Conexion.ExecSQL('CREATE TABLE IF NOT EXISTS ARTICULO(NOMBRE TEXT NOT NULL,LINEA TEXT NOT NULL,CANTIDAD TEXT NOT NULL,COSTO TEXT,PUBLICO TEXT,MAYOREO TEXT,BOLERO TEXT,ESPECIAL TEXT,P_PUBLICO TEXT,P_MAYOREO TEXT,P_BOLERO TEXT, P_ESPECIAL TEXT)');
  Conexion.ExecSQL('CREATE TABLE IF NOT EXISTS Linea(Nombre TEXT NOT NULL)');
  Conexion.ExecSQL('CREATE TABLE IF NOT EXISTS Empleado(Nombre TEXT,Ganancia TEXT)');
  Conexion.ExecSQL('CREATE TABLE IF NOT EXISTS Reparacion(Empleado TEXT,Folio INTEGER,Precio TEXT,Cantidad INTEGER,Descripcion TEXT,Fecha TEXT,Fecha_Hora TEXT)');
  Conexion.ExecSQL('CREATE TABLE IF NOT EXISTS Trabajo(Trabajo TEXT,Informacion TEXT)')
  end;
//Antes de conectar identifica la base de datos
procedure TMainForm.ConexionBeforeConnect(Sender: TObject);
begin
  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  Conexion.Params.Values['Database'] :=
  TPath.Combine(TPath.GetDocumentsPath, 'Virmariza.s3db');
  {$ENDIF}
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  { This defines the default active tab at runtime }
  TabControl1.ActiveTab := TabItem1;
  ObtenerLineas;
end;

procedure TMainForm.GestureDone(Sender: TObject; const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  case EventInfo.GestureID of
    sgiLeft:
      begin
        if TabControl1.ActiveTab <> TabControl1.Tabs[TabControl1.TabCount - 1] then
          TabControl1.ActiveTab := TabControl1.Tabs[TabControl1.TabIndex + 1];
        Handled := True;
      end;

    sgiRight:
      begin
        if TabControl1.ActiveTab <> TabControl1.Tabs[0] then
          TabControl1.ActiveTab := TabControl1.Tabs[TabControl1.TabIndex - 1];
        Handled := True;
      end;
  end;
end;
//Pendiente
procedure TMainForm.InsertarTrabajo;
var
Folio:Integer;
Fecha,Fecha_Hora:string;
Empleado:string;
begin
      try
    with FDQueryInsertar,SQL do
    begin
      Clear;
      Add('Select Folio,Fecha,Empleado from Reparacion where Folio='+''''+EditFolio.Text+'''');
      Close;
      Open;
      Folio:=(Fields[0].AsInteger);
      Fecha:=(Fields[1].AsString);
      Empleado:=(Fields[2].AsString);
      if Folio=0 then
      begin
        Hoy:=Now;
        Fecha:=(formatdatetime('d/m/y', Hoy));
        Fecha_Hora:=((formatdatetime('d/m/y', Hoy))+(FormatDATETime(' hh:mm', Hoy)));
        Clear;
        Add('Insert into Reparacion  ');
        Add('(Cantidad,Descripcion,Empleado,Fecha,Fecha_Hora,Folio,Precio)');
        Add(' values (:Cantidad,:Descripcion,:Empleado,:Fecha,:Fecha_Hora,:Folio,:Precio)');
        Params[0].AsString:=editCantidad.Text;
        Params[1].AsString:=editDesc.Text;
        Params[2].AsString:=ComboEmpleado.Selected.Text;
        Params[3].AsString:=Fecha;
        Params[4].AsString:=Fecha_Hora;
        Params[5].AsString:=EditFolio.Text;
        Params[6].AsString:=EditPrecio.Text;
        FDQueryInsertar.ExecSQL
      end
      else
      begin
        MessageDlg('Ya existe un registro con el mismo folio del empleado '+Empleado+' ingresado  el '+Fecha+' ¿Desea insertarlo igualmente? ', System.UITypes.TMsgDlgType.mtInformation,
        [System.UITypes.TMsgDlgBtn.mbOK,System.UITypes.TMsgDlgBtn.mbNo], 0, procedure(const AResult: System.UITypes.TModalResult)
        begin
          case AResult of
            mrOk:
            begin
              Hoy:=Now;
              Fecha:=(formatdatetime('d/m/y', Hoy));
              Fecha_Hora:=((formatdatetime('d/m/y', Hoy))+(FormatDATETime(' hh:mm', Hoy)));
              Clear;
              Add('Insert into Reparacion  ');
              Add('(Cantidad,Descripcion,Empleado,Fecha,Fecha_Hora,Folio,Precio)');
              Add(' values (:Cantidad,:Descripcion,:Empleado,:Fecha,:Fecha_Hora,:Folio,:Precio)');
              Params[0].AsString:=editCantidad.Text;
              Params[1].AsString:=editDesc.Text;
              Params[2].AsString:=ComboEmpleado.Selected.Text;
              Params[3].AsString:=Fecha;
              Params[4].AsString:=Fecha_Hora;
              Params[5].AsString:=EditFolio.Text;
              Params[6].AsString:=EditPrecio.Text;
              FDQueryInsertar.ExecSQL
            end;
            mrNo:
          end;
        end);
      end;
    end;
  except
    on E:exception do
      ShowMessage('No se pudo insertar el artículo '+e.Message);
  end;
end;
//Llena la tabla de articulos con base con base a la linea seleccionada
procedure TMainForm.LlenarTabla;
begin
 try
    FDMemART.Close;
    FDMemArT.Open;
    with FDQueryBuscar,SQL do
    begin
      Active :=  False;
      Clear;
      Add('Select rowid,Nombre,Cantidad,Costo,Publico,Mayoreo,Bolero,Especial,P_Publico,P_Mayoreo,P_Bolero,P_Especial from Articulo where Linea='+''''+ComboBoxLinea.Selected.Text+'''');
      close;
      Open;
      while not Eof do
      begin
        FDMemART.Append;
        (FDMemART.FieldByName('ID') as TIntegerField).AsInteger:= Fields[0].AsInteger;
        (FDMemART.FieldByName('Nombre') as TStringField).AsString:= Fields[1].AsString;
        (FDMemART.FieldByName('Unidad Medida') as TStringField).AsString:= Fields[2].AsString;
        (FDMemART.FieldByName('Costo') as TStringField).AsString:= Fields[3].AsString;
        (FDMemART.FieldByName('Precio') as TStringField).AsString:= Fields[4].AsString;
        (FDMemART.FieldByName('Mayoreo') as TStringField).AsString:= Fields[5].AsString;
        (FDMemART.FieldByName('Bolero') as TStringField).AsString:= Fields[6].AsString;
        (FDMemART.FieldByName('Especial') as TStringField).AsString:= Fields[7].AsString;
        (FDMemART.FieldByName('P_Precio') as TStringField).AsString:= Fields[8].AsString;
        (FDMemART.FieldByName('P_Mayoreo') as TStringField).AsString:= Fields[9].AsString;
        (FDMemART.FieldByName('P_Bolero') as TStringField).AsString:= Fields[10].AsString;
        (FDMemART.FieldByName('P_Especial') as TStringField).AsString:= Fields[11].AsString;

        FDMemART.Post;
        Next;
      end;
    end;
    except
    on E:Exception do
    showmessage(E.Message);
  end;
end;
//Obtiene las lineas y las agrega en el combobox
procedure TMainForm.ObtenerLineas;
begin
    try
    with FDQueryBuscar,SQL do
    begin
      ComboBoxLinea.Clear;
      Active :=  False;
      Clear;
      Add('Select Nombre From Linea');
      Close;
      Open;
      while not eof do
      begin
        try
          begin
            ComboBoxLinea.Items.Add(Fields[0].AsString);
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
//Acciones realizadas al momento de oprimir una celda en el grid
procedure TMainForm.SpeedButton1Click(Sender: TObject);
begin
 ShowMessage(TListViewItem(ListView1.Selected).Text);
end;

procedure TMainForm.SpeedButton2Click(Sender: TObject);
var
Fecha:string;
begin
  Hoy:=Now;
  Fecha:=(formatdatetime('d/m/y', Hoy));
  ShowMessage(Fecha);
end;

procedure TMainForm.StringGrid2CellClick(const Column: TColumn;
  const Row: Integer);
begin
  IDROW_SELECCIONADO:=FDMemART.FieldByName('ID').AsString;
end;
//Abre la forma de la presentacion de la empresa
procedure TMainForm.TimerPresentacionTimer(Sender: TObject);
begin
  fPresentacion:=TfPresentacion.Create(nil);
  try
    fPresentacion.Show;
  finally
    fPresentacion.Free;
  end;
end;

end.


