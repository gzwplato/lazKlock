unit UOptions;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ButtonPanel, EditBtn, Buttons, INIFiles, UoptionUtils;

type

  { TfrmOptions }

  TfrmOptions = class(TForm)
    btnGlobalFont: TButton;
    btnFuzzyFont: TButton;
    btnCountdownFont: TButton;
    btnTimerFont: TButton;
    btnReminderFont: TButton;
    ButtonPanel1: TButtonPanel;
    ChckBxTimerMilli: TCheckBox;
    ChckBxScreenSave: TCheckBox;
    FontDialog1: TFontDialog;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    Label1: TLabel;
    lblGlobalText: TLabel;
    lblFuzzyTime: TLabel;
    lblCountDown: TLabel;
    lblTimerText: TLabel;
    lblReminderText: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    RdGrpDefault: TRadioGroup;
    SpdBtnDefault: TSpeedButton;
    procedure btnCountdownFontClick(Sender: TObject);
    procedure btnFuzzyFontClick(Sender: TObject);
    procedure btnGlobalFontClick(Sender: TObject);
    procedure btnReminderFontClick(Sender: TObject);
    procedure btnTimerFontClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure ChckBxScreenSaveChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure RdGrpDefaultClick(Sender: TObject);
    procedure SpdBtnDefaultClick(Sender: TObject);

  private
    procedure checkIniFile;
    procedure writeIniValues;
    procedure resetForm;
  public
    procedure writeIniFile;
  end; 


  {  create a options objects, that when created, will be used by main
     form. This will enable to change certain options i.e colout and font.

     TODO :: save to file i.e. xml                                          }


{                                                      ** Options Class  **                        }
  OptionsRecord = class

  Private

  Public
    DefaultTab          : Integer;                //  which tab opens by default
    Version             : string;                 //  application version
    GlobalTextFont      : TFont;                  //  Global font of all main labels
    FuzzyTextFont       : TFont;                  //  Global font of all main labels
    CountDownTextFont   : TFont;                  //  Global font of all main labels
    TimerTextFont       : TFont;                  //  Global font of all main labels
    TimerMilliSeconds   : Boolean;                //  timer to show milli seconds
    ReminderTextFont    : TFont;                  //  Global font of all main labels
    ScreenSave          : Boolean;
    ScreenTop           : Integer;
    ScreenLeft          : Integer;

    Constructor init ;
    procedure setGlobalTextFont(f : TFont);       //  used to set global text font
    procedure setFuzzyTextFont(f : TFont);       //  used to set global text font
    procedure setCountDownTextFont(f : TFont);       //  used to set global text font
    procedure setTimerTextFont(f : TFont);       //  used to set global text font
    procedure setTimerMilliSeconds(b : Boolean);  //  used to set timer to show milli seconds
    procedure setReminderTextFont(f : TFont);       //  used to set global text font
    procedure setDefaultTab(i : Integer);
    procedure setScreenSave(b : Boolean);
    procedure setScreenTop(i : Integer);
    procedure setScreenLeft(i : Integer);
  end;

{                                               ** End of Options Class  **                        }


var
  frmOptions : TfrmOptions;
  OptionsRec : OptionsRecord;              //  Options record
  IniFile    : TIniFile ;
  iniName    : String;
implementation

{$R *.lfm}

{ TfrmOptions }


{                      ********************************** Options Class methods  **                }

Constructor OptionsRecord.init;
begin
  self.DefaultTab := 0;
  self.Version    := '23';

  self.GlobalTextFont      := frmOptions.Font;
  self.FuzzyTextFont       := frmOptions.Font;
  self.CountDownTextFont   := frmOptions.Font;
  self.TimerTextFont       := frmOptions.Font;
  self.TimerMilliSeconds   := false;
  self.ReminderTextFont    := frmOptions.Font;
  ScreenSave               := False;
  self.ScreenTop           := 100;
  self.ScreenLeft          := 100;

end;

procedure OptionsRecord.setGlobalTextFont(f : TFont);
{  used to set text font [global font of all main labels]   }
begin
  self.GlobalTextFont := f;
end;

procedure OptionsRecord.setFuzzyTextFont(f : TFont);
{  used to set text font [global font of all main labels]   }
begin
  self.FuzzyTextFont := f;
end;

procedure OptionsRecord.setCountDownTextFont(f : TFont);
{  used to set text font [global font of all main labels]   }
begin
  self.CountDownTextFont := f;
end;

