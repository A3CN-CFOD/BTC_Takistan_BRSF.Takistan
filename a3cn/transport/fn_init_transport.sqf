/*
V2 By: Ghost - creates helicopter to pickup caller
a3cn_transport = ["typeofhelicopter","typeofhelicopter for escort in array []","spawn pos",50 alt, 30 min delay] spawn a3cn_fnc_init_transport;
*/

private ["_pos"];
_airtype = _this select 0;
_escortarray = _this select 1;
_spawnmark = _this select 2;
_flyheight = _this select 3;
_delay = (_this select 4) * 60;// time before Transport can be called again

_timedelay = (player getVariable "a3cn_transport");
if (Time < _timedelay) exitwith {hint format ["Um novo transporte estará disponível em %1",((_timedelay - Time) call a3cn_fnc_timer)];};

private ["_lzpad","_lzpad2","_lzpad_mark","_lzpad2_mark","_wpgetout","_destact","_destrtb"];

openMap true;

hint "Clique com o botão esquerdo onde você deseja o pouso do transporte";

mapclick = false;

onMapSingleClick "clickpos = _pos; mapclick = true; onMapSingleClick """";true;";

waituntil {mapclick or !(visiblemap)};
if (!visibleMap) exitwith {
	hint "O transporte está pronto!";
	};
	
_pos = [clickpos select 0, clickpos select 1, (getposatl player) select 2];
/*
_pos = _clickpos findEmptyPosition[ 10 , 100 , _airtype ];
if (count _pos < 2) then {
_pos = clickpos;
};
*/
sleep 1;

openMap false;
if (surfaceiswater _pos) exitwith {hint "O helicóptero não pode pousar na água!";};

player setVariable ["a3cn_transport", Time + _delay];

[_spawnmark,_pos,_airtype,_flyheight,_escortarray,player] remoteExec ["a3cn_fnc_transportserver",2];
