//====================================================
// These need to change depending on your map.
//====================================================

dingus_fnc_getAirportMarkers = {
  _markers = ["m_airport_tuvanaka", "m_airport_tanoa", "m_airport_stgeorge", "m_airport_larochelle", "m_airport_baja"];
  _markers;
};

dingus_fnc_getDriverSpawnMarkers = {
  //populate the markers array dynamically
  _midx = 0;
  _mmax = 8;      // <--- Update to use the total number of blank markers for drivers
  _markers = [];

  while {_midx <= _mmax} do {
    _markers pushBack (format ['driver_spawn_air_%1', _midx]);
    _midx = _midx + 1;
  };

  _markers;
};

//====================================================
// End of changes per map
//====================================================



//====================================================
// Main AI spawn and waypoint / trigger Functions
//====================================================

// This is the main function that spawns drivers using markers as starting points
// ex: [] spawn {[] call dingus_fnc_spawnAI};
dingus_fnc_spawnAI = {
  //Randomly generated drivers
  _models = ["C_Man_casual_1_F_tanoan", "C_man_sport_1_F_afro", "C_Man_casual_1_F_asia", "C_man_1"];

  //Vehicles that can spawn
  _vehicles = ["C_Plane_Civil_01_F"];

  _markers = [] call dingus_fnc_getAirportMarkers; //dingus_fnc_getDriverMarkers;
  _spawnMarkers = [] call dingus_fnc_getDriverSpawnMarkers;
  _maxDrivers = 6;   //<--- MAX DRIVERS per Call
  _driverIdx = 0;
  _markerIdx = 0;

  while { (_driverIdx < _maxDrivers) } do {
    //Create a vehicle, group and leader
    _group = createGroup [civilian, true];
    _group setFormation "LINE";
    _group setBehaviour "SAFE";

    //This version lets createVehicle pick which location to use...and supports Z axis locations
    _vehicle = createVehicle [(_vehicles select floor random count _vehicles), [0, 0, 0], _spawnMarkers, 0, "FLY"];
    //_vehicle allowDamage false;

    _leader = _group createUnit [_models select floor random count _models, (getPos _vehicle), [], 2, "NONE"];
    _leader assignAsDriver _vehicle;
    _leader moveInDriver _vehicle;
    _grp = group _leader;
    //Give the group a name
    _grp setGroupId [format ["Caesar N1%1J", floor random 999]];
    
    _vehicle flyInHeight ((floor random 200) + 150);
    
    [_leader] call dingus_fnc_addDriverWaypoints;
    
    _driverIdx = (_driverIdx + 1);
    _markerIdx = (_markerIdx + 1);
    
    //Need to wait a few seconds in case you end up spawning two planes at the same marker
    sleep 25;
  };

  // systemChat format ["Spawned %1 AI pilots.", _driverIdx];
};

dingus_fnc_addDriverWaypoints = {
  params ["_unit"];

  _markers = [] call dingus_fnc_getAirportMarkers;

  //systemChat format ['creating waypoints for: %1', _unit];

  _count = 3; //Number of waypoints to use before cycling
  _idx = 0;

  //Capture their starting position
  _startingPos = (getPosATL _unit);

  while { _idx < _count } do {
    //Get a random marker
    _marker = _markers select floor random count _markers;

    //systemChat format ['marker pos: %1', markerPos _marker];

    //Add the waypoint
    _wp = (group _unit) addWaypoint [getMarkerPos _marker, _idx];
    _wp setWaypointSpeed "FULL";
    _idx = _idx + 1;

    // HACK - avoid certain airports for now
    if (_marker != "m_airport_tanoa" && _marker != "m_airport_baja") then {
      
      //Add an activation statement for this waypoint
      //_wp setWaypointStatements ["true", "(vehicle this) land ""LAND"";"];
      _wp setWaypointStatements ["true", "[this] call dingus_fnc_driverWaypointReached;"];
    }
  };

  //Add a trigger to check fuel level
  _tr = createTrigger ["EmptyDetector", [0, 0, 0]];
  _tr setTriggerArea [50, 50, 0, false, 0];
  _tr setTriggerActivation ["NONE", "PRESENT", true]; //repeatable!
  _tr triggerAttachVehicle [_unit];
  _tr setTriggerStatements ["[thisList, thisTrigger] call dingus_fnc_driverVehicleFuelTriggerCondition", "[thisList, thisTrigger] call dingus_fnc_driverVehicleFuelTriggerActivated", ""];

  //Add a cycle waypoint? It works but the statement never fires as far as I can see
  _wpc = (group _unit) addWaypoint [_startingPos, _idx];
  _wpc setWaypointType "CYCLE";
  // _wpc setWaypointStatements ["true", "hint 'hello i just cycled';"]; 
};

dingus_fnc_driverWaypointReached = {
  params ["_unit"];
  //IN this version, we're going to randomly determine if they should land or not
  _rand = floor random 30;
  _doLand = _rand > 10;
  if (_doLand) then {
    (vehicle _unit) land ""LAND"";
  };
};

dingus_fnc_driverVehicleFuelTriggerActivated = {
  params ["_list", "_trigger"]; 

  _obj = triggerAttachedVehicle _trigger;

  if (vehicle _obj != _obj) then {
    vehicle _obj setFuel 1.0;
  };
};

dingus_fnc_driverVehicleFuelTriggerCondition = {
  params ["_list", "_trigger"];
  _ret = false;

  _obj = triggerAttachedVehicle _trigger;

  if (isNil "_obj") then {
    _ret = false;
  } else {
    //systemChat format ["Here with %1. Vehicle: %2. Fuel: %3", _obj, vehicle _obj, fuel vehicle _obj];
    //systemChat format ["Here with %1",  _obj];
    _ret = false;

    if (vehicle _obj != _obj) then {
      if (fuel (vehicle  _obj) < 0.25) then {
        _ret = true;
      };
    };
  };
  _ret;
};