procedure OptionsRecord.setTimerTextFont(f : TFont);
{  used to set text font [global font of all main labels]   }
begin
  self.TimerTextFont := f;
end;

procedure OptionsRecord.setTimerMilliSeconds(b : Boolean);
{  used to set timer textColour   }
begin
  self.TimerMilliSeconds := b;
end;

procedure OptionsRecord.setReminderTextFont(f : TFont);
{  used to set text font [global font of all main labels]   }
begin
  self.ReminderTextFont := f;
end;

procedure OptionsRecord.setDefaultTab(i : Integer);
{  used to set textColour [global colour of all main labels]   }
begin
  self.DefaultTab := i;
end;

procedure OptionsRecord.setScreenSave(b : Boolean);
{  used to set the screen left of the application.   }
begin
  self.ScreenSave := b;
end;

procedure OptionsRecord.setScreenTop(i : Integer);
{  used to set the screen top of the application.   }
begin
  self.ScreenTop := i;
end;

procedure OptionsRecord.setScreenLeft(i : Integer);
{  used to set the screen left of the application.   }
begin
  self.ScreenLeft := i;
end;



{                      *************************** End of Options Class methods **                 }

{                                               ** form procedures  **                             }
procedure TfrmOptions.FormCreate(Sender: TObject);
begin
  iniName := 'klock.ini';

  OptionsRec := OptionsRecord.Create;    //  create options record,
                                         //  can then be used in main form
  OptionsRec.init;                       //  does not seem to be called automatically.

  checkIniFile;                         //  check for ini file, if not there - create

  resetForm;
end;


procedure TfrmOptions.RdGrpDefaultClick(Sender: TObject);
begin
  OptionsRec.setDefaultTab(RdGrpDefault.ItemIndex);
end;



procedure TfrmOptions.btnGlobalFontClick(Sender: TObject);
begin
 if FontDialog1.Execute then begin
   lblGlobalText.Font := FontDialog1.Font;
   OptionsRec.setGlobalTextFont(FontDialog1.Font);
 end;
end;

procedure TfrmOptions.btnTimerFontClick(Sender: TObject);
begin
 if FontDialog1.Execute then begin
   lblTimerText.Font := FontDialog1.Font;
   OptionsRec.setTimerTextFont(FontDialog1.Font);
 end;
end;

procedure TfrmOptions.btnFuzzyFontClick(Sender: TObject);
begin
 if FontDialog1.Execute then begin
   lblFuzzyTime.Font := FontDialog1.Font;
   OptionsRec.setFuzzyTextFont(FontDialog1.Font);
 end;
end;

procedure TfrmOptions.btnCountdownFontClick(Sender: TObject);
begin
 if FontDialog1.Execute then begin
   lblCountDown.Font := FontDialog1.Font;
   OptionsRec.setCountdownTextFont(FontDialog1.Font);
 end;
end;

procedure TfrmOptions.btnReminderFontClick(Sender: TObject);
begin
 if FontDialog1.Execute then begin
   btnReminderFont.Font := FontDialog1.Font;
   OptionsRec.setReminderTextFont(FontDialog1.Font);
 end;
end;



procedure TfrmOptions.OKButtonClick(Sender: TObject);
{ if ok clicked, change options record  }
begin
  OptionsRec.setGlobalTextFont(lblGlobalText.Font);
  OptionsRec.setFuzzyTextFont(lblFuzzyTime.Font);
  OptionsRec.setCountDownTextFont(lblCountDown.Font);
  OptionsRec.setTimerTextFont(lblTimerText.Font);
  OptionsRec.setReminderTextFont(lblReminderText.Font);
  OptionsRec.setDefaultTab(RdGrpDefault.ItemIndex);
  OptionsRec.setTimerMilliSeconds(ChckBxTimerMilli.Checked);

  writeIniFile;
end;

procedure TfrmOptions.CancelButtonClick(Sender: TObject);
{  if cancel clicked, revert to previous options record.  }
begin
  resetForm;
end;

procedure TfrmOptions.ChckBxScreenSaveChange(Sender: TObject);
begin
  if ChckBxScreenSave.Checked then
    OptionsRec.setScreenSave(True)
  else
    OptionsRec.setScreenSave(False)
end;


procedure TfrmOptions.SpdBtnDefaultClick(Sender: TObject);
{  reset all text colour back to colour of glocal text.                                            }
begin
  OptionsRec.GlobalTextFont      := frmOptions.Font;
  OptionsRec.FuzzyTextFont       := frmOptions.Font;
  OptionsRec.CountDownTextFont   := frmOptions.Font;
  OptionsRec.TimerTextFont       := frmOptions.Font;
  OptionsRec.ReminderTextFont    := frmOptions.Font;
  resetForm;
