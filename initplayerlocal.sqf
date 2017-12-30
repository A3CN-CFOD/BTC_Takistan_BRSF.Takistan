waituntil {! isnull player};

//RHS Escalation Detect
_PARAM_RHS = "PARAM_RHS" call BIS_fnc_getParamValue;
if ((isClass(configFile >> "CfgPatches" >> "rhs_main")) and (_PARAM_RHS == 1)) then {
	ghst_rhsmod = true;
	ghst_attackplane = ["B_Plane_CAS_01_F","B_Plane_CAS_01_F","B_Plane_Fighter_01_F","B_Plane_Fighter_01_Stealth_F"];
	ghst_gunship = "B_T_VTOL_01_armed_F";
	ghst_attachhelo = ["B_Heli_Attack_01_F","B_Heli_Light_01_armed_F"];
	ghst_transportheli = "B_Heli_Transport_01_camo_F";
	ghst_airliftheli = "B_Heli_Transport_03_F";
	ghst_escortheli = ["B_Heli_Attack_01_F"];
} else {
	ghst_rhsmod = false;
	ghst_attackplane = ["B_Plane_CAS_01_F","B_Plane_CAS_01_F","B_Plane_Fighter_01_F","B_Plane_Fighter_01_Stealth_F"];
	ghst_gunship = "B_T_VTOL_01_armed_F";
	ghst_attachhelo = ["B_Heli_Attack_01_F","B_Heli_Light_01_armed_F"];
	ghst_transportheli = "B_Heli_Transport_01_camo_F";
	ghst_airliftheli = "B_Heli_Transport_03_F";
	ghst_escortheli = ["B_Heli_Attack_01_F"];
};
PARAM_Cooldowns = "PARAM_Cooldowns" call BIS_fnc_getParamValue;

