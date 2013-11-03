unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

const
   ButtonSpringHeight = 90;

type
  TForm1 = class(TForm)
    ButtonSpring: TButton;
    ButtonFlag: TButton;
    ButtonWall: TButton;
    TimerKeyDown: TTimer;
    Button1: TButton;
    TimerFly: TTimer;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure TimerKeyDownTimer(Sender: TObject);
    procedure TimerFlyTimer(Sender: TObject);
    procedure ButtonSpringKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ButtonSpringKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses mechanica;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Randomize;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  MechanicNewLevel;

  TimerKeyDown.Enabled := false;
  TimerFly.Enabled := false;

  ButtonFlag.Top := trunc(FlagHeight);
  ButtonWall.Top := trunc(WallHeight);

  ButtonSpring.Enabled := True;
  ButtonSpring.Height := ButtonSpringHeight;
  ButtonSpring.Top := 430;
  ButtonSpring.SetFocus;
end;

procedure TForm1.TimerKeyDownTimer(Sender: TObject);
begin
  MechanicIncreaseForce;
  if SpringForce > SpringForceMax then begin
    MechanicCalcAccel;
    MechanicStart;

    TimerKeyDown.Enabled := False;
    TimerFly.Enabled := True;
    ButtonSpring.Enabled := False;
  end;

  ButtonSpring.Height := ButtonSpringHeight - trunc(SpringForce) ;

  Label3.Caption := FloatToStr(SpringForce);
end;

procedure TForm1.TimerFlyTimer(Sender: TObject);
begin
  MechanicUpdate(TimerFly.Interval);
  
  if (SpringHeight < 0.001)and(Worldtime > TimerFly.Interval) then begin
    TimerFly.Enabled := False;
    ButtonSpring.Enabled := True;
    MechanicResult;
    //Button1Click(Sender);
    Label4.Caption := IntToStr(Bonus);
    Label5.Caption := IntToStr(Crash);

    MechanicNewStep;
  end;

  ButtonSpring.Top := WorldTop - trunc(SpringHeight);

  Label1.Caption := FloatToStr(SpringHeight);
  Label2.Caption := FloatToStr(SpringAccel);

end;

procedure TForm1.ButtonSpringKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_SPACE
    then TimerKeyDown.Enabled := True;
end;

procedure TForm1.ButtonSpringKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_SPACE then begin
    MechanicCalcAccel;
    MechanicStart;
    
    TimerKeyDown.Enabled := False;
    TimerFly.Enabled := True;
    ButtonSpring.Enabled := False;
  end;
end;

end.
