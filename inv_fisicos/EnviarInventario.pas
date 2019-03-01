unit EnviarInventario;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti,
  FMX.Grid.Style, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs,
  Fmx.Bind.Editors, FMX.StdCtrls, Data.Bind.Components, Data.Bind.Grid,
  Data.Bind.DBScope, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FMX.ScrollBox, FMX.Grid, FMX.ListBox, FMX.Objects, FMX.Effects,
  FMX.Controls.Presentation, FMX.Layouts, FMX.ExtCtrls, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FireDAC.Stan.Async, FireDAC.DApt,System.IOUtils, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait;

type
  TFEnviarInventario = class(TForm)
    ImageViewer1: TImageViewer;
    ToolBar1: TToolBar;
    ShadowEffect1: TShadowEffect;
    Label1: TLabel;
    ToolBar2: TToolBar;
    ShadowEffect2: TShadowEffect;
    Image2: TImage;
    Image4: TImage;
    StringGrid1: TStringGrid;
    Label3: TLabel;
    SpeedButton1: TSpeedButton;
    ListView1: TListView;
    FDConnection2: TFDConnection;
    BindSourceDB1: TBindSourceDB;
    FDQuery1: TFDQuery;
    LinkFillControlToFieldFOLIO_ID: TLinkFillControlToField;
    BindingsList1: TBindingsList;
    Button1: TButton;
    ComboBox1: TComboBox;
    procedure Obtener_Inventarios;
    procedure FormShow(Sender: TObject);
    procedure StringGrid1CellClick(const Column: TColumn; const Row: Integer);
    procedure FDConnection2BeforeConnect(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FEnviarInventario: TFEnviarInventario;

implementation

{$R *.fmx}

uses MainActivity;



procedure TFEnviarInventario.Button1Click(Sender: TObject);
var
  TaskName: String;
begin
TaskName := ListView1.Selected.ToString;
showmessage ( TaskName);
end;

procedure TFEnviarInventario.FDConnection2BeforeConnect(Sender: TObject);
begin
{$IF DEFINED(iOS) or DEFINED(ANDROID)}
  FDConnection2.Params.Values['Database'] :=
  TPath.Combine(TPath.GetDocumentsPath, 'Colectora.s3db');
  {$ENDIF}
end;

procedure TFEnviarInventario.FormShow(Sender: TObject);
begin
  //Llenar_Tabla;
end;

procedure TFEnviarInventario.Obtener_Inventarios;
begin
  try
    with fMainActivity.FDQueryBuscar,SQL do
    begin
      Active :=  False;
      Clear;
      Add('select folio_id from EXP_INVENTARIO_FISICO');
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

procedure TFEnviarInventario.StringGrid1CellClick(const Column: TColumn;
  const Row: Integer);
begin
SpeedButton1.Visible:=true;
end;

end.
