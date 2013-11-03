unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

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
    Panel1: TPanel;
    Label3: TLabel;
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

const
  MinHeight = 240;
  MaxHeight = 70;
  SpringForceIncrement = 4;
  SpringForceMax = 76;
  SpringWeight = 7;
  WorldAccel = 9.8;
  WorldAccelFrict = 0.23;
  WorldTop = 430;

var
  Form1: TForm1;

  SpringForce : Real = 0;

  SpringHeight : Real = 0;
  SpringAccel : Real = 0;
  Worldtime : Cardinal = 0;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Randomize;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  
  TimerKeyDown.Enabled := false;
  TimerFly.Enabled := false;
  
  ButtonFlag.Top := Random(MinHeight-MaxHeight) + MaxHeight;
  ButtonWall.Top := Random(MinHeight);
  while ButtonWall.Top > ButtonFlag.Top - ButtonWall.Height do
    ButtonWall.Top := Random(MinHeight);

  ButtonSpring.Enabled := True;
  ButtonSpring.Height := 80;
  ButtonSpring.Top := 430;
  ButtonSpring.SetFocus;

  SpringForce := 0;
  
end;

procedure TForm1.TimerKeyDownTimer(Sender: TObject);
begin
  SpringForce := SpringForce + SpringForceIncrement;
  ButtonSpring.Height := SpringForceMax - trunc(SpringForce);
  
  if SpringForce > SpringForceMax-10 then begin
    SpringAccel := SpringForce / SpringWeight;
    Worldtime := 0;
    
    TimerKeyDown.Enabled := False;
    TimerFly.Enabled := True;
    ButtonSpring.Enabled := False;
  end;

  Label3.Caption := FloatToStr(SpringForce);
end;

procedure TForm1.TimerFlyTimer(Sender: TObject);
begin
  SpringHeight := ( SpringAccel - WorldAccel* 0.5 ) * Worldtime * Worldtime * 0.0005;
  SpringAccel := SpringAccel - WorldAccelFrict;
  if SpringAccel < 0 then SpringAccel := 0;
  
  if SpringHeight < 0 then begin
    SpringHeight := 0;
    TimerFly.Enabled := False;
  end;

  ButtonSpring.Top := WorldTop - trunc(SpringHeight);
  Worldtime := Worldtime + TimerFly.Interval;

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
    TimerKeyDown.Enabled := False;
    TimerFly.Enabled := True;
    SpringAccel := SpringForce / SpringWeight;
    Worldtime := 0;
    ButtonSpring.Enabled := False;
  end;
end;

end.
