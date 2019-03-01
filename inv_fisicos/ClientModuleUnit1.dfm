object ClientModule1: TClientModule1
  OldCreateOrder = False
  Height = 271
  Width = 415
  object SQLConnection1: TSQLConnection
    DriverName = 'DataSnap'
    LoginPrompt = False
    Params.Strings = (
      'DriverUnit=Data.DBXDataSnap'
      
        'DriverAssemblyLoader=Borland.Data.TDBXClientDriverLoader,Borland' +
        '.Data.DbxClientDriver,Version=24.0.0.0,Culture=neutral,PublicKey' +
        'Token=91d62ebb5b0d1b1b'
      'Port=211'
      'HostName=192.168.2.124'
      'CommunicationProtocol=tcp/ip'
      'DatasnapContext=datasnap/'
      'Filters={}'
      'ConnectTimeout=5000')
    Left = 48
    Top = 40
    UniqueId = '{0478C504-4BB1-450C-AFBE-66A2F60CFBC7}'
  end
end
