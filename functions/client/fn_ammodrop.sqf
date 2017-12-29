/*
V1.5 script by: Ghost - Creates specified aircraft and flys to point on map specified by left click and drops ammo box.
ghst_ammodrop = [player,300,"airtype","objdrop",300,30] spawn ghst_fnc_ammodrop;
*/
if (!local player) exitwith {};

_host = _this select 0;
_spawnmark = _this select 1;
_airtype = _this select 2;
_objdrop = _this select 3;
_flyheight = _this select 4;
_delay = (_this select 5) * 60;// time before ammo support can be called again

_timedelay = (player getVariable "ghst_ammodrop");
if (Time < _timedelay) exitwith {hint format ["Ammo Drop will be available in %1",((_timedelay - Time) call ghst_fnc_timer)];};

openMap true;

_host groupchat "Left click on the map where you want Ammo drop";

mapclick = false;

onMapSingleClick "clickpos = _pos; mapclick = true; onMapSingleClick """";true;";

waituntil {mapclick or !(visiblemap)};
if (!visibleMap) exitwith {
	hint "Ammo Drop Ready";
	};
_pos = [clickpos select 0, clickpos select 1, _flyheight];

sleep 1;

openMap false;

//ghst_dropammo = false;

//hint format ["%1", _pos];

_airgrp1 = createGroup (side player);

_dir = _spawnmark getdir _pos;

_air1_array = [_spawnmark, _dir, _airtype, _airgrp1] call BIS_fnc_spawnVehicle;
_air1 = _air1_array select 0;
_air1 setpos [getpos _air1 select 0, getpos _air1 select 1, _flyheight];
_air1 setVelocity [55 * (sin _dir), 55 * (cos _dir), 0];

player setVariable ["ghst_ammodrop", Time + _delay];

_air1 sidechat "I am inbound with your Ammo";

_air1 flyinheight _flyheight;
_airgrp1 setbehaviour "CARELESS";

_wpdrop = _airgrp1 addWaypoint [_pos, 0];
//[_airgrp1, 1] setWaypointStatements ["true", "ghst_dropammo = true;"];
[_airgrp1, 1] setWaypointSpeed "Normal";
[_airgrp1, 1] setWaypointBehaviour "CARELESS";

// Delete the crew and planes once they hit the egress point.
_wphome = _airgrp1 addWaypoint [_spawnmark, 0];

//tracking Marker
_trackname = format ["%1 Ammo Drop", name player];
[_air1, "colorBLUFOR", "b_support", _trackname, true] spawn ghst_fnc_tracker;

_time_delay = time + 600;
While {(alive _air1) and {canmove _air1}} do {// and (_air1 distance _pos) > 50

	sleep 1;
	if ((_air1 distance2D _pos) < 100) exitwith {};
	//if (ghst_dropammo and ((_air1 distance _pos) < (_flyheight + 100))) exitwith {};
	if (time >= (_time_delay)) exitwith {};
};

if (!(alive _air1) or {!(canMove _air1)} or {(time >= (_time_delay))}) then {player groupChat "Shit we lost air support";} else {

_dir = getdir _air1;
_chute1 = createVehicle ["B_Parachute_02_F",[0,0,0], [], 0, "FLY"];
_chute1 setdir _dir;
_chute1 setposatl [(getposatl _air1 select 0) - 20 * sin(_dir),(getposatl _air1 select 1) - 20 * cos(_dir),(getposatl _air1 select 2)];

_ghst_drop = createVehicle [_objdrop,[0,0,0], [], 0, "none"];
_ghst_drop attachTo [_chute1,[0,0,1]];

	[_ghst_drop] spawn {
		private ["_crate","_chem","_crate_name","_smoke"];
		_crate = _this select 0;
		
		waituntil {(getposatl _crate select 2) < 1.5}; 
		//detach _crate;
		_crate setposatl [getposatl _crate select 0,getposatl _crate select 1,0];
		_crate_name = "Ammo Box";//getText (configFile >> "cfgVehicles" >> (_droptype) >> "displayName");
		[_crate, "ColorBlack", "mil_box", _crate_name] spawn ghst_fnc_tracker;
		//_crate call ghst_fnc_magazines;
		_chem = createMine ["placed_chemlight_green", (position _crate), [], 0];
		sleep 3;
		_chem attachto [_crate,[0,0,0.1]];
		_smoke = "SmokeShellPurple" createVehicle (getPosatl _crate);
				
	};

_air1 sidechat "Ammo drop complete heading home";

};

sleep 120;

{deletevehicle _x} foreach crew _air1;
deletevehicle _air1;
sleep 5;
deletegroup _airgrp1;
/*
sleep _delay;

hint "Ammo Drop Ready";

player setVariable ["ghst_ammodrop", false];

if (true) exitwith {};
*/