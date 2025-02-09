object EditMetadata: TEditMetadata
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1056#160#1056#181#1056#1169#1056#176#1056#1108#1057#8218#1056#1105#1057#1026#1056#1109#1056#1030#1056#176#1056#1029#1056#1105#1056#181' '#1056#1112#1056#181#1057#8218#1056#176#1056#1169#1056#176#1056#1029#1056#1029#1057#8249#1057#8230
  ClientHeight = 240
  ClientWidth = 400
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 400
    Height = 240
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 396
    ExplicitHeight = 239
    object LabelTitle: TLabel
      Left = 10
      Top = 10
      Width = 94
      Height = 13
      Caption = #1056#1116#1056#176#1056#183#1056#1030#1056#176#1056#1029#1056#1105#1056#181':'
    end
    object LabelAuthor: TLabel
      Left = 10
      Top = 40
      Width = 62
      Height = 13
      Caption = #1056#1106#1056#1030#1057#8218#1056#1109#1057#1026':'
    end
    object LabelGenre: TLabel
      Left = 10
      Top = 70
      Width = 54
      Height = 13
      Caption = #1056#8211#1056#176#1056#1029#1057#1026':'
    end
    object LabelLanguage: TLabel
      Left = 10
      Top = 100
      Width = 46
      Height = 13
      Caption = #1056#1031#1056#183#1057#8249#1056#1108':'
    end
    object ImageCover: TImage
      Left = 10
      Top = 130
      Width = 80
      Height = 100
      Stretch = True
    end
    object EditTitle: TEdit
      Left = 100
      Top = 10
      Width = 280
      Height = 21
      TabOrder = 0
    end
    object EditAuthor: TEdit
      Left = 100
      Top = 40
      Width = 280
      Height = 21
      TabOrder = 1
    end
    object EditGenre: TEdit
      Left = 100
      Top = 70
      Width = 280
      Height = 21
      TabOrder = 2
    end
    object EditLanguage: TEdit
      Left = 100
      Top = 100
      Width = 280
      Height = 21
      TabOrder = 3
    end
    object ButtonSave: TButton
      Left = 100
      Top = 160
      Width = 75
      Height = 25
      Caption = #1056#1038#1056#1109#1057#8230#1057#1026#1056#176#1056#1029#1056#1105#1057#8218#1057#1034
      TabOrder = 4
      OnClick = ButtonSaveClick
    end
    object ButtonCancel: TButton
      Left = 200
      Top = 160
      Width = 75
      Height = 25
      Caption = #1056#1115#1057#8218#1056#1112#1056#181#1056#1029#1056#176
      TabOrder = 5
      OnClick = ButtonCancelClick
    end
  end
end
