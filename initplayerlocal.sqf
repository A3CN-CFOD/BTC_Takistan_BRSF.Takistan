waituntil {! isnull player};





// Constantes

#define TRANSPORT_DELAY 15 // Tempo necessário área chamar o transporte novamente. Em minutos.
#define TRANSPORT_HELO "B_Heli_Transport_01_F"

#define GUNSHIP_DELAY 25 // Tempo necessário para chamar o Gunship novamente. Em minutos.
#define ESCORT_HELO "RHS_AH64D"
#define GUNSHIP_HELO "B_T_VTOL_01_armed_F"


// Condições

 _gunshipvar = (player getVariable "a3cn_gunship");
 if (isnil "_gunshipvar") then {
	player setVariable ["a3cn_gunship", 0];
 } else {
	player setVariable ["a3cn_gunship", _gunshipvar];
 };

player setVariable ["a3cn_transport",0];

// Menu

_action = ["Suporte", "Suporte", "imagens\radio.paa", {},{player iskindof "B_recon_JTAC_F" || player iskindof "B_Soldier_SL_F"}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;


_action = [ "callTransport",
						"Chamar Transporte",
						"imagens\radio.paa",
{[TRANSPORT_HELO,[ESCORT_HELO],[9231.83,-897.388,508.451],50,TRANSPORT_DELAY] remoteExec ["a3cn_fnc_init_transport",2]},
{player iskindof "B_Soldier_SL_F"}
] call ace_interact_menu_fnc_createAction;

[player, 1, ["ACE_SelfActions", "Suporte"], _action] call ace_interact_menu_fnc_addActionToObject;



_action = ["callGunship",
 						"Chamar Gunship",
						"imagens\radio.paa", {
						[[9231.83,-897.388,508.451],GUNSHIP_HELO,0,[200,800],GUNSHIP_DELAY,"a3cn_gunship",player,true ] remoteExec ["a3cn_fnc_gunship",2]
						},
						{player iskindof "B_recon_JTAC_F"}
] call ace_interact_menu_fnc_createAction;

[player, 1, ["ACE_SelfActions", "Suporte"], _action] call ace_interact_menu_fnc_addActionToObject;





[] execVM "HALs_fnc_limitThirdPerson.sqf";



/* if (player iskindof "B_recon_JTAC_F") then { */
/* [player,"Attackhelo"] call BIS_fnc_addCommMenuItem; */
/* player setVariable ["ghst_helosup", 0]; */
/* player setVariable ["ghst_helosup2", 0]; */


/* [player,"Attackplane"] call BIS_fnc_addCommMenuItem; */
/* player setVariable ["ghst_cassup", 0]; */

/* [player,"RemoteDesignator"] call BIS_fnc_addCommMenuItem; */
/* player setVariable ["ghst_remotedes", 0]; */

/* [player,"Gunship"] call BIS_fnc_addCommMenuItem; */
/* }; */
/* _gunshipvar = (player getVariable "ghst_gunship"); */
/* if (isnil "_gunshipvar") then { */
/* 	player setVariable ["ghst_gunship", 0]; */
/* } else { */
/* 	player setVariable ["ghst_gunship", _gunshipvar]; */
/* }; */

/* if (player iskindof "B_soldier_UAV_F") then { */
/* [player,"UAV"] call BIS_fnc_addCommMenuItem; */
/* player setVariable ["ghst_uavsup", 0]; */
/* player setVariable ["ghst_ugvsup", [0,0]]; */
/* player setVariable ["ghst_puavsup", 0]; */

/* [player,"RemoteDesignator"] call BIS_fnc_addCommMenuItem; */
/* player setVariable ["ghst_remotedes", 0]; */
/* }; */

/* [player,"CARGO"] call BIS_fnc_addCommMenuItem; */
/* player setVariable ["ghst_cargodrop", 0]; */

/* [player,"Transport"] call BIS_fnc_addCommMenuItem; */
/* player setVariable ["ghst_transport", 0]; */
/* player setVariable ["ghst_airlift", 0]; */

/* [player,"Viewdistance"] call BIS_fnc_addCommMenuItem; */
/* [player,"AdddesBat"] call BIS_fnc_addCommMenuItem; */
/* [player,"Debug"] call BIS_fnc_addCommMenuItem; */

/* waituntil { !(isnil "ghst_vehiclelist")}; */

/* //addactions for halo and vehspawn. Should ensure them showing even with jip */
/* vehspawn addAction ["<t size='1.5' shadow='2' color='#FFA000'>Spawn Armor</t> <img size='3' color='#FFA000' shadow='2' image='\A3\armor_f_gamma\MBT_01\Data\UI\Slammer_M2A1_Base_ca.paa'/>", "call ghst_fnc_spawnveh", ["veh_spawn",(markerDir "veh_spawn"),ghst_armorlist], 6, true, true, "","alive _target"]; */
/* vehspawn setObjectTexture [0, "\A3\armor_f_gamma\MBT_01\Data\UI\Slammer_M2A1_Base_ca.paa"]; */
/* vehspawn addAction ["<t size='1.5' shadow='2' color='#ff634d'>Spawn Car</t> <img size='3' color='#ff634d' shadow='2' image='\A3\Soft_F_Exp\LSV_01\Data\UI\LSV_01_base_CA.paa'/>", "call ghst_fnc_spawnveh", ["veh_spawn",(markerDir "veh_spawn"),ghst_carlist], 6, true, true, "","alive _target"]; */
/* vehspawn addAction ["<t size='1.5' shadow='2' color='#9af2ff'>Spawn Static</t> <img size='3' color='#9af2ff' shadow='2' image='\A3\Static_f_gamma\data\ui\gear_StaticTurret_MG_CA.paa'/>", "call ghst_fnc_spawnveh", ["veh_spawn",(markerDir "veh_spawn"),ghst_staticvehlist], 6, true, true, "","alive _target"]; */

/* airspawn addAction ["<t size='1.5' shadow='2' color='#FFA000'>Spawn Aircraft</t> <img size='3' color='#FFA000' shadow='2' image='\A3\Air_F_EPC\Plane_CAS_01\Data\UI\Plane_CAS_01_CA.paa'/>", "call ghst_fnc_spawnair", [(getmarkerpos "air_spawn"),(markerDir "air_spawn")], 6, true, true, "","alive _target"]; */
/* airspawn setObjectTexture [0, "\A3\Air_F_EPC\Plane_CAS_01\Data\UI\Plane_CAS_01_CA.paa"]; */

/* airspawn2 addAction ["<t size='1.5' shadow='2' color='#FFA000'>Spawn Aircraft</t> <img size='3' color='#FFA000' shadow='2' image='\A3\Air_F_Jets\Plane_Fighter_01\Data\UI\Fighter01_picture_ca.paa'/>", "call ghst_fnc_spawnair", [[getposatl air_spawn2 select 0,getposatl air_spawn2 select 1,getposatl air_spawn2 select 2],180], 6, true, true, "","alive _target"]; */
/* airspawn2 setObjectTexture [0, "\A3\Air_F_Jets\Plane_Fighter_01\Data\UI\Fighter01_picture_ca.paa"]; */

/* boatspawn addAction ["<t size='1.5' shadow='2' color='#FFA000'>Spawn Boat</t> <img size='3' color='#FFA000' shadow='2' image='\A3\boat_f_beta\SDV_01\data\ui\portrait_SDV_ca.paa'/>", "call ghst_fnc_spawnboat", ["boat_spawn",(markerDir "boat_spawn")], 6, true, true, "","alive _target"]; */
/* boatspawn setObjectTexture [0, "\A3\boat_f_beta\SDV_01\data\ui\portrait_SDV_ca.paa"]; */

/* halo addAction ["<t size='1.5' shadow='2' color='#00ffff'>HALO</t> <img size='3' color='#00ffff' shadow='2' image='\A3\Air_F_Beta\Parachute_01\Data\UI\Portrait_Parachute_01_CA.paa'/>", "call ghst_fnc_halo", [false,1000,60,false], 5, true, true, "","alive _target"]; */

/* halo addaction ["<t size='1.4' shadow='2' color='#FF0000'>Clear Respawn Tents</t>", "call ghst_fnc_clear_respawn_tents", [], 1, false, false, "","alive _target"]; */
/* halo setObjectTexture [0, "\A3\Characters_F\data\ui\icon_b_parachute_ca.paa"]; */

/* halo2 addAction ["<t size='1.5' shadow='2' color='#00ffff'>HALO</t> <img size='3' color='#00ffff' shadow='2' image='\A3\Air_F_Beta\Parachute_01\Data\UI\Portrait_Parachute_01_CA.paa'/>", "call ghst_fnc_halo", [false,1000,60,false], 5, true, true, "","alive _target"]; */
/* halo2 setObjectTexture [0, "\A3\Characters_F\data\ui\icon_b_parachute_ca.paa"]; */

/* port_teleport addAction ["<t size='1.5' shadow='2' color='#8904B1'>Move to Port</t> <img size='3' color='#8904B1' shadow='2' image='\A3\boat_f_beta\SDV_01\data\ui\portrait_SDV_ca.paa'/>", {player setposasl [getmarkerpos "spawn_board_3" select 0,getmarkerpos "spawn_board_3" select 1,1.5];}, [], 5, true, true, "","alive _target"]; */
/* port_teleport setObjectTexture [0, "\A3\boat_f_beta\SDV_01\data\ui\portrait_SDV_ca.paa"]; */

/* boatspawn addAction ["<t size='1.5' shadow='2' color='#8904B1'>Move to Base</t> <img size='3' color='#8904B1' shadow='2' image='\A3\air_f_beta\Heli_Transport_01\Data\UI\Heli_Transport_01_base_CA.paa'/>", {player setposatl [getmarkerpos "Respawn_West" select 0,getmarkerpos "Respawn_West" select 1,0.2];}, [], 5, false, true, "","alive _target"]; */

/* port_teleport addAction ["<t size='1.5' shadow='2' color='#4863A0'>Move to USS Freedom</t>", {player setposasl [getposasl spawn_freedom select 0,getposasl spawn_freedom select 1,getposasl spawn_freedom select 2 + 0.2];}, [], 5, true, true, "","alive _target"]; */

/* spawn_freedom addAction ["<t size='1.5' shadow='2' color='#8904B1'>Move to Base</t> <img size='3' color='#8904B1' shadow='2' image='\A3\air_f_beta\Heli_Transport_01\Data\UI\Heli_Transport_01_base_CA.paa'/>", {player setposatl [getmarkerpos "Respawn_West" select 0,getmarkerpos "Respawn_West" select 1,0.2];}, [], 5, false, true, "","alive _target"]; */

/* gunship_support = comp1 addAction ["<t size='1.5' shadow='2' color='#00cc99'>Call In Gunship</t>", {gunship_support = [(getmarkerpos "ghst_player_support"),ghst_gunship,60,[800, 500],PARAM_Cooldowns,"ghst_gunship",comp1,true] spawn ghst_fnc_gunship;}, [], 5, true, true, "",""]; */
