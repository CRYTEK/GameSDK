
CloudBlocker =
{
	Properties =
	{
		bActive = 1, --[0,1,1,"If true, cloud blocker will be enabled."]
		fDecayInfluence = 1.0, --[0,1,0.01,"Specifies the influence of fog density decay."]
		DecayEnd = 0.0, --[0,100000,1.0,"Specifies the end distance of fog density decay in world units (m)."]
		DecayStart = 0.0, --[0,100000,1.0,"Specifies the start distance of cloud density decay in world units (m)."]
		bScreenSpace = 0, --[0,1,1,"If true, cloud blocker is projected on screen space."]
	},

	Editor = 
	{
		Model = "%EDITOR%/Objects/Particles.cgf",
		Icon = "Clouds.bmp",
		ShowBounds = 1,
	},
}

-------------------------------------------------------
function CloudBlocker:EnableBlock()
	self.active = true;
	self:LoadCloudBlocker( 0, self.Properties );
end

-------------------------------------------------------
function CloudBlocker:DisableBlock()
	self:FreeSlot( 0 );
	self.active = false;
end

-------------------------------------------------------
function CloudBlocker:OnSpawn()
	self:SetFlags(ENTITY_FLAG_CLIENT_ONLY, 0);
	self:SetFlags(ENTITY_FLAG_NO_PROXIMITY, 0);
end

-------------------------------------------------------
function CloudBlocker:OnInit()
	self.active = false;
	if( self.Properties.bActive == 1 ) then
		self:EnableBlock();
	end
end

-------------------------------------------------------
function CloudBlocker:OnShutDown()
	self:DisableBlock();
end

-------------------------------------------------------
function CloudBlocker:OnPropertyChange()
	if( self.Properties.bActive == 1 ) then
		self:EnableBlock();
	else
		self:DisableBlock();
	end
end

-------------------------------------------------------
function CloudBlocker:OnReset()
	self.active = false;
	if( self.Properties.bActive == 1 ) then
		self:EnableBlock();
	end
end

-------------------------------------------------------
-- Serialization
-------------------------------------------------------
function CloudBlocker:OnLoad(table)
	if(self.active and not table.active) then
		self:DisableBlock();
	elseif(not self.active and table.active) then
		self:EnableBlock();
	end
	self.active = table.active;
end

-------------------------------------------------------
function CloudBlocker:OnSave(table)
	table.active = self.active;
end

-------------------------------------------------------
-- Set Enabled Event
-------------------------------------------------------
function CloudBlocker:Event_Enabled(i, enable)
	if (enable) then
		self:EnableBlock();
		self:ActivateOutput( "Enabled", true );
	else
		self:DisableBlock();
		self:ActivateOutput( "Enabled", false );
	end
end

-------------------------------------------------------
-- Set DecayStart Event
-------------------------------------------------------
function CloudBlocker:Event_SetDecayStart(i, val)
	self.Properties.DecayStart = val;
end

-------------------------------------------------------
-- Set DecayEnd Event
-------------------------------------------------------
function CloudBlocker:Event_SetDecayEnd(i, val)
	self.Properties.DecayEnd = val;
end

-------------------------------------------------------
-- Set DecayInfluence Event
-------------------------------------------------------
function CloudBlocker:Event_SetDecayInfluence(i, val)
	self.Properties.fDecayInfluence = val;
end

-------------------------------------------------------
CloudBlocker.FlowEvents =
{
	Inputs =
	{
		EV_Enabled  = { CloudBlocker.Event_Enabled, "bool" },
		EV_DecayStart  = { CloudBlocker.Event_SetDecayStart, "float" },
		EV_DecayEnd  = { CloudBlocker.Event_SetDecayEnd, "float" },
		EV_DecayInfluence  = { CloudBlocker.Event_SetDecayInfluence, "float" },
	},
	Outputs =
	{
		Enabled = "bool"
	},
}
