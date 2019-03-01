//
// Created by the DataSnap proxy generator.
// 01/11/2018 03:24:05 p.m.
//

unit ClientClassesUnit1;

interface

uses System.JSON, Data.DBXCommon, Data.DBXClient, Data.DBXDataSnap, Data.DBXJSON, Datasnap.DSProxy, System.Classes, System.SysUtils, Data.DB, Data.SqlExpr, Data.DBXDBReaders, Data.DBXCDSReaders, Data.DBXJSONReflect;

type
  TServerMethods2Client = class(TDSAdminClient)
  private
    FAlmacenCommand: TDBXCommand;
    FArticulosCommand: TDBXCommand;
    FRecibir_InventarioCommand: TDBXCommand;
    FChecar_UsuarioCommand: TDBXCommand;
    FRecibir_Inventario_2Command: TDBXCommand;
    FPuntosArticuloCommand: TDBXCommand;
    FActualizaParamsCommand: TDBXCommand;
    FUltimaActualizaCommand: TDBXCommand;
    FGetDatosImagenesCommand: TDBXCommand;
    FGetNombreImagenCommand: TDBXCommand;
    FExistePuntosCommand: TDBXCommand;
  public
    constructor Create(ADBXConnection: TDBXConnection); overload;
    constructor Create(ADBXConnection: TDBXConnection; AInstanceOwner: Boolean); overload;
    destructor Destroy; override;
    function Almacen: TDataSet;
    function Articulos: TDataSet;
    procedure Recibir_Inventario(ARTICULO_ID: string; F_MODIFICA: string; ARTICULO_CLAVE: string; U_CAPTURA: string; ALMACEN: string; FOLIO: string);
    function Checar_Usuario(USUARIO: string; CONTRASEÑA: string): Boolean;
    procedure Recibir_Inventario_2(ID: string; ALMACEN_ID: string; ALMACEN: string; FECHA_CREACION: string; FECHA_ENVIO: string; VACIO: string; MOMENTO: string);
    function PuntosArticulo(Clave: string; Puntos: Boolean): TDataSet;
    function ActualizaParams: TDataSet;
    function UltimaActualiza(Fecha: TDateTime): Boolean;
    function GetDatosImagenes: TDataSet;
    function GetNombreImagen: TDataSet;
    function ExistePuntos: Boolean;
  end;

implementation

function TServerMethods2Client.Almacen: TDataSet;
begin
  if FAlmacenCommand = nil then
  begin
    FAlmacenCommand := FDBXConnection.CreateCommand;
    FAlmacenCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FAlmacenCommand.Text := 'TServerMethods2.Almacen';
    FAlmacenCommand.Prepare;
  end;
  FAlmacenCommand.ExecuteUpdate;
  Result := TCustomSQLDataSet.Create(nil, FAlmacenCommand.Parameters[0].Value.GetDBXReader(False), True);
  Result.Open;
  if FInstanceOwner then
    FAlmacenCommand.FreeOnExecute(Result);
end;

function TServerMethods2Client.Articulos: TDataSet;
begin
  if FArticulosCommand = nil then
  begin
    FArticulosCommand := FDBXConnection.CreateCommand;
    FArticulosCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FArticulosCommand.Text := 'TServerMethods2.Articulos';
    FArticulosCommand.Prepare;
  end;
  FArticulosCommand.ExecuteUpdate;
  Result := TCustomSQLDataSet.Create(nil, FArticulosCommand.Parameters[0].Value.GetDBXReader(False), True);
  Result.Open;
  if FInstanceOwner then
    FArticulosCommand.FreeOnExecute(Result);
end;

