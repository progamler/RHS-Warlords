if (isMultiplayer) then {
	enableSaving [FALSE, FALSE];
};

if (isServer) then {
	10e10 setOvercast 0.5;
};

[] spawn {
	waitUntil {!isNil "BIS_WL_arsenalSetupDone"};
	execVM "JPW_WLArsenalFilter.sqf";
};

_missionParams = "TRUE" configClasses (missionConfigFile >> "Params");

_i = _missionParams find (missionConfigFile >> "Params" >> "BIS_WLJetsDLCAssetsEnabled");
if (_i >= 0) then {
	_value = paramsArray # _i;
	if (_value == 0) then {
		[] spawn {
			_jetsDLCAssets = [
				"b_plane_fighter_01_f",
				"b_sam_system_03_f",
				"b_radar_system_01_f",
				"o_plane_fighter_02_f",
				"o_sam_system_04_f",
				"o_radar_system_02_f"
			];
			waitUntil {!isNil {player getVariable "BIS_WL_purchasable"}};
			_purchasableArr = +(player getVariable "BIS_WL_purchasable");
			_aircraftAssets = _purchasableArr # 4;
			{
				if ((toLower (_x # 0)) in _jetsDLCAssets) then {_aircraftAssets set [_forEachIndex, -1]};
			} forEach _aircraftAssets;
			_aircraftAssets = _aircraftAssets - [-1];
			_defencesAssets = _purchasableArr # 3;
			{
				if ((toLower (_x # 0)) in _jetsDLCAssets) then {_defencesAssets set [_forEachIndex, -1]};
			} forEach _defencesAssets;
			_defencesAssets = _defencesAssets - [-1];
			_purchasableArr set [4, _aircraftAssets];
			_purchasableArr set [3, _defencesAssets];
			player setVariable ["BIS_WL_purchasable", _purchasableArr];
		};
	};
};