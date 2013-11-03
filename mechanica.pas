unit mechanica;

interface

const
  MinHeight = 70;
  MaxHeight = 240;
  SpringForceMax = 67;
//  WorldTop = 430;

var
  SpringForce : Real;

  SpringHeight : Real;
  SpringAccel : Real;
  Worldtime : Cardinal;
  FlagHeight : Real;
  WallHeight : Real;

  Bonus : Cardinal;
  Crash : Cardinal;

  procedure MechanicNewStep;
  procedure MechanicNewLevel;
  procedure MechanicStart;
  procedure MechanicUpdate(const interval: Cardinal);
  procedure MechanicIncreaseForce;
  procedure MechanicResult;

implementation

const
  SpringForceIncrement = 2;    // для увеличения силы при нажатии 
  SpringWeight = 7;
  WorldAccel = 9.8;
  WorldAccelFrict = 0.23;      // для уменьшения ускорения

var
  SpringHeightMax : Real;
  SpringHeightMaxFlag : Boolean;


procedure MechanicNewStep;
begin
  SpringForce := 0;
  SpringHeight := 0;
  SpringAccel := 0;
  Worldtime := 0;

  SpringHeightMax := 0;
  SpringHeightMaxFlag := true;
end;

procedure MechanicNewLevel;
begin
  MechanicNewStep;
  Bonus := 0;
  Crash := 0;

  WallHeight := Random(MaxHeight) + MinHeight + 50; //чтобы всегда была выше флага
  FlagHeight := Random(MaxHeight) + MinHeight;
  while FlagHeight > WallHeight - 10 do     // учёт высота кнопки
    FlagHeight := Random(MaxHeight) + MinHeight;
end;

procedure MechanicStart;
begin
  Worldtime := 0;
  SpringAccel := SpringForce / SpringWeight;
end;

procedure MechanicIncreaseForce;
begin
  SpringForce := SpringForce + SpringForceIncrement;
end;

procedure MechanicUpdate(const interval: Cardinal);
begin
  if SpringHeightMaxFlag
    then SpringHeightMax := SpringHeight; // запоминаем МАХ раньше, чем оно станет уменьшаться 

  SpringHeight := ( SpringAccel - WorldAccel*0.5 ) * Worldtime * Worldtime * 0.0005;
  if SpringHeight < 0
    then SpringHeight := 0;

  SpringAccel := SpringAccel - WorldAccelFrict;
  if SpringAccel < 0
    then SpringAccel := 0;

  if (SpringHeightMaxFlag)and(SpringHeightMax - SpringHeight > 0) then begin
    SpringHeightMaxFlag := false;
    SpringHeightMax := SpringHeight;        
  end;

  Worldtime := Worldtime + interval;
end;

procedure MechanicResult;
begin
  // если достигнутая МАХ высота больше чем высота флага, значит мы его схватили
  // если высота больше чем стена, значит перескочили
  if SpringHeightMax > FlagHeight
    then if SpringHeightMax > WallHeight
      then Crash := Crash + 1
        else Bonus := Bonus + 1;   
end;

end.