procedure TServerMethods2Client.Recibir_Inventario(ARTICULO_ID: string; F_MODIFICA: string; ARTICULO_CLAVE: string; U_CAPTURA: string; ALMACEN: string; FOLIO: string);
begin
  if FRecibir_InventarioCommand = nil then
  begin
    FRecibir_InventarioCommand := FDBXConnection.CreateCommand;
    FRecibir_InventarioCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FRecibir_InventarioCommand.Text := 'TServerMethods2.Recibir_Inventario';
    FRecibir_InventarioCommand.Prepare;
  end;
  FRecibir_InventarioCommand.Parameters[0].Value.SetWideString(ARTICULO_ID);
  FRecibir_InventarioCommand.Parameters[1].Value.SetWideString(F_MODIFICA);
  FRecibir_InventarioCommand.Parameters[2].Value.SetWideString(ARTICULO_CLAVE);
  FRecibir_InventarioCommand.Parameters[3].Value.SetWideString(U_CAPTURA);
  FRecibir_InventarioCommand.Parameters[4].Value.SetWideString(ALMACEN);
  FRecibir_InventarioCommand.Parameters[5].Value.SetWideString(FOLIO);
  FRecibir_InventarioCommand.ExecuteUpdate;
end;

function TServerMethods2Client.Checar_Usuario(USUARIO: string; CONTRASEÑA: string): Boolean;
begin
  if FChecar_UsuarioCommand = nil then
  begin
    FChecar_UsuarioCommand := FDBXConnection.CreateCommand;
    FChecar_UsuarioCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FChecar_UsuarioCommand.Text := 'TServerMethods2.Checar_Usuario';
    FChecar_UsuarioCommand.Prepare;
  end;
  FChecar_UsuarioCommand.Parameters[0].Value.SetWideString(USUARIO);
  FChecar_UsuarioCommand.Parameters[1].Value.SetWideString(CONTRASEÑA);
  FChecar_UsuarioCommand.ExecuteUpdate;
  Result := FChecar_UsuarioCommand.Parameters[2].Value.GetBoolean;
end;

procedure TServerMethods2Client.Recibir_Inventario_2(ID: string; ALMACEN_ID: string; ALMACEN: string; FECHA_CREACION: string; FECHA_ENVIO: string; VACIO: string; MOMENTO: string);
begin
  if FRecibir_Inventario_2Command = nil then
  begin
    FRecibir_Inventario_2Command := FDBXConnection.CreateCommand;
    FRecibir_Inventario_2Command.CommandType := TDBXCommandTypes.DSServerMethod;
    FRecibir_Inventario_2Command.Text := 'TServerMethods2.Recibir_Inventario_2';
    FRecibir_Inventario_2Command.Prepare;
  end;
  FRecibir_Inventario_2Command.Parameters[0].Value.SetWideString(ID);
  FRecibir_Inventario_2Command.Parameters[1].Value.SetWideString(ALMACEN_ID);
  FRecibir_Inventario_2Command.Parameters[2].Value.SetWideString(ALMACEN);
  FRecibir_Inventario_2Command.Parameters[3].Value.SetWideString(FECHA_CREACION);
  FRecibir_Inventario_2Command.Parameters[4].Value.SetWideString(FECHA_ENVIO);
  FRecibir_Inventario_2Command.Parameters[5].Value.SetWideString(VACIO);
  FRecibir_Inventario_2Command.Parameters[6].Value.SetWideString(MOMENTO);
  FRecibir_Inventario_2Command.ExecuteUpdate;
end;

function TServerMethods2Client.PuntosArticulo(Clave: string; Puntos: Boolean): TDataSet;
begin
  if FPuntosArticuloCommand = nil then
  begin
    FPuntosArticuloCommand := FDBXConnection.CreateCommand;
    FPuntosArticuloCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FPuntosArticuloCommand.Text := 'TServerMethods2.PuntosArticulo';
    FPuntosArticuloCommand.Prepare;
  end;
  FPuntosArticuloCommand.Parameters[0].Value.SetWideString(Clave);
  FPuntosArticuloCommand.Parameters[1].Value.SetBoolean(Puntos);
  FPuntosArticuloCommand.ExecuteUpdate;
  Result := TCustomSQLDataSet.Create(nil, FPuntosArticuloCommand.Parameters[2].Value.GetDBXReader(False), True);
  Result.Open;
  if FInstanceOwner then
    FPuntosArticuloCommand.FreeOnExecute(Result);
end;