end;

procedure TfrmOptions.resetForm;
{  reset form to options record, used on form create, reset of default colour
   and if the cancel button is clicked.                                                            }
begin
  lblGlobalText.Font := OptionsRec.GlobalTextFont ;
  lblFuzzyTime.Font  := getTextFont(OptionsRec.FuzzyTextFont, OptionsRec.GlobalTextFont);
  lblCountDown.Font  := getTextFont(OptionsRec.CountDownTextFont, OptionsRec.GlobalTextFont);
  lblTimerText.Font      := getTextFont(OptionsRec.TimerTextFont, OptionsRec.GlobalTextFont);
  lblReminderText.Font   := getTextFont(OptionsRec.ReminderTextFont, OptionsRec.GlobalTextFont);

  ChckBxTimerMilli.Checked := OptionsRec.TimerMilliSeconds;
  ChckBxScreenSave.Checked := OptionsRec.ScreenSave;
end;



{  ********************************************************************************** ini file **  }

procedure TfrmOptions.checkIniFile;
{  if ini file exist - reads the options. if the file does not exost, create it.                   }
VAR
  code   : integer;
  defFnt : String;
begin
  defFnt  := FonttoString(frmOptions.Font);
  IniFile := TINIFile.Create(iniName);

  if (FileExists(iniName)) then begin  // read ini files and populate options record.
    val(iniFile.ReadString('klock', 'defaultTab', '0'), OptionsRec.DefaultTab, code);
    val(iniFile.ReadString('klock', 'ScreenTop',  '0'), OptionsRec.ScreenTop,  code);
    val(iniFile.ReadString('klock', 'ScreenLeft', '0'), OptionsRec.ScreenLeft, code);

    OptionsRec.ScreenSave          := StrtoBool(iniFile.ReadString('klock', 'ScreenSave', 'False'));

    OptionsRec.GlobalTextFont      := StringtoFont(iniFile.ReadString('labels', 'Font', defFnt));

    OptionsRec.FuzzyTextFont       := StringtoFont(iniFile.ReadString('Fuzzy', 'Font', defFnt));

    OptionsRec.CountDownTextFont   := StringtoFont(iniFile.ReadString('CountDown', 'Font', defFnt));

    OptionsRec.TimerTextFont       := StringtoFont(iniFile.ReadString('Timer', 'Font', defFnt));
    OptionsRec.TimerMilliSeconds   := StrToBool(iniFile.ReadString('Timer', 'Milli', 'False'));

    OptionsRec.ReminderTextFont    := StringtoFont(iniFile.ReadString('Reminder', 'Font', defFnt));
  end
  else begin  //  ini file does not exist, create it.
      writeIniValues
  end;

  iniFile.Free;
end;

procedure TfrmOptions.writeIniFile;
{  write optione record to ini file.                                                               }
begin
  IniFile := TINIFile.Create(iniName);

  writeIniValues;

  iniFile.Free;
end;

procedure TfrmOptions.writeIniValues;
{  actually perform the writing of the ini values.                                                 }
begin
  IniFile.WriteString('klock', 'Version', OptionsRec.Version);
  IniFile.WriteString('klock', 'defaultTab', IntToStr(OptionsRec.DefaultTab));
  IniFile.WriteString('klock', 'ScreenSave', BoolToStr(OptionsRec.ScreenSave));
  IniFile.WriteString('klock', 'ScreenTop',  IntToStr(OptionsRec.ScreenTop ));
  IniFile.WriteString('klock', 'ScreenLeft', IntToStr(OptionsRec.ScreenLeft));

  IniFile.Writestring('Labels', 'Font', FontToString(OptionsRec.GlobalTextFont));

  IniFile.Writestring('Fuzzy', 'Font', FontToString(OptionsRec.FuzzyTextFont));

  IniFile.Writestring('CountDown', 'Font', FontToString(OptionsRec.CountDownTextFont));

  IniFile.Writestring('Timer', 'Font', FontToString(OptionsRec.TimerTextFont));
  IniFile.Writestring('Timer', 'Milli',   BoolToStr(OptionsRec.TimerMilliSeconds));

  IniFile.Writestring('Reminder', 'Font', FontToString(OptionsRec.ReminderTextFont));
end;

end.

