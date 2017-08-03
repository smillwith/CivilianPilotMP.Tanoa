dingus_fnc_requestCompanion = {
  params ["_unit"];
  _current = ["CurrentCompanion"] call dingus_fnc_getVar;
  if (isNil {_current}) then {
    _unit globalChat "Sure thing. I'm right behind you.";
    _unit assignAsCommander (["CurrentVehicle"] call dingus_fnc_GetVar);
    [_unit] join (group player);
    missionNamespace setVariable ["CurrentCompanion", _unit];
  } else {
    systemChat "Can't add companion at this time."
  };
};

dingus_fnc_dismissCompanion = {
  params ["_unit"];
  _grp = createGroup civilian;
  [_unit] joinSilent _grp;
  missionNamespace setVariable ["CurrentCompanion", nil];
};

dingus_fnc_hasCompanion = {
  _ret = '0';
  _current = ["CurrentCompanion"] call dingus_fnc_getVar;
  if (!isNil {_current}) then {
    _ret = '1';
  };
  _ret;
};

//you can only command the copilot to land if he's driving a vehicle you're in and you're above the land
dingus_fnc_canLand = {
  _ret = '0';
  if (vehicle player != player) then {
    _companionDriving = (driver vehicle player) == copilot1;
    _pos = getPosATL player;
    _elevation = (_pos select 2);
    //_elevation = 5;

    if (_companionDriving) then {
      if (_elevation > 10) then {
        _ret = '1';
      };
    };
  };
  _ret;
};

copilot1 addAction [["Come with me."] call dingus_fnc_formatActionLabel, {[copilot1] call dingus_fnc_requestCompanion;}, [], 45, true, true, "", "([] call dingus_fnc_hasCompanion) == '0';"];
copilot1 addAction [["You're Dismissed."] call dingus_fnc_formatActionLabel, {[copilot1] call dingus_fnc_dismissCompanion;}, [], 45, false, true, "", "([] call dingus_fnc_hasCompanion) == '1';"];
player addAction [["Land Here."] call dingus_fnc_formatActionLabel, {(vehicle player) land "LAND";}, [], 45, true, true, "", "([] call dingus_fnc_canLand) == '1';"];
