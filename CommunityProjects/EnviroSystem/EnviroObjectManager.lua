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
	addDestroyListener(obj.id, obj);
end;

function EnviroObjectManager.removeObj(obj)
	for k, v in pairs(EnviroObjectManager.Objects) do
		if v == obj then
			table.remove(EnviroObjectManager.Objects,k);
		end;
	end;
end;

function EnviroObjectManager:update(dt)
	local updateSize = (#EnviroObjectManager.Objects < EnviroObjectManager.UpdateCount and #EnviroObjectManager.Objects or EnviroObjectManager.UpdateCount);
	for i = 1, updateSize, 1 do
		if EnviroObjectManager.CurIndex > #EnviroObjectManager.Objects then EnviroObjectManager.CurIndex = 1; end;
		if getIsTransformValid(EnviroObjectManager.Objects[EnviroObjectManager.CurIndex].id) then
			EnviroObjectManager.Objects[EnviroObjectManager.CurIndex]:update(dt);
		end;
		EnviroObjectManager.CurIndex = EnviroObjectManager.CurIndex + 1;
	end;
end;
addUpdateable(EnviroObjectManager);
