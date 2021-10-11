////////////////////////////////////////////////////////////////////////////////
//
//  ****************************************************************************
//  * Unit Name : USBStateChange
//  * Purpose   : Пример включения.отключения USB накопителей
//  * Author    : Александр (Rouse_) Багель
//  * Copyright : © Fangorn Wizards Lab 1998 - 2007
//  * Version   : 1.00
//  * Home Page : http://rouse.drkb.ru
//  ****************************************************************************
//

unit USBStateChange;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm6 = class(TForm)
    btnEnable: TButton;
    btnDisable: TButton;
    procedure btnEnableClick(Sender: TObject);
    procedure btnDisableClick(Sender: TObject);
  end;

var
  Form6: TForm6;

implementation

{$R *.dfm}

type
  PSP_CLASSINSTALL_HEADER = ^SP_CLASSINSTALL_HEADER;
  SP_CLASSINSTALL_HEADER = record
    cbSize: DWORD;
    InstallFunction: Cardinal;
  end;

  PSP_PROPCHANGE_PARAMS = ^SP_PROPCHANGE_PARAMS;
  SP_PROPCHANGE_PARAMS = record
    ClassInstallHeader: SP_CLASSINSTALL_HEADER;
    StateChange: DWORD;
    Scope: DWORD;
    HwProfile: DWORD;
  end;

  PSP_DEVINFO_DATA = ^SP_DEVINFO_DATA;
  SP_DEVINFO_DATA = record
    cbSize: DWORD;
    ClassGuid: TGUID;
    DevInst: DWORD;
    Reserved: Longint;
  end;

  function SetupDiGetClassDevs(const ClassGuid: PGUID; Enumerator: PChar;
    hwndParent: HWND; Flags: DWORD): DWORD; stdcall;
    external 'Setupapi.dll' name 'SetupDiGetClassDevsA';

  function SetupDiDestroyDeviceInfoList(DeviceInfoSet: DWORD): BOOL; stdcall;
    external 'Setupapi.dll';

  function SetupDiEnumDeviceInfo(DeviceInfoSet: DWORD; MemberIndex: DWORD;
    DeviceInfoData: PSP_DEVINFO_DATA): BOOL; stdcall;
    external 'Setupapi.dll';

  function SetupDiCallClassInstaller(InstallFunction: DWORD;
    DeviceInfoSet: DWORD; DeviceInfoData: PSP_DEVINFO_DATA): BOOL; stdcall;
    external 'setupapi.dll';

  function SetupDiGetDeviceRegistryProperty(DeviceInfoSet: DWORD;
    DeviceInfoData: PSP_DEVINFO_DATA; Propertys: DWORD; PropertyRegDataType: PWORD;
    PropertyBuffer: PByte; PropertyBufferSize: DWORD; RequiredSize: PWORD): BOOL; stdcall;
    external 'Setupapi.dll' name 'SetupDiGetDeviceRegistryPropertyA';

  function SetupDiSetClassInstallParams(DeviceInfoSet: DWORD;
    DeviceInfoData: PSP_DEVINFO_DATA; ClassInstallParams: PSP_CLASSINSTALL_HEADER;
    ClassInstallParamsSize: DWORD): BOOL; stdcall;
    external 'setupapi.dll' name 'SetupDiSetClassInstallParamsA';

const
  DICS_ENABLE = $00000001;
  DICS_DISABLE = $00000002;
  DIF_PROPERTYCHANGE = $00000012;
  DICS_FLAG_GLOBAL = $00000001;
  DIGCF_PRESENT = $00000002;
  SPDRP_COMPATIBLEIDS = $00000002;

  DISK_GUID: TGUID = '{4D36E967-E325-11CE-BFC1-08002BE10318}';

function ChangeDeviceState(AState: DWORD): Boolean;
var
  pcp: SP_PROPCHANGE_PARAMS;
  DevInfoData: SP_DEVINFO_DATA;
  hDevInfo1:  DWORD;
  I, DataT, Buffersize: DWORD;
  Buffer: PAnsiChar;
begin
  Result := False;
  pcp.ClassInstallHeader.cbSize := sizeof(SP_CLASSINSTALL_HEADER);
  pcp.ClassInstallHeader.InstallFunction := DIF_PROPERTYCHANGE;
  pcp.StateChange := AState;
  pcp.Scope := DICS_FLAG_GLOBAL;
  pcp.HwProfile := 0;
  hDevInfo1 := SetupDiGetClassDevs(@DISK_GUID, nil, HWND(nil), DIGCF_PRESENT);
  try
    DevInfoData.cbSize := sizeof(SP_DEVINFO_DATA);
    I := 0;
    Buffersize := 500;
    GetMem(Buffer, Buffersize);
    try
      while SetupDiEnumDeviceInfo(hDevInfo1, I, @DevInfoData) do
      begin
        SetupDiGetDeviceRegistryProperty(hDevInfo1, @DevInfoData,
          SPDRP_COMPATIBLEIDS, @DataT, PByte(Buffer), Buffersize, nil);
        if buffer = 'USBSTOR\Disk' then
        begin
          if not SetupDiSetClassInstallParams(hDevInfo1,
            @DevInfoData, PSP_CLASSINSTALL_HEADER(@pcp), SizeOf(pcp)) then Exit;
          if not SetupDiCallClassInstaller(
            DIF_PROPERTYCHANGE, hDevInfo1, @DevInfoData) then Exit;
          Result := True;
        end;
        Inc(I);
      end;
    finally
      FreeMem(Buffer);
    end;
  finally
    SetupDiDestroyDeviceInfoList(hDevInfo1);
  end;
end;

procedure TForm6.btnEnableClick(Sender: TObject);
begin
  if ChangeDeviceState(DICS_ENABLE) then
    ShowMessage('Устройство включено');
end;

procedure TForm6.btnDisableClick(Sender: TObject);
begin
  if ChangeDeviceState(DICS_DISABLE) then
    ShowMessage('Устройство отключено');
end;

end.
