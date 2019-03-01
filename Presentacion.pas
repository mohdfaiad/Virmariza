unit Presentacion;
//Esta unidad solo muestra por algunos segundos el logo de expertos a modo de presentacion
interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Platform,
  FMX.VirtualKeyboard, System.UIConsts;

type
  TfPresentacion = class(TForm)
    img1: TImage;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    tClose: TTimer;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tCloseTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Tipo:Integer;
  end;

var
  fPresentacion: TfPresentacion;

implementation

{$R *.fmx}
{$R *.NmXhdpiPh.fmx ANDROID}

uses Main;

procedure TfPresentacion.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Tipo:=0;
end;
//Mantiene la presentarion por 4.5 segundos
procedure TfPresentacion.FormShow(Sender: TObject);
var
  KeyboardService: IFMXVirtualKeyboardService;
begin
  MainForm.TimerPresentacion.Enabled:=false;
  if TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(KeyboardService)) then
  KeyboardService.HideVirtualKeyboard;
  FMX.Types.VKAutoShowMode :=TVKAutoShowMode.Never;
  if Tipo=1 then
  begin
    tClose.Interval:=45000;
    ClientHeight:=356;
    Caption:='Acerca de...';
  end;
  tClose.Enabled:=true
end;
//Cierra la app
procedure TfPresentacion.tCloseTimer(Sender: TObject);
begin
    begin
      MainForm.Show;
      tClose.Enabled:=false;
      Close;
    end;
    tClose.Enabled:=false;
    Close;
  end;

end.
