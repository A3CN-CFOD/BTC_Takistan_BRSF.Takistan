//Clear Respawn Tents
//this addaction ["<t size='1.4' shadow='2' color='#FF0000'>Clear Respawn Tents</t>", "call ghst_fnc_clear_respawn_tents", [], 1, false, false, "","alive _target"];
private ["_ghst_respawntent_data","_count","_i"];

_ghst_respawntent_data = missionNamespace getvariable "ghst_respawntent_data";
_count = (count _ghst_respawntent_data);

if (_count == 0) exitwith {hint "No respawn tents deployed"};

//diag_log _ghst_respawntent_data;
for "_i" from 0 to _count -1 do {
	((_ghst_respawntent_data select _i) select 2) call BIS_fnc_removeRespawnPosition;
	deletevehicle ((_ghst_respawntent_data select _i) select 0);
	deletemarker ((_ghst_respawntent_data select _i) select 1);
};
_ghst_respawntent_data = [];
missionnamespace setVariable ["ghst_respawntent_data", _ghst_respawntent_data, true];
//diag_log _ghst_respawntent_data;
hint format ["%1 respawn tents removed", _count];