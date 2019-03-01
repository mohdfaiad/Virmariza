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

uses  Usuario, MainActivity, ClientClassesUnit1, ConfigCliente;


procedure TfPresentacion.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Tipo:=0;
end;

procedure TfPresentacion.FormShow(Sender: TObject);
var
  KeyboardService: IFMXVirtualKeyboardService;
begin
  FMainActivity.TimerPresentacion.Enabled:=false;
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

procedure TfPresentacion.tCloseTimer(Sender: TObject);
var
Usuario:String;
Ip:string;
begin
  with FMainActivity.FDQueryBuscar,SQL do
  begin
    Active :=  False;
    Clear;
    Add('select NOMBRE from EXP_USUARIO ');
    Close;
    Open;
    Usuario:=Fields[0].AsString;
    Clear;
    Add('select IP_SERVIDOR from EXP_CONFIGURACION ');
    Close;
    Open;
    Ip:=Fields[0].AsString;
    if Ip.Equals('') then
      begin
      fConfigCliente :=TfConfigCliente.Create(nil);
      try
        fConfigCliente.Show;
      finally
        fConfigCliente.Free;
      end;
    end
    else if Usuario.Equals('') then
      begin
      User:=TUser.Create(nil);
      try
        User.Show;
      finally
        User.Free;
      end;
    end
    else
    begin
      FMainActivity.Show;
      tClose.Enabled:=false;
      Close;
    end;
    tClose.Enabled:=false;
    Close;
  end;
end;

end.