function TServerMethods2Client.ActualizaParams: TDataSet;
begin
  if FActualizaParamsCommand = nil then
  begin
    FActualizaParamsCommand := FDBXConnection.CreateCommand;
    FActualizaParamsCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FActualizaParamsCommand.Text := 'TServerMethods2.ActualizaParams';
    FActualizaParamsCommand.Prepare;
  end;
  FActualizaParamsCommand.ExecuteUpdate;
  Result := TCustomSQLDataSet.Create(nil, FActualizaParamsCommand.Parameters[0].Value.GetDBXReader(False), True);
  Result.Open;
  if FInstanceOwner then
    FActualizaParamsCommand.FreeOnExecute(Result);
end;

function TServerMethods2Client.UltimaActualiza(Fecha: TDateTime): Boolean;
begin
  if FUltimaActualizaCommand = nil then
  begin
    FUltimaActualizaCommand := FDBXConnection.CreateCommand;
    FUltimaActualizaCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FUltimaActualizaCommand.Text := 'TServerMethods2.UltimaActualiza';
    FUltimaActualizaCommand.Prepare;
  end;
  FUltimaActualizaCommand.Parameters[0].Value.AsDateTime := Fecha;
  FUltimaActualizaCommand.ExecuteUpdate;
  Result := FUltimaActualizaCommand.Parameters[1].Value.GetBoolean;
end;

function TServerMethods2Client.GetDatosImagenes: TDataSet;
begin
  if FGetDatosImagenesCommand = nil then
  begin
    FGetDatosImagenesCommand := FDBXConnection.CreateCommand;
    FGetDatosImagenesCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FGetDatosImagenesCommand.Text := 'TServerMethods2.GetDatosImagenes';
    FGetDatosImagenesCommand.Prepare;
  end;
  FGetDatosImagenesCommand.ExecuteUpdate;
  Result := TCustomSQLDataSet.Create(nil, FGetDatosImagenesCommand.Parameters[0].Value.GetDBXReader(False), True);
  Result.Open;
  if FInstanceOwner then
    FGetDatosImagenesCommand.FreeOnExecute(Result);
end;

function TServerMethods2Client.GetNombreImagen: TDataSet;
begin
  if FGetNombreImagenCommand = nil then
  begin
    FGetNombreImagenCommand := FDBXConnection.CreateCommand;
    FGetNombreImagenCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FGetNombreImagenCommand.Text := 'TServerMethods2.GetNombreImagen';
    FGetNombreImagenCommand.Prepare;
  end;
  FGetNombreImagenCommand.ExecuteUpdate;
  Result := TCustomSQLDataSet.Create(nil, FGetNombreImagenCommand.Parameters[0].Value.GetDBXReader(False), True);
  Result.Open;
  if FInstanceOwner then
    FGetNombreImagenCommand.FreeOnExecute(Result);
end;

function TServerMethods2Client.ExistePuntos: Boolean;
begin
  if FExistePuntosCommand = nil then
  begin
    FExistePuntosCommand := FDBXConnection.CreateCommand;
    FExistePuntosCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FExistePuntosCommand.Text := 'TServerMethods2.ExistePuntos';
    FExistePuntosCommand.Prepare;
  end;
  FExistePuntosCommand.ExecuteUpdate;
  Result := FExistePuntosCommand.Parameters[0].Value.GetBoolean;
end;

constructor TServerMethods2Client.Create(ADBXConnection: TDBXConnection);
begin
  inherited Create(ADBXConnection);
end;

constructor TServerMethods2Client.Create(ADBXConnection: TDBXConnection; AInstanceOwner: Boolean);
begin
  inherited Create(ADBXConnection, AInstanceOwner);
end;

destructor TServerMethods2Client.Destroy;
begin
  FAlmacenCommand.DisposeOf;
  FArticulosCommand.DisposeOf;
  FRecibir_InventarioCommand.DisposeOf;
  FChecar_UsuarioCommand.DisposeOf;
  FRecibir_Inventario_2Command.DisposeOf;
  FPuntosArticuloCommand.DisposeOf;
  FActualizaParamsCommand.DisposeOf;
  FUltimaActualizaCommand.DisposeOf;
  FGetDatosImagenesCommand.DisposeOf;
  FGetNombreImagenCommand.DisposeOf;
  FExistePuntosCommand.DisposeOf;
  inherited;
end;

end.

