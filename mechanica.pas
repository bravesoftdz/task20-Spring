unit mechanica;

interface

const
  MinHeight = 240;
  MaxHeight = 70;
  SpringForceMax = 67;
  WorldTop = 430;

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
  function MechanicIncreaseForce : Real;
  procedure MechanicCalcAccel;
  procedure MechanicResult;

implementation


const
  SpringForceIncrement = 4;
  SpringWeight = 7;
  WorldAccel = 9.8;
  WorldAccelFrict = 0.23;
  WorldBound = 1;

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

  FlagHeight := Random(MinHeight-MaxHeight) + MaxHeight;
  WallHeight := Random(MinHeight);
  while WallHeight > FlagHeight - 10 do //высота кнопки
    WallHeight := Random(MinHeight);
end;

procedure MechanicStart;
begin
  Worldtime := 0;
end;

function MechanicIncreaseForce : Real;
begin
  SpringForce := SpringForce + SpringForceIncrement;

  Result := SpringForce;
end;

procedure MechanicCalcAccel;
begin
  SpringAccel := SpringForce / SpringWeight;
end;

procedure MechanicUpdate(const interval: Cardinal);
begin
  SpringHeightMax := SpringHeight;
  SpringHeight := ( SpringAccel - WorldAccel* 0.5 ) * Worldtime * Worldtime * 0.0005;
  if SpringHeight < 0
    then SpringHeight := 0;

  SpringAccel := SpringAccel - WorldAccelFrict;
  if SpringAccel < 0
    then SpringAccel := 0;

  if (SpringHeightMaxFlag)and(SpringHeightMax - SpringHeight > 0) then begin
    SpringHeightMaxFlag := false;
    SpringHeightMax := SpringHeight;
  end;

  {if abs(FlagHeight - SpringHeight) < WorldBound
    then Bonus := Bonus + 1;

  if abs(WallHeight - SpringHeight) < WorldBound
    then Crash := Crash + 1;    }

  Worldtime := Worldtime + interval;
end;

procedure MechanicResult;
begin
  if SpringHeightMax > FlagHeight
    then if SpringHeightMax > WallHeight
      then Crash := Crash + 1
        else Bonus := Bonus + 1;   
end;

end.