//UAV Types
ghst_uav = ["B_T_UAV_03_F","B_UAV_02_F","B_UAV_02_CAS_F","B_UAV_05_F"];
//West Cargo Aircraft type
ghst_air_cargo = "B_Heli_Transport_03_F";
if ghst_rhsmod then {ghst_air_cargo = B_Heli_Transport_03_F";};

if ghst_rhsmod then {
	call ghst_fnc_rhs_vehiclelist;
	call ghst_fnc_rhs_aircraftlist;
	call ghst_fnc_rhs_boatlist;
} else {
	call ghst_fnc_vehiclelist;
	call ghst_fnc_aircraftlist;
	call ghst_fnc_boatlist;
};

#include "addnotes.sqf"

if (player iskindof "B_recon_JTAC_F") then {
[player,"Attackhelo"] call BIS_fnc_addCommMenuItem;
player setVariable ["ghst_helosup", 0];
player setVariable ["ghst_helosup2", 0];

[player,"Attackplane"] call BIS_fnc_addCommMenuItem;
player setVariable ["ghst_cassup", 0];

[player,"RemoteDesignator"] call BIS_fnc_addCommMenuItem;
player setVariable ["ghst_remotedes", 0];

[player,"Gunship"] call BIS_fnc_addCommMenuItem;
};
_gunshipvar = (player getVariable "ghst_gunship");
if (isnil "_gunshipvar") then {
	player setVariable ["ghst_gunship", 0];
} else {
	player setVariable ["ghst_gunship", _gunshipvar];
};

if (player iskindof "B_soldier_UAV_F") then {
[player,"UAV"] call BIS_fnc_addCommMenuItem;
player setVariable ["ghst_uavsup", 0];
player setVariable ["ghst_ugvsup", [0,0]];
player setVariable ["ghst_puavsup", 0];

[player,"RemoteDesignator"] call BIS_fnc_addCommMenuItem;
player setVariable ["ghst_remotedes", 0];
};

if (player iskindof "B_Soldier_SL_F") then {
[player,"AMMO"] call BIS_fnc_addCommMenuItem;
player setVariable ["ghst_ammodrop", 0];

[player,"PUAV"] call BIS_fnc_addCommMenuItem;
player setVariable ["ghst_puavsup", 0];

[player,"RESPAWNTENT"] call BIS_fnc_addCommMenuItem;
player setVariable ["ghst_respawntent", 0];
};

[player,"CARGO"] call BIS_fnc_addCommMenuItem;
player setVariable ["ghst_cargodrop", 0];

[player,"Transport"] call BIS_fnc_addCommMenuItem;
player setVariable ["ghst_transport", 0];
player setVariable ["ghst_airlift", 0];

[player,"Viewdistance"] call BIS_fnc_addCommMenuItem;
[player,"AdddesBat"] call BIS_fnc_addCommMenuItem;
[player,"Debug"] call BIS_fnc_addCommMenuItem;

waituntil { !(isnil "ghst_vehiclelist")};

//addactions for halo and vehspawn. Should ensure them showing even with jip
vehspawn addAction ["<t size='1.5' shadow='2' color='#FFA000'>Spawn Armor</t> <img size='3' color='#FFA000' shadow='2' image='\A3\armor_f_gamma\MBT_01\Data\UI\Slammer_M2A1_Base_ca.paa'/>", "call ghst_fnc_spawnveh", ["veh_spawn",(markerDir "veh_spawn"),ghst_armorlist], 6, true, true, "","alive _target"];
vehspawn setObjectTexture [0, "\A3\armor_f_gamma\MBT_01\Data\UI\Slammer_M2A1_Base_ca.paa"];
vehspawn addAction ["<t size='1.5' shadow='2' color='#ff634d'>Spawn Car</t> <img size='3' color='#ff634d' shadow='2' image='\A3\Soft_F_Exp\LSV_01\Data\UI\LSV_01_base_CA.paa'/>", "call ghst_fnc_spawnveh", ["veh_spawn",(markerDir "veh_spawn"),ghst_carlist], 6, true, true, "","alive _target"];
vehspawn addAction ["<t size='1.5' shadow='2' color='#9af2ff'>Spawn Static</t> <img size='3' color='#9af2ff' shadow='2' image='\A3\Static_f_gamma\data\ui\gear_StaticTurret_MG_CA.paa'/>", "call ghst_fnc_spawnveh", ["veh_spawn",(markerDir "veh_spawn"),ghst_staticvehlist], 6, true, true, "","alive _target"];

airspawn addAction ["<t size='1.5' shadow='2' color='#FFA000'>Spawn Aircraft</t> <img size='3' color='#FFA000' shadow='2' image='\A3\Air_F_EPC\Plane_CAS_01\Data\UI\Plane_CAS_01_CA.paa'/>", "call ghst_fnc_spawnair", [(getmarkerpos "air_spawn"),(markerDir "air_spawn")], 6, true, true, "","alive _target"];
airspawn setObjectTexture [0, "\A3\Air_F_EPC\Plane_CAS_01\Data\UI\Plane_CAS_01_CA.paa"];

airspawn2 addAction ["<t size='1.5' shadow='2' color='#FFA000'>Spawn Aircraft</t> <img size='3' color='#FFA000' shadow='2' image='\A3\Air_F_Jets\Plane_Fighter_01\Data\UI\Fighter01_picture_ca.paa'/>", "call ghst_fnc_spawnair", [[getposatl air_spawn2 select 0,getposatl air_spawn2 select 1,getposatl air_spawn2 select 2],180], 6, true, true, "","alive _target"];
airspawn2 setObjectTexture [0, "\A3\Air_F_Jets\Plane_Fighter_01\Data\UI\Fighter01_picture_ca.paa"];

boatspawn addAction ["<t size='1.5' shadow='2' color='#FFA000'>Spawn Boat</t> <img size='3' color='#FFA000' shadow='2' image='\A3\boat_f_beta\SDV_01\data\ui\portrait_SDV_ca.paa'/>", "call ghst_fnc_spawnboat", ["boat_spawn",(markerDir "boat_spawn")], 6, true, true, "","alive _target"];
boatspawn setObjectTexture [0, "\A3\boat_f_beta\SDV_01\data\ui\portrait_SDV_ca.paa"];

halo addAction ["<t size='1.5' shadow='2' color='#00ffff'>HALO</t> <img size='3' color='#00ffff' shadow='2' image='\A3\Air_F_Beta\Parachute_01\Data\UI\Portrait_Parachute_01_CA.paa'/>", "call ghst_fnc_halo", [false,1000,60,false], 5, true, true, "","alive _target"];

halo addaction ["<t size='1.4' shadow='2' color='#FF0000'>Clear Respawn Tents</t>", "call ghst_fnc_clear_respawn_tents", [], 1, false, false, "","alive _target"];
halo setObjectTexture [0, "\A3\Characters_F\data\ui\icon_b_parachute_ca.paa"];

halo2 addAction ["<t size='1.5' shadow='2' color='#00ffff'>HALO</t> <img size='3' color='#00ffff' shadow='2' image='\A3\Air_F_Beta\Parachute_01\Data\UI\Portrait_Parachute_01_CA.paa'/>", "call ghst_fnc_halo", [false,1000,60,false], 5, true, true, "","alive _target"];
halo2 setObjectTexture [0, "\A3\Characters_F\data\ui\icon_b_parachute_ca.paa"];

port_teleport addAction ["<t size='1.5' shadow='2' color='#8904B1'>Move to Port</t> <img size='3' color='#8904B1' shadow='2' image='\A3\boat_f_beta\SDV_01\data\ui\portrait_SDV_ca.paa'/>", {player setposasl [getmarkerpos "spawn_board_3" select 0,getmarkerpos "spawn_board_3" select 1,1.5];}, [], 5, true, true, "","alive _target"];
port_teleport setObjectTexture [0, "\A3\boat_f_beta\SDV_01\data\ui\portrait_SDV_ca.paa"];

boatspawn addAction ["<t size='1.5' shadow='2' color='#8904B1'>Move to Base</t> <img size='3' color='#8904B1' shadow='2' image='\A3\air_f_beta\Heli_Transport_01\Data\UI\Heli_Transport_01_base_CA.paa'/>", {player setposatl [getmarkerpos "Respawn_West" select 0,getmarkerpos "Respawn_West" select 1,0.2];}, [], 5, false, true, "","alive _target"];

port_teleport addAction ["<t size='1.5' shadow='2' color='#4863A0'>Move to USS Freedom</t>", {player setposasl [getposasl spawn_freedom select 0,getposasl spawn_freedom select 1,getposasl spawn_freedom select 2 + 0.2];}, [], 5, true, true, "","alive _target"];

spawn_freedom addAction ["<t size='1.5' shadow='2' color='#8904B1'>Move to Base</t> <img size='3' color='#8904B1' shadow='2' image='\A3\air_f_beta\Heli_Transport_01\Data\UI\Heli_Transport_01_base_CA.paa'/>", {player setposatl [getmarkerpos "Respawn_West" select 0,getmarkerpos "Respawn_West" select 1,0.2];}, [], 5, false, true, "","alive _target"];

gunship_support = comp1 addAction ["<t size='1.5' shadow='2' color='#00cc99'>Call In Gunship</t>", {gunship_support = [(getmarkerpos "ghst_player_support"),ghst_gunship,60,[800, 500],PARAM_Cooldowns,"ghst_gunship",comp1,true] spawn ghst_fnc_gunship;}, [], 5, true, true, "",""];