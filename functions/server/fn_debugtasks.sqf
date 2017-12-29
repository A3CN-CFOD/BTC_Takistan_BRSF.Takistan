_p = _this select 0;
_a = admin owner _p;

if (_a > 0) then {
	{[_X,'succeeded'] call BIS_fnc_taskSetState;} foreach Ghst_Current_tasks;;
} else {
	"Only admin can use this command" remoteExec ["hint",_p];
};