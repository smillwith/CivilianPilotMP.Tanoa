_unit = _this select 0;
_jip = _this select 1;

// sleep 6;

_taskIndex = 0;
_taskName = format ["task%1", _taskIndex];
_taskTitle = "Select a plane or chopper to get started!";
_taskDescription = "Select a plane or helicopter to use by entering it.";
_markerForTask = "";

//taskCreate - Other style
//0: BOOL or OBJECT or GROUP or SIDE or ARRAY - Task owner(s)
//1: STRING or ARRAY - Task name or array in the format [task name, parent task name]
//2: ARRAY or STRING - Task description in the format ["description", "title", "marker"] or CfgTaskDescriptions class
//3: OBJECT or ARRAY or STRING - Task destination
//4: BOOL or NUMBER or STRING - Task state (or true to set as current)
//5: NUMBER - Task priority (when automatically selecting a new current task, higher priority is selected first)
//6: BOOL - Show notification (default: true)
//7: STRING - Task type as defined in the CfgTaskTypes
//8: BOOL - Should the task being shared (default: false), if set to true, the assigned players are being counted
[
  _unit,
  _taskName,
  [_taskDescription, _taskTitle, "x"],
  [],
  true,    //state
  1,       //priority
  true,    //show notif
  "interact",  //Task type
  false    //shared
] call BIS_fnc_taskCreate;

player setVariable ["IsOnBoarding", "1"];
