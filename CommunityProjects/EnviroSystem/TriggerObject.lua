

TriggerObject					= TriggerObject or {};
local TriggerObjectClass		= Class(TriggerObject);

function TriggerObject:onCreate(...)
	TriggerObject:new(...);
end;

function TriggerObject:load(collisionId, animId, soundId)
    --create trigger
    self.colli  = collisionId;
    self.anim   = animId;
    self.sound  = soundId;
    Trigger.addTrigger(collisionId,
    function(triggerId)
        --on enter
        self:onEnter(false);
    end,
    function(triggerId)
        --on leave
        self:onLeave(false);
    end,
    false,
    true
    );
end;

function TriggerObject:onEnter(isReceive)
    if self.anim ~= nil then
        Animation.setSpeed(self.anim, 1); 
    end;
    if self.sound ~= nil then
        AudioSource.play(self.sound, true);
    end;
    if not isReceive then
        EventTriggerObject:send(self, true);
    end;
end;

function TriggerObject:onLeave(isReceive)
    if self.anim ~= nil then
        Animation.setSpeed(self.anim, -1); 
    end;
    if self.sound ~= nil then
        AudioSource.play(self.sound, true);
    end;
    if not isReceive then
        EventTriggerObject:send(self, false);
    end;
end;

function TriggerObject:onEvent(event)
    if event then
        self:onEnter(true);
    else
        self:onLeave(true);
    end
end;

function TriggerObject:destroy()
	
end;