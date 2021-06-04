-- 
-- 
-- WinterResortSimulator Season 2
-- Module ToggleEnviroObject.lua
-- 
-- 
-- Author:	Paul Masan (Paulchen)
-- Date:	04/06/2021
-- 
--

ToggleEnviroObject					= ToggleEnviroObject or {};
local ToggleEnviroObjectClass		= Class(ToggleEnviroObject);

function ToggleEnviroObject:onCreate(id,minHeight, ...)
    --create new instance
	ToggleEnviroObject:new(id, minHeight, ...);
end;

function ToggleEnviroObject:load(id, minHeight, ...)
    --load with params
    self.id = id;
    self.minHeight = minHeight;
    self.snowObjects = {};
    for i, v in ipairs({...}) do
        table.insert(self.snowObjects, v);
    end
	EnviroObjectManager.addObj(self);
end;

function ToggleEnviroObject:update(dt)
    --update dt = delta time
	local height = SnowSystem.getInfoAtPosition(VectorUtils.getWorldPosition(self.id));
    --0->255
    local state = height > self.minHeight;
    for k, v in pairs(self.snowObjects) do
        setActive(v, state);
    end;
end;

function ToggleEnviroObject:destroy()
    --called when destroyed
	EnviroObjectManager.removeObj(self);
end;

