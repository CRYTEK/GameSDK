SoundSupressor = {
	Client = {},
	Server = {},
	Properties = {
		radius = 10
	},
		Editor={
		Icon = "Item.bmp",
		IconOnTop=1,
	},
}


function SoundSupressor:OnPropertyChange()
	self:OnReset();
end;

function SoundSupressor:OnInit()
	self:OnReset();
end

function SoundSupressor:OnReset()

	AI.RegisterWithAI(self.id, AIOBJECT_SNDSUPRESSOR, self.Properties);

end;



----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------
------------------------------------Events----------------------------------------
----------------------------------------------------------------------------------
function SoundSupressor:Event_TurnOn()
	AI.TriggerEvent(self.id, AIEVENT_DISABLE);
end;

function SoundSupressor:Event_TurnOff()
	AI.TriggerEvent(self.id, AIEVENT_ENABLE);
end;



----------------------------------------------------------------------------------
-------------------------------Flow-Graph Ports-----------------------------------
----------------------------------------------------------------------------------

SoundSupressor.FlowEvents =
{
	Inputs =
	{
		TurnOn = { SoundSupressor.Event_TurnOn, "bool" },
		TurnOff = { SoundSupressor.Event_TurnOff, "bool" },
	},
	Outputs =
	{
	},
}
