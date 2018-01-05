/*
V2 By: Ghost - tells helicopter when to rtb
a3cn_rtb_transport = _air1 addAction ["<t size='1.5' shadow='2' color='#00FFFF'>Helicopter RTB<</t> <img size='3' color='#00ff00'", "call a3cn_fnc_rtb_transport", [_air1,_flyheight,_spawnmark,_escortgrp,[_air1,_air2,_air3],_pname], 5, false, true, "","alive _target"];
*/
_args = _this select 3;
_air1 = _args select 0;
_flyheight = _args select 1;
_spawnmark = _args select 2;
_escortgrp = _args select 3;
_heloarray = _args select 4;
_pname = _args select 5;//player name that called it
_transportgrp = group _air1;

heli = _air1;

//_transportgrp setGroupOwner clientOwner;
//_escortgrp setGroupOwner clientOwner;

_transportgrp move _spawnmark;
_escortgrp move _spawnmark;
_air1 flyInHeight _flyheight;
_msg = format ["Transporte do %1 RTB.", _pname];
[_air1, _msg] remoteExec ["sideChat"];

waituntil { (_spawnmark distance2D _air1 < 100) or {!(alive _air1)} or {!(canmove _air1)} or {!(alive (driver _air1))}};

_air1 land "LAND";

waituntil { (unitReady _air1) or {!(alive _air1)} or {!(canmove _air1)} or {!(alive (driver _air1))}};	

_air1 flyInHeight 0;
	if (!(alive _air1) or {!(canmove _air1)} or {!(alive (driver _air1))}) then {
		_msg = format ["Nós perdemos o transporte do %1!", _pname];
		[[WEST,"AirBase"], _msg] remoteExec ["sideChat"];
	} else {
		_msg = format ["O transporte do %1 está na base", _pname];
		[[WEST,"AirBase"], _msg] remoteExec ["sideChat"];
	};
	
sleep 5;

//player removeAction a3cn_dest_transport;
//player removeAction a3cn_rtb_transport;


_spawnInitialPosition = [9231.83,-897.388,508.451];

_msg = format ["O transporte está aguardando desembarque para retornar a área de operações! Go go go!", _pname];
[[WEST,"AirBase"], _msg] remoteExec ["sideChat"];
waituntil {
	({_x in heli} count allPlayers - entities "HeadlessClient_F") == 0
};

_transportgrp move _spawnInitialPosition;
_escortgrp move _spawnInitialPosition;
_air1 flyInHeight _flyheight;

waituntil { (_spawnInitialPosition distance2D _air1 < 100) or {!(alive _air1)} or {!(canmove _air1)} or {!(alive (driver _air1))}};

{if !(isnil "_x") then {deletevehicle _x;};} foreach units _transportgrp;
{if !(isnil "_x") then {deletevehicle _x;};} foreach units _escortgrp;
{if !(isnil "_x") then {deletevehicle _x;};} foreach _heloarray;
deletegroup _transportgrp;
deletegroup _escortgrp;
