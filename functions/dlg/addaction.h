this lock true; this allowDamage false; ghst_spawnveh = this addAction ["<t color='#00ff00'>Spawn Vehicle</t>", "dlg\ghst_spawnveh.sqf", ["vehspawnarea_1",46], 3, true, true, "","alive _target"]; ghst_spawnair = this addAction ["<t color='#ffff00'>Spawn Aircraft</t>", "dlg\ghst_spawnair.sqf", ["spawn",60], 3, true, true, "","alive _target"];