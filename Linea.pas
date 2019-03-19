unit Linea;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ListBox,
  FMX.StdCtrls, FMX.Layouts, FMX.Edit, FMX.Controls.Presentation;

type
  TLineas = class(TForm)
    ToolBar1: TToolBar;
    EditLinea: TEdit;
    Layout1: TLayout;
    btnGuardarLinea: TButton;
    ComboLinea: TComboBox;
    BtnBorrarLinea: TButton;
    LayoutLinea: TLayout;
    LayoutEmp: TLayout;
    Layout3: TLayout;
    EditEmp: TEdit;
    BtnGuardarEmp: TButton;
    ComboEmpleado: TComboBox;
    BtnBorrarEmp: TButton;
    EdtGanancia: TEdit;
    Layout2: TLayout;
    Layout4: TLayout;
    EdtTrabajo: TEdit;
    BtnGuardarTrabajo: TButton;
    BtnBorrarTrabajo: TButton;
    ComboTrabajo: TComboBox;
    EdtInfo: TEdit;
    procedure InsertarLinea;
    procedure InsertarEmpleado;
    procedure InsertarTrabajo;
    procedure BorrarEmpleado;
    procedure BorrarLinea;
    procedure BorrarTrabajo;
    procedure BuscarLinea;
    procedure BuscarEmp;
    procedure BuscarTrabajo;
    procedure btnGuardarLineaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnBorrarLineaClick(Sender: TObject);
    procedure BtnGuardarEmpClick(Sender: TObject);
    procedure BtnGuardarTrabajoClick(Sender: TObject);
    procedure BtnBorrarTrabajoClick(Sender: TObject);
    procedure BtnBorrarEmpClick(Sender: TObject);
    procedure ComboLineaChange(Sender: TObject);
    procedure ComboTrabajoChange(Sender: TObject);
    procedure ComboEmpleadoChange(Sender: TObject);
  private
    { Private declarations }
    Empleado,Trabajo,Linea:Boolean;
  public
    { Public declarations }
  end;

var
  Lineas: TLineas;

implementation

{$R *.fmx}

uses Main, Androidapi.JNI.Toasts, FGX.Toasts, FGX.Toasts.Android, Funciones_Android;

{ TLineas }

procedure TLineas.BorrarEmpleado;
begin
   try
    with MainForm.FDQueryInsertar,SQL do
    begin
      Clear;
      Add('Delete from Empleado where Nombre='+''''+ComboEmpleado.Selected.Text+'''');
      MainForm.FDQueryInsertar.ExecSQL;
      BuscarEmp;
      ToastImagen('Empleado eliminado',false,MainForm.LogoVirma.Bitmap,$FFFFFF,$FF000000);
    end;
    except
    on E:exception do
    ShowMessage('No se pudo borrar el empleado '+e.Message);
  end;
end;

procedure TLineas.BorrarLinea;
var
  Toast: TfgToast;
begin
  try
    with MainForm.FDQueryInsertar,SQL do
    begin
      Clear;
      Add('Delete from Linea where Nombre='+''''+ComboLinea.Selected.Text+'''');
      MainForm.FDQueryInsertar.ExecSQL;
      BuscarLinea;
      ToastImagen('Linea eliminada',false,MainForm.LogoVirma.Bitmap,$FFFFFF,$FF000000);
    end;
    except
    on E:exception do
    ShowMessage('No se pudo borrar la linea '+e.Message);
  end;
end;
procedure TLineas.BorrarTrabajo;
begin
  try
    with MainForm.FDQueryInsertar,SQL do
    begin
      Clear;
      Add('Delete from Trabajo where Trabajo='+''''+ComboTrabajo.Selected.Text+'''');
      MainForm.FDQueryInsertar.ExecSQL;
      BuscarTrabajo;
      ToastImagen('Trabajo eliminado',false,MainForm.LogoVirma.Bitmap,$FFFFFF,$FF000000);
    end;
    except
    on E:exception do
    ShowMessage('No se pudo borrar la linea '+e.Message);
  end;
end;

//
procedure TLineas.BtnBorrarEmpClick(Sender: TObject);
begin
  if Empleado then
  begin
     MessageDlg('¿Desea eliminar el empleado? ', System.UITypes.TMsgDlgType.mtInformation,
    [System.UITypes.TMsgDlgBtn.mbOK,System.UITypes.TMsgDlgBtn.mbNo], 0, procedure(const AResult: System.UITypes.TModalResult)
    begin
      case AResult of
        mrOk:
        begin
          BorrarEmpleado;
        end;
        mrNo:
      end;
    end);
  end;
end;

procedure TLineas.BtnBorrarLineaClick(Sender: TObject);
begin
  if Linea then
  begin
     MessageDlg('¿Desea eliminar la linea seleccionada? ', System.UITypes.TMsgDlgType.mtInformation,
    [System.UITypes.TMsgDlgBtn.mbOK,System.UITypes.TMsgDlgBtn.mbNo], 0, procedure(const AResult: System.UITypes.TModalResult)
    begin
      case AResult of
        mrOk:
        begin
          BorrarLinea;
        end;
        mrNo:
      end;
    end);
  end;
end;

procedure TLineas.BtnBorrarTrabajoClick(Sender: TObject);
begin
  if Trabajo then
  begin
        MessageDlg('¿Desea eliminar el tipo de trabajo seleccionado? ', System.UITypes.TMsgDlgType.mtInformation,
    [System.UITypes.TMsgDlgBtn.mbOK,System.UITypes.TMsgDlgBtn.mbNo], 0, procedure(const AResult: System.UITypes.TModalResult)
    begin
      case AResult of
        mrOk:
        begin
          BorrarTrabajo;
        end;
        mrNo:
      end;
    end);
  end;
end;

procedure TLineas.BtnGuardarTrabajoClick(Sender: TObject);
begin
   if EdtTrabajo.Text.Equals('') then ShowMessage('Inserte un tipo de trabajo') else
  begin
    InsertarTrabajo;
  end;
end;

procedure TLineas.BuscarEmp;
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

procedure TLineas.BuscarLinea;
begin
  try
    with MainForm.FDQueryBuscar,SQL do
    begin
      ComboLinea.Clear;
      Active :=  False;
      Clear;
      Add('Select Nombre From Linea');
      Close;
      Open;
      while not eof do
      begin
        try
          begin
            ComboLinea.Items.Add(Fields[0].AsString);
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

procedure TLineas.BuscarTrabajo;
begin
    try
    with MainForm.FDQueryBuscar,SQL do
    begin
      ComboTrabajo.Clear;
      Active :=  False;
      Clear;
      Add('Select Trabajo From Trabajo');
      Close;
      Open;
      while not eof do
      begin
        try
          begin
            ComboTrabajo.Items.Add(Fields[0].AsString);
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

procedure TLineas.ComboEmpleadoChange(Sender: TObject);
begin
  Empleado:=True;
end;

procedure TLineas.ComboLineaChange(Sender: TObject);
begin
  Linea:=True;
end;

procedure TLineas.ComboTrabajoChange(Sender: TObject);
begin
  Trabajo:=True;
end;

procedure TLineas.BtnGuardarEmpClick(Sender: TObject);
begin
  if EditEmp.Text.Equals('') or EdtGanancia.Text.Equals('') then ShowMessage('Inserte nombre y ganancia del empleado') else
  begin
    InsertarEmpleado;
  end;
  MainForm.ObtenerEmpleadosLista;
  MainForm.ObtenerEmpleadosTrabajo;
end;

procedure TLineas.btnGuardarLineaClick(Sender: TObject);
begin
  if EditLinea.Text.Equals('') then ShowMessage('Inserte una linea') else
  begin
    InsertarLinea;
    MainForm.ObtenerLineas;
  end;
end;

procedure TLineas.FormShow(Sender: TObject);
begin
  BuscarLinea;
  BuscarEmp;
  BuscarTrabajo;
end;

procedure TLineas.InsertarEmpleado;
begin
      try
    with MainForm.FDQueryInsertar,SQL do
    begin
      Clear;
      Add('insert into Empleado (Nombre,Ganancia) ');
      Add('values (:Nombre,:Ganancia)');
      Params[0].AsString:=EditEmp.Text;
      Params[1].AsString:=EdtGanancia.Text;
      MainForm.FDQueryInsertar.ExecSQL;
      EditEmp.Text:='';
      EdtGanancia.Text:='';
      BuscarEmp;
      ToastImagen('Empleado insertado exitosamente',false,MainForm.LogoVirma.Bitmap,$FFFFFF,$FF000000);
      OcultarTeclado;
    end;
  except
    on E:exception do
      ShowMessage('No se pudo insertar el empleado '+e.Message);
  end;
end;



procedure TLineas.InsertarLinea;
begin
     try
    with MainForm.FDQueryInsertar,SQL do
    begin
      Clear;
      Add('insert into linea (Nombre) values ('+''''+EditLinea.Text+''''+')');
      MainForm.FDQueryInsertar.ExecSQL;
      BuscarLinea;
      EditLinea.Text:='';
      OcultarTeclado;
      ToastImagen('Linea insertada exitosamente',false,MainForm.LogoVirma.Bitmap,$FFFFFF,$FF000000);
      OcultarTeclado;
    end;
  except
    on E:exception do
      ShowMessage('No se pudo insertar la linea '+e.Message);
  end;
end;

procedure TLineas.InsertarTrabajo;
begin
  try
    with MainForm.FDQueryInsertar,SQL do
    begin
      Clear;
      Add('insert into Trabajo (Trabajo,Informacion)');
      Add('values (:Trabajo,:Informacion)');
      Params[0].AsString:=EdtTrabajo.Text;
      Params[1].AsString:=EdtInfo.Text;
      MainForm.FDQueryInsertar.ExecSQL;
      EdtTrabajo.Text:='';
      EdtInfo.Text:='';
      BuscarTrabajo;
      ToastImagen('Trabajo insertado exitosamente',false,MainForm.LogoVirma.Bitmap,$FFFFFF,$FF000000);
      OcultarTeclado;
    end;
  except
    on E:exception do
      ShowMessage('No se pudo insertar el trabajo '+e.Message);
  end;
end;

end.
