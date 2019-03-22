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
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FMX.ListBox, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components,
  Data.Bind.DBScope, Data.Bind.Grid, FMX.DateTimeCtrls, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FMX.Objects,System.IOUtils;

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
    StringGridTrabajos: TStringGrid;
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
    FechaTrabajos: TDateEdit;
    ComboEmpleado: TComboBox;
    FechaLista: TDateEdit;
    StringGridLista: TStringGrid;
    ComboEmpleadosLista: TComboBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    ListView1: TListView;
    FDQuery1: TFDQuery;
    FDMemFilaTrabajo: TFDMemTable;
    FDMemTrabajos: TFDMemTable;
    FDMemTrabajosDescripcion: TStringField;
    BindSourceDB3: TBindSourceDB;
    LinkGridToDataSourceBindSourceDB3: TLinkGridToDataSource;
    FDMemFilaTrabajoTrabajo: TStringField;
    FDMemFilaTrabajoCantidad: TIntegerField;
    BindSourceDB4: TBindSourceDB;
    LinkGridToDataSourceBindSourceDB4: TLinkGridToDataSource;
    logoVirma: TImage;
    FDMemTrabajosPrecio: TStringField;
    FDMemTrabajosFolio: TIntegerField;
    FDMemTrabajosCantidad: TIntegerField;
    LinkListControlToField1: TLinkListControlToField;
    FDMemLista: TFDMemTable;
    FDMemTable1Trabajo: TStringField;
    FDMemTable1Informacion: TStringField;
    FDMemTable1Tiempo: TStringField;
    BindSourceDB2: TBindSourceDB;
    procedure GestureDone(Sender: TObject; const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure ConexionBeforeConnect(Sender: TObject);
    procedure ConexionAfterConnect(Sender: TObject);
    procedure btnLineaClick(Sender: TObject);
    procedure btnArticulosClick(Sender: TObject);
    procedure LlenarTabla;
    procedure LlenarLista;
    procedure ObtenerLineas;
    procedure ObtenerEmpleadosTrabajo;
    //Lista
    procedure ObtenerLista;
    procedure ObtenerEmpleadosLista;
    procedure InsertarTrabajo;
    procedure InsertarLista;
    procedure SumarLista;
    procedure RestarLista;
    procedure BuscarLista;
    procedure ComboBoxLineaChange(Sender: TObject);
    //Otro
    procedure TimerPresentacionTimer(Sender: TObject);
    procedure StringGrid2CellClick(const Column: TColumn; const Row: Integer);
    procedure Button1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure ComboEmpleadoChange(Sender: TObject);
    procedure btnIngresarClick(Sender: TObject);
    procedure ObtenerFilaTrabajos;
    procedure ObtenerTrabajos;
    procedure DateEdit2Change(Sender: TObject);
    procedure ComboEmpleadosListaChange(Sender: TObject);
    procedure FechaTrabajosChange(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FechaListaChange(Sender: TObject);
  private
   Hoy :TDateTime;
   ComboEmpSelected:Boolean;
   ComboEmpListaSelected:Boolean;
    { Private declarations }
  public
  IDROW_SELECCIONADO:string;
  S:String;//La cantidad que regresa
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses
  Linea, Articulos, Presentacion, Funciones_Android;

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
    ObtenerTrabajos;
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

procedure TMainForm.BuscarLista;
begin
   try
    with FDQueryBuscar,SQL do
    begin
      ComboBoxLinea.Clear;
      Active:=False;
      Clear;
      Add('Select Cantidad from Lista where Empleado=:Empleado and Fecha=:Fecha');
      Params[0].AsString:=ComboEmpleadosLista.Selected.Text;
      Params[1].AsString:=Fechalista.Data.ToString;
      Close;
      Open;
      S:=Fields[0].AsString;
    end;
    except
    on E:exception do
    showmessage(e.Message);
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
   ObtenerTrabajos;
end;

procedure TMainForm.ComboEmpleadosListaChange(Sender: TObject);
begin
  ComboEmpListaSelected:=True;
  ObtenerLista;
end;

//Crea las tablas en la inicializacion
procedure TMainForm.ConexionAfterConnect(Sender: TObject);
begin
  Conexion.ExecSQL('CREATE TABLE IF NOT EXISTS ARTICULO(NOMBRE TEXT NOT NULL,LINEA TEXT NOT NULL,CANTIDAD TEXT NOT NULL,COSTO TEXT,PUBLICO TEXT,MAYOREO TEXT,BOLERO TEXT,ESPECIAL TEXT,P_PUBLICO TEXT,P_MAYOREO TEXT,P_BOLERO TEXT, P_ESPECIAL TEXT)');
  Conexion.ExecSQL('CREATE TABLE IF NOT EXISTS Linea(Nombre TEXT NOT NULL)');
  Conexion.ExecSQL('CREATE TABLE IF NOT EXISTS Empleado(Nombre TEXT,Ganancia TEXT)');
  Conexion.ExecSQL('CREATE TABLE IF NOT EXISTS Reparacion(Empleado TEXT,Folio INTEGER,Precio TEXT,Cantidad INTEGER,Descripcion TEXT,Fecha TEXT,Fecha_Hora TEXT)');
  Conexion.ExecSQL('CREATE TABLE IF NOT EXISTS Trabajo(Trabajo TEXT,Informacion TEXT,Tiempo INTEGER)');
  Conexion.ExecSQL('CREATE TABLE IF NOT EXISTS Lista(Trabajo TEXT,Empleado TEXT,Cantidad TEXT,Fecha DATE)');
 end;
//Antes de conectar identifica la base de datos
procedure TMainForm.ConexionBeforeConnect(Sender: TObject);
begin
  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  Conexion.Params.Values['Database'] :=
  TPath.Combine(TPath.GetDocumentsPath, 'Virmariza.s3db');
  {$ENDIF}
end;

procedure TMainForm.DateEdit2Change(Sender: TObject);
begin
  ObtenerTrabajos;
end;

procedure TMainForm.FechaListaChange(Sender: TObject);
begin
   if ComboEmpListaSelected then  ObtenerLista;
end;

procedure TMainForm.FechaTrabajosChange(Sender: TObject);
begin
  if ComboEmpSelected then   ObtenerTrabajos;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
Fecha:string;
begin
  Hoy:=Now;
  { This defines the default active tab at runtime }
  TabControl1.ActiveTab := TabItem1;
  ObtenerLineas;
  Fecha:=(formatdatetime('d/m/y', Hoy));
  FechaLista.Date:=Hoy;
  FechaTrabajos.Date:=Hoy;
  ObtenerEmpleadosLista;
  ObtenerEmpleadosTrabajo;
  ObtenerLista;
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
Procedure TMainForm.InsertarLista;
var
Fecha:TDateTime;
begin
   try
    FDMemART.Close;
    FDMemArT.Open;
    with FDQueryBuscar,SQL do
    begin
      Fecha:=strtodate(Fechalista.Data.ToString);
      Active :=  False;
      Clear;
      Add('Insert into Linea(Trabajo,Empleado,Cantidad,Fecha) values (:Trabajo,:Empleado,:Cantidad,:Fecha)');
      Params[0].AsString:=TListViewItem(ListView1.Selected).Text;
      Params[1].AsString:=ComboEmpleadosLista.Selected.Text;
      Params[2].AsString:='1';
      Params[3].AsString:=StrFechaAndroid(Fecha);
      FDQueryInsertar.ExecSQL
    end;
   // Result:=True;
    except
    on E:Exception do
    begin
      showmessage(E.Message);
     // Result:=False;
    end;
  end;
end;

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
//Llena la lista de trabajos
procedure TMainForm.LlenarLista;
begin
  try
    FDMemLista.Close;
    FDMemLista.Open;
    with FDQueryBuscar,SQL do
    begin
      Active :=  False;
      Clear;
      Add('Select Nombre,Informacion,Tiempo from Trabajo');
      close;
      Open;
      while not Eof do
      begin
        FDMemLista.Append;
        (FDMemLista.FieldByName('Nombre') as TIntegerField).AsInteger:= Fields[0].AsInteger;
        (FDMemLista.FieldByName('Informacion') as TStringField).AsString:= Fields[1].AsString;
        (FDMemLista.FieldByName('Tiempo') as TStringField).AsString:= Fields[2].AsString;
         FDMemLista.Post;
        Next;
      end;
    end;
    except
    on E:Exception do
    showmessage(E.Message);
  end;
end;

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
procedure TMainForm.ObtenerEmpleadosLista;
begin
   try
    with MainForm.FDQueryBuscar,SQL do
    begin
      ComboEmpleado.Clear;
      Active :=  False;
      Clear;
      Add('Select Nombre From Empleado');
      Close;
      Open;
      while not eof do
      begin
        try
          begin
            ComboEmpleadosLista.Items.Add(Fields[0].AsString);
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

procedure TMainForm.ObtenerEmpleadosTrabajo;
begin
   try
    with MainForm.FDQueryBuscar,SQL do
    begin
      ComboEmpleado.Clear;
      Active :=  False;
      Clear;
      Add('Select Nombre From Empleado');
      Close;
      Open;
      while not eof do
      begin
        try
          begin
            ComboEmpleado.Items.Add(Fields[0].AsString);
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

procedure TMainForm.ObtenerFilaTrabajos;
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
procedure TMainForm.ObtenerLista;
begin
  try
    FDMemART.Close;
    FDMemArT.Open;
    with FDQueryBuscar,SQL do
    begin
      Active :=  False;
      Clear;
      Add('Select Trabajo,Cantidad from Lista where Empleado=:Empleado and Fecha=:Fecha');
      Params[0].AsString:=ComboBoxLinea.Selected.Text;
      Params[1].AsString:=Fechalista.Data.ToString;;
      close;
      Open;
      while not Eof do
      begin
        FDMemART.Append;
        (FDMemART.FieldByName('Trabajo') as TIntegerField).AsInteger:= Fields[0].AsInteger;
        (FDMemART.FieldByName('Cantidad') as TStringField).AsString:= Fields[1].AsString;
        FDMemART.Post;
        Next;
      end;
    end;
    except
    on E:Exception do
    showmessage(E.Message);
  end;
end;

procedure TMainForm.ObtenerTrabajos;
begin
  try
    FDMemTrabajos.Close;
    FDMemTrabajos.Open;
    with FDQueryBuscar,SQL do
    begin
      Active :=  False;
      Clear;
      Add('Select Folio,Precio,Descripcion,Cantidad from Reparacion where Empleado=:Empleado and Fecha=:Fecha');
      Params[0].AsString:=ComboEmpleado.Selected.Text;
      Params[1].AsString:=FechaTrabajos.Data.ToString;
      close;
      Open;
      while not Eof do
      begin
        FDMemTrabajos.Append;
        (FDMemTrabajos.FieldByName('Folio') as TIntegerField).AsInteger:= Fields[0].AsInteger;
        (FDMemTrabajos.FieldByName('Precio') as TStringField).AsString:= Fields[1].AsString;
        (FDMemTrabajos.FieldByName('Descripcion') as TStringField).AsString:= Fields[2].AsString;
        (FDMemTrabajos.FieldByName('Cantidad') as TIntegerField).AsInteger:= Fields[3].AsInteger;
        FDMemTrabajos.Post;
        Next;
      end;
    end;
    except
    on E:Exception do
    showmessage(E.Message);
  end;
end;

procedure TMainForm.RestarLista;
begin
    try
    FDMemART.Close;
    FDMemArT.Open;
    with FDQueryBuscar,SQL do
    begin
      Active :=  False;
      Clear;
      Add('Update Lista set Cantidad=Cantidad -1 where Empleado=:Empleado and Fecha=:Fecha ');
      Params[0].AsString:=ComboEmpleadosLista.Selected.Text;
      Params[1].AsString:=Fechalista.Data.ToString;
      FDQueryInsertar.ExecSQL
    end;
   // Result:=True;
    except
    on E:Exception do
    begin
      showmessage(E.Message);
     // Result:=False;
    end;
  end;
end;

//Acciones realizadas al momento de oprimir una celda en el grid
procedure TMainForm.SpeedButton1Click(Sender: TObject);
begin
 if ComboEmpListaSelected then
 begin
  BuscarLista;
  if S.Equals('') then InsertarLista
  else SumarLista;
  ObtenerLista;
 end
 else ShowMessage('Seleccione un empleado');
end;

procedure TMainForm.SpeedButton2Click(Sender: TObject);
begin
  if ComboEmpListaSelected then
 begin
  BuscarLista;
  if S.Equals('') then InsertarLista
  else RestarLista;
  ObtenerLista;
 end
 else ShowMessage('Seleccione un empleado');
end;

procedure TMainForm.StringGrid2CellClick(const Column: TColumn;
  const Row: Integer);
begin
  IDROW_SELECCIONADO:=FDMemART.FieldByName('ID').AsString;
end;
procedure TMainForm.SumarLista;
begin
    try
    FDMemART.Close;
    FDMemArT.Open;
    with FDQueryBuscar,SQL do
    begin
      Active :=  False;
      Clear;
      Add('Update Lista set Cantidad=Cantidad +1 where Empleado=:Empleado and Fecha=:Fecha ');
      Params[0].AsString:=ComboEmpleadosLista.Selected.Text;
      Params[1].AsString:=Fechalista.Data.ToString;
      FDQueryInsertar.ExecSQL
    end;
   // Result:=True;
    except
    on E:Exception do
    begin
      showmessage(E.Message);
     // Result:=False;
    end;
  end;
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


