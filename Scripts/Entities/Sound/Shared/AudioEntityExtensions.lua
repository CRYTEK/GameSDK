-- Copyright 2001-2016 Crytek GmbH / Crytek Group. All rights reserved.

Script.ReloadScript("Scripts/Entities/Sound/Shared/AudioUtils.lua");


--------------------------------------------------------------------------------------------------------
-- An entity extension providing functionality to execute audio triggers on animation "audio_trigger" event.
--------------------------------------------------------------------------------------------------------
AnimAudioEventHandling =
{
	perBoneAudioProxyUpdateInterval = 0.1,

	Client = {},
	Server = {},
}

-- Computes the position of a bone in the reference frame of the entity.
function AnimAudioEventHandling:GetBonePosInEntitySpace(boneName)
	local position = {}

	SubVectors(position, self:GetBonePos(boneName), self:GetPos());

	-- This transforms the position vector from world space to entity space.
	-- Lua bindings and math facilities are fairly limited, so we're using three GetDirectionVector() calls to extract
	-- colums of the entity's world rotation matrix, then implicitly transposing it by multiplying them as if they were rows.
	return {
	      x = dotproduct3d(self:GetDirectionVector(0), position),
	      y = dotproduct3d(self:GetDirectionVector(1), position),
	      z = dotproduct3d(self:GetDirectionVector(2), position)
	}
end

-- Retrives auxiliary audio proxy ID for a bone with the given name. Returns nil on failure.
function AnimAudioEventHandling:GetAuxAudioProxyIDForBone(boneName)
	local state = self.AnimAudioEventHandlingState
	
	if (not boneName or boneName == "") then
		return nil
	end
	
	if (not state.proxies[boneName]) then
		state.proxies[boneName] = self:CreateAuxAudioProxy()
		
		local offset = self:GetBonePosInEntitySpace(boneName)
		self:SetAudioProxyOffset(offset, state.proxies[boneName])
		
		--System.Log("AnimAudioEventHandling: created audio proxy for '" .. self:GetName() .. "' -> " .. boneName)
	end
	
	return state.proxies[boneName]	
end

-- OnSpawn hook
function AnimAudioEventHandling:OnSpawn()
	self.AnimAudioEventHandlingState =
	{
		updateCounter = 0.0,
		proxies = {}
	}
	
	--System.Log("AnimationAudioEventHandling: initialized for '" .. self:GetName() .. "'")
end

-- Client.OnAnimationEvent hook
function AnimAudioEventHandling.Client:OnAnimationEvent(eventType, eventData)
	if (eventType == "audio_trigger") then
		local proxy = self:GetAuxAudioProxyIDForBone(eventData.jointName) or self:GetDefaultAuxAudioProxyID()
		local trigger = AudioUtils.LookupTriggerID(eventData.customParam)
		if (proxy and trigger) then
	self:ExecuteAudioTrigger(trigger, proxy)
	--System.Log("AnimAudioEventHandling: executed audio trigger for '" .. self:GetName() .. "' -> " .. eventData.customParam .. " / " .. tostring(proxy))
		end
	end
end

-- Client.OnUpdate hook
function AnimAudioEventHandling.Client:OnUpdate(dt)
	local state = self.AnimAudioEventHandlingState

	if (not self:IsAnimationRunning(0,0)) then
		return
	end
	
	state.updateCounter = state.updateCounter - dt

	if (state.updateCounter <= 0.0) then
		state.updateCounter = self.perBoneAudioProxyUpdateInterval

		for boneName, proxy in pairs(state.proxies) do
			local offset = self:GetBonePosInEntitySpace(boneName);
			self:SetAudioProxyOffset(offset, proxy);
			
			--System.Log("AnimAudioEventHandling: updated audio proxy offset for '" .. self:GetName() .. "' -> " .. boneName .. " (ProxyID: " .. tostring(proxy) .. ")" .. " [" .. offset.x .. ", " .. offset.y .. ", " .. offset.z .. "]")
		end
	end
end

--------------------------------------------------------------------------------------------------------
