//titleText ["Please wait...", "BLACK OUT", 0];

//Set Darkness
_hoursToskip = ["darkness", -1] call BIS_fnc_getParamValue;
skiptime _hoursToskip;

_handle = execVM "common.sqf"; 
waitUntil { scriptDone _handle };

//Global vars
["HelpersVisible", "0"] call dingus_fnc_setGlobalVar;

//Player variables
["MarkersVisible", "1"] call dingus_fnc_setVar;
["TaskLocations", "1"] call dingus_fnc_setVar;
["Boarding", "0"] call dingus_fnc_setVar;
["Boarded", "0"] call dingus_fnc_setVar;
["Transporting", "0"] call dingus_fnc_setVar;
["Arrived", "0"] call dingus_fnc_setVar;
["DestinationAirport", ""] call dingus_fnc_setVar;
["CurrentPassenger", nil] call dingus_fnc_setVar;
["CurrentCompanion", nil] call dingus_fnc_setVar;
["OnBoarding", "0"] call dingus_fnc_setVar;

if (isServer) then {
  execVM "ai.sqf";
  execVM "passengers.sqf";
}

execVM "companion.sqf";
execVM "planeHelpers.sqf";

/*[] spawn {
  sleep 5;
  titleFadeOut 5;
};*/

//titleFadeOut 5;
