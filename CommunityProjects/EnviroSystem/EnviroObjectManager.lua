-- 
-- 
-- WinterResortSimulator Season 2
-- Module EnviroObjectManager.lua
-- 
-- 
-- Author:	Paul Masan (Paulchen)
-- Date:	04/06/2021
-- 
--

EnviroObjectManager = EnviroObjectManager or {};

EnviroObjectManager.Objects = {};
EnviroObjectManager.CurIndex = 1;
EnviroObjectManager.UpdateCount = 15 * QualitySettings.getLODBias();

function EnviroObjectManager.addObj(obj)
	table.insert(EnviroObjectManager.Objects,#EnviroObjectManager.Objects + 1, obj);
end;

function EnviroObjectManager.removeObj(obj)
	for k, v in ipairs(EnviroObjectManager.Objects) do
		if v == obj then
			table.remove(EnviroObjectManager.Objects,k);
			return;
		end;
	end;
end;

function EnviroObjectManager:update(dt)
	local shift = EnviroObjectManager.CurIndex;
	local updateSize = (#EnviroObjectManager.Objects < EnviroObjectManager.UpdateCount and #EnviroObjectManager.Objects or EnviroObjectManager.UpdateCount);
	for i = shift, updateSize, 1 do
		if i > #EnviroObjectManager.Objects then shift = 1; end;
		if EnviroObjectManager.Objects[shift] ~= nil then
			EnviroObjectManager.Objects[shift]:update(dt);
		end;
		shift = shift + 1;
	end;
end;
addUpdateable(EnviroObjectManager);
