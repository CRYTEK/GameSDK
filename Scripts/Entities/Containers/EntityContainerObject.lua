--	Copyright 2001-2016 Crytek GmbH / Crytek Group. All rights reserved.

EntityContainerObject =
{
	Properties = {},

	Server = {},
	Client = {},

	Editor =
	{
		Icon = "entity_container.bmp",
		IconOnTop = 1,
	},
	
	hOnMoveOpenTriggerID = nil,
	hOnMoveCloseTriggerID = nil,
	hOnStopTriggerID = nil,
	hOnClosedTriggerID = nil,
	tObstructionType = {},
	bIsActive = 0,
}

function EntityContainerObject:OnPropertyChange()
	Game.SendEventToGameObject( self.id, "OnPropertyChange" );
end

function EntityContainerObject:OnTransformFromEditorDone()
end

function EntityContainerObject:OnSpawn()
	CryAction.CreateGameObjectForEntity(self.id);

	self:SetFlags(ENTITY_FLAG_CLIENT_ONLY, 0);
	self:SetFlags(ENTITY_FLAG_NO_PROXIMITY, 0);
end

function EntityContainerObject:OnInit()
end

function EntityContainerObject:Reset(onSpawn)
end

function EntityContainerObject.Client:OnUpdate(frameTime)
	if (not self.isServer) then
	end
end
