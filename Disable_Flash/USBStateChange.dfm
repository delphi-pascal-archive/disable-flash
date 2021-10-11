object Form6: TForm6
  Left = 221
  Top = 131
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Flash Drive'
  ClientHeight = 74
  ClientWidth = 217
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 16
  object btnEnable: TButton
    Left = 8
    Top = 8
    Width = 201
    Height = 25
    Caption = #1042#1082#1083#1102#1095#1080#1090#1100' Flash'
    TabOrder = 0
    OnClick = btnEnableClick
  end
  object btnDisable: TButton
    Left = 8
    Top = 40
    Width = 201
    Height = 25
    Caption = #1054#1090#1082#1083#1102#1095#1080#1090#1100' Flash'
    TabOrder = 1
    OnClick = btnDisableClick
  end
end
