/*
V2 By: Ghost - Server side init for transport system
[_spawnmark,_pos,_airtype,_flyheight,_escortarray,player] remoteExec ["a3cn_fnc_transportserver",2];
*/

_spawnmark = _this select 0;
_pos = _this select 1;
_airtype = _this select 2;
_flyheight = _this select 3;
_escortarray = _this select 4;
_p = _this select 5;//player that called it
_pname = name _p;

_transportgrp = createGroup (side _p);
_escortgrp = createGroup (side _p);

_dir = [_spawnmark, _pos] call BIS_fnc_dirTo;

//transport helicopter
_air1_array = [_spawnmark, _dir, _airtype, _transportgrp] call BIS_fnc_spawnVehicle;
_air1 = _air1_array select 0;
_air1 setpos [getpos _air1 select 0, getpos _air1 select 1, _flyheight];
_air1 setVelocity [55 * (sin _dir), 55 * (cos _dir), 0];
_air1 flyInHeight _flyheight;
_air1 lockDriver true;
_air1 lockCargo [0, true];
{_air1 lockTurret [_x, true];} foreach allTurrets _air1;
//_crewcount = count crew _air1;

//escort helicopter 1
_airtypesel = _escortarray call BIS_fnc_selectRandom;  
_air2_array = [[(_spawnmark select 0) + (cos _dir * 100), (_spawnmark select 1) - (sin _dir * 50), _flyheight + 50], _dir, _airtypesel, _escortgrp] call BIS_fnc_spawnVehicle;
_air2 = _air2_array select 0;
//_air2 setpos [getpos _air1 select 0, getpos _air1 select 1 -20, _flyheight];
_air2 setVelocity [55 * (sin _dir), 55 * (cos _dir), 0];
_air2 flyInHeight _flyheight + 50;

//escort helicopter 2
_airtypesel2 = _escortarray call BIS_fnc_selectRandom;  
_air3_array = [[(_spawnmark select 0) + (cos _dir * 50), (_spawnmark select 1) - (sin _dir * 100), _flyheight + 50], _dir, _airtypesel2, _escortgrp] call BIS_fnc_spawnVehicle;
_air3 = _air3_array select 0;
//_air3 setpos [getpos _air1 select 0 -20, getpos _air1 select 1, _flyheight];
_air3 setVelocity [55 * (sin _dir), 55 * (cos _dir), 0];
_air3 flyInHeight _flyheight + 50;

_transportgrp setBehaviour "CARELESS";
_escortgrp setBehaviour "COMBAT";

_transportgrp move _pos;
_escortgrp move _pos;

_msg = format ["%1 transport inbound to your location", _pname];
[_air1, _msg] remoteExec ["sideChat"];

_lzpad = "Land_HelipadEmpty_F" createVehicle _pos;
_lzpad_mark = [_pos,"ColorGreen","Pick Up","mil_start"] call a3cn_fnc_mark_point;

//tracking Marker
_trackname = format ["%1 Transport", _pname];
[_air1, "colorBLUFOR", "b_air", _trackname, true, true] spawn a3cn_fnc_tracker;

//waituntil {_pos distance2D _air1 < 400};

	while { ( (alive _air1) and {(canmove _air1)} and {(alive (driver _air1))} and {(_pos distance2D _air1 > 400)} ) } do {
		   sleep 1;
	};

_smoke = "SmokeShellGreen" createVehicle _pos;

	if ((alive _air1) and {(canmove _air1)} and {(alive (driver _air1))}) then {
		waituntil { (unitReady _air1) or {!(alive _air1)} or {!(canmove _air1)} or {!(alive (driver _air1))}};
		_p assignAsCargo _air1;
		[[_p], true] remoteExec ["orderGetIn",_p];
		_air1 land "GET IN";
		waituntil { ((getposatl _air1) select 2 < 1) or {!(alive _air1)} or {!(canmove _air1)} or {!(alive (driver _air1))}};
		_air1 flyInHeight 0;
		
		//a3cn_dest_transport = player addAction ["<t size='1.5' shadow='2' color='#00FF00'>Helicopter Destination</t>", "call a3cn_fnc_dest_transport", [_air1,_flyheight,_escortgrp], 5, false, true, "","alive _target"];
		
		a3cn_dest_transport = [_air1,["<t size='1.5' shadow='2' color='#00FF00'>Helicopter Destination</t>", "call a3cn_fnc_mappos", [_air1,_flyheight,_escortgrp,_pname], 5, false, true, "","alive _target"]] remoteExec ["addAction"]; 
		
		//a3cn_rtb_transport = player addAction ["<t size='1.5' shadow='2' color='#00FFFF'>Helicopter RTB</t>", "call a3cn_fnc_rtb_transport", [_air1,_flyheight,_spawnmark,_escortgrp,[_air1,_air2,_air3]], 5, false, true, "","alive _target"];
		
		a3cn_rtb_transport = [_air1,["<t size='1.5' shadow='2' color='#00FFFF'>Helicopter RTB</t>", {
			_this remoteExec ["a3cn_fnc_rtb_transport",2];
		}, [_air1,_flyheight,_spawnmark,_escortgrp,[_air1,_air2,_air3],_pname], 5, false, true, "","alive _target"]] remoteExec ["addAction"];
	};

waituntil { !(unitReady _air1) or {!(alive _air1)} or {!(canmove _air1)} or {!(alive (driver _air1))}};
deletevehicle _lzpad;
deletemarker _lzpad_mark;

	if (!(alive _air1) or {!(canmove _air1)} or {!(alive (driver _air1))}) then {
		_msg = format ["We lost %1 transport helicopter.", _pname];
		[[WEST,"AirBase"], _msg] remoteExec ["sideChat"];
	};
