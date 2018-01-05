//[[9231.83,-897.388,508.451],"B_T_VTOL_01_armed_F",0,[120,50],0,"_gunshipvar",player,true ] spawn a3cn_fnc_gunship;


   //V1.2 Script by: Ghost - calls in a gunship support aircraft until fuel is low or out of ammo then leaves
//
private ["_spawnmark","_type","_tos","_radaltarray","_rad","_flyheight","_delay","_timedelay","_supportvar","_veh_name","_dir","_pos","_chute1","_air1_array","_air1","_wGrp"];
_spawnmark = _this select 0;// spawn point where aircraft spawns and deletes
_gunship = _this select 1;// type of gunship "B_T_VTOL_01_armed_F"
_tos = (_this select 2) * 60;// time on station
_radaltarray = _this select 3;// radius and altitude array
	_rad = _radaltarray select 0;// radius aircraft will loiter
	_flyheight = _radaltarray select 1;// altitude aircraft will fly
_delay = (_this select 4) * 60;// time before air support can be called again
_supportvar = _this select 5;//variable in string format to check if support is available or not
_host = param [6, player, [objnull]];//what the action should be added to along with the gunship ie player
_global = param [7, false, [true]];//make it so the tracking variable is local or global

_veh_name = (configFile >> "cfgVehicles" >> _gunship >> "displayName") call bis_fnc_getcfgdata;

_timedelay = (player getVariable _supportvar);
if (Time < _timedelay) exitwith {hint format ["O suporte do %2 estará disponível em %1",((_timedelay - Time) call a3cn_fnc_timer), _veh_name];};

openMap true;

hint format ["Clique na área do mapa onde você deseja o suporte do %1 ou pressione ESC para cancelar.", _veh_name];

mapclick = false;

onMapSingleClick "clickpos = _pos; mapclick = true; onMapSingleClick """";true;";

waituntil {mapclick or !(visiblemap)};
if (!visibleMap) exitwith {
	hint "Suporte aéreo pronto!";
	};

_pos = [clickpos select 0, clickpos select 1, _flyheight];

sleep 1;

openMap false;

_wGrp = createGroup (side player);
_dir = _spawnmark getdir _pos;

_air1_array = [_spawnmark, _dir, _gunship, _wGrp] call BIS_fnc_spawnVehicle;
_air1 = _air1_array select 0;
_air1 setposatl [getposatl _air1 select 0, getposatl _air1 select 1, _flyheight];
_air1 setVelocity [55 * (sin _dir), 55 * (cos _dir), 0];

player setVariable [_supportvar, Time + _delay,_global];

sleep 1;

_air1 flyinheight _flyheight;
_air1 setSpeedMode "Normal";
//set combat mode
_wGrp setCombatMode "RED";
_wGrp setBehaviour "CARELESS";
_air1 lock true;
_air1 lockDriver true;

_air1 sidechat format ["%1 a caminho", _veh_name];

//[_wGrp,_pos, _rad, "MOVE", "CARELESS", "NORMAL"] call a3cn_fnc_createwaypoint;
_air1 move _pos;

{
a3cn_act105 = _x addAction ["<t size='1.2' shadow='2' color='#3399ff'>Canhões 20mm/105mm</t>", {
	_air1 = _this select 3;
	objNull remoteControl (crew _air1 select 3);
	player remoteControl (crew _air1 select 2); _air1 switchCamera "GUNNER";
}, _air1, 1, false, true, "","alive _target"];
a3cn_actgatling = _x addAction ["<t size='1.2' shadow='2' color='#0066ff'>Metralhadora 40mm</t>", {
	_air1 = _this select 3;
	objNull remoteControl (crew _air1 select 2);
	player remoteControl (crew _air1 select 3); _air1 switchCamera "GUNNER";
}, _air1, 1, false, true, "","alive _target"];
a3cn_movegunship = _x addAction ["<t size='1.2' shadow='2' color='#009933'>Destino do suporte</t>", {call a3cn_fnc_dest_gunship;}, [_air1,_wGrp,_rad], 1, false, true, "","alive _target"];
} foreach [_host,_air1];

//tracking Marker
_trackname = format ["%1 suporte", name player];
[_air1, "colorBLUFOR", "b_plane", _trackname, true] spawn a3cn_fnc_tracker;

waituntil { (_pos distance2D _air1 < _rad + 300) or {!(alive _air1)} or {!(canmove _air1)} or {!(alive (driver _air1))} };

_t = time;//current time

_wp =_wGrp addwaypoint [_pos, _rad];
_wp setWPPos _pos;
_wp setWaypointType "LOITER";
_wp setWaypointLoiterType "CIRCLE_L";
_wp setWaypointLoiterRadius _rad;
_air1 setSpeedMode "Normal";
_wp setWaypointSpeed "Normal";
_wGrp setCurrentWaypoint _wp;

While {time < (_t + _tos) and {(fuel _air1 > 0.25)}} do {
if (!(alive _air1) or {!(canMove _air1)}) exitwith {player groupChat format ["Droga! Perdemos o %1!", _veh_name];};
if !(someAmmo _air1) exitwith {player groupchat "Sem munição!";};
if !(alive player) then {objNull remoteControl (crew _air1 select 2);player switchCamera "internal"; objNull remoteControl (crew _air1 select 3);player switchCamera "internal";};
if !(alive (crew _air1 select 2)) then {objNull remoteControl (crew _air1 select 2);player switchCamera "internal";};
if !(alive (crew _air1 select 3)) then {objNull remoteControl (crew _air1 select 3);player switchCamera "internal";};
sleep 1;
};


_host removeAction a3cn_act105;
_host removeAction a3cn_actgatling;
_host removeAction a3cn_movegunship;

_air1 removeAction a3cn_act105;
_air1 removeAction a3cn_actgatling;
_air1 removeAction a3cn_movegunship;

objNull remoteControl (crew _air1 select 2);
objNull remoteControl (crew _air1 select 3);
player switchCamera "internal";

if ((alive _air1) and {canMove _air1}) then {

//[_wGrp,_spawnmark, 0, "MOVE", "CARELESS", "NORMAL"] call a3cn_fnc_createwaypoint;
_air1 move _spawnmark;
_air1 setSpeedMode "Normal";

_air1 sidechat "Preciso recarregar. RTB!";

waituntil {((getpos _air1) distance _spawnmark) < (_flyheight * 2)};

};

sleep 10;

{deletevehicle _x} foreach crew _air1;
deletevehicle _air1;

sleep 20;
deletegroup _wGrp;
