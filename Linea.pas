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
    GuardarLinea: TButton;
    ComboBox1: TComboBox;
    BtnBorrarLinea: TButton;
    LayoutLinea: TLayout;
    LayoutEmp: TLayout;
    Layout3: TLayout;
    EditEmp: TEdit;
    GuardarEmp: TButton;
    ComboBox2: TComboBox;
    BorrarEmp: TButton;
    procedure InsertarLinea;
    procedure BuscarLinea;
    procedure BorrarLinea;
    procedure GuardarLineaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnBorrarLineaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Lineas: TLineas;

implementation

{$R *.fmx}

uses Main, Androidapi.JNI.Toasts, FGX.Toasts, FGX.Toasts.Android;

{ TLineas }
//Elimina la linea que este en el combobox
procedure TLineas.BorrarLinea;
var
  Toast: TfgToast;
begin
  try
    with MainForm.FDQueryInsertar,SQL do
    begin
      Clear;
      Add('Delete from Linea where Nombre='+''''+Combobox1.Selected.Text+'''');
      MainForm.FDQueryInsertar.ExecSQL;
      BuscarLinea;
      Toast := TfgToast.Create('Linea eliminada correctamente ', TfgToastDuration(Long));
      //Toast.Icon:=FMainActivity.Logo.Bitmap;
      Toast.MessageColor := $FFFFFFFF;
      Toast.BackgroundColor := $8A000000 ;
      Toast.Show;
      Toast.Free;
    end;
    except
    on E:exception do
    ShowMessage('No se pudo borrar la linea '+e.Message);
  end;
end;
//
procedure TLineas.BtnBorrarLineaClick(Sender: TObject);
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

procedure TLineas.BuscarLinea;
begin
  try
    with MainForm.FDQueryBuscar,SQL do
    begin
      ComboBox1.Clear;
      Active :=  False;
      Clear;
      Add('Select Nombre From Linea');
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

procedure TLineas.GuardarLineaClick(Sender: TObject);
begin
  InsertarLinea;
  BuscarLinea;
  MainForm.ObtenerLineas;
end;

procedure TLineas.FormShow(Sender: TObject);
begin
  BuscarLinea;
end;

procedure TLineas.InsertarLinea;
var
  Toast: TfgToast;
begin
     try
    with MainForm.FDQueryInsertar,SQL do
    begin
      Clear;
      Add('insert into linea (Nombre) values ('+''''+EditNombre.Text+''''+')');
      MainForm.FDQueryInsertar.ExecSQL;
      BuscarLinea;
      EditNombre.Text:='';
      Toast := TfgToast.Create('Linea insertada correctamente ', TfgToastDuration(Long));
      //Toast.Icon:=FMainActivity.Logo.Bitmap;
      Toast.MessageColor := $FFFFFFFF;
      Toast.BackgroundColor := $8A000000 ;
      Toast.Show;
      Toast.Free;
    end;
  except
    on E:exception do
      ShowMessage('No se pudo insertar la linea '+e.Message);
  end;
end;

end.
