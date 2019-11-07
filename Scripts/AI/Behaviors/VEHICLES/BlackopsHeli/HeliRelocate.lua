local Behavior = CreateAIBehavior("HeliRelocate", "HeliIdle",
{
	Constructor = function (self, entity)
		self:AnalyzeSituation(entity)
	end,

	Destructor = function(self, entity)
	end,
	
	AnalyzeSituation = function(self, entity, sender, data)

		local targetPos = g_Vectors.temp_v1

		AI.GetAttentionTargetPosition(entity.id, targetPos)
		AI.SetRefPointPosition(entity.id, targetPos)
		AI.SelectPipe(entity.id, 0, "HeliFlyBy")
	end,
	
	GoodLocationReached = function(self, entity, sender, data)
		AI.SetBehaviorVariable(entity.id, "GoodLocation", true)
	end,
	
	AdvantagePointNotFound = function(self, entity, sender, data)
		Log("%s - AdvantagePointNotFound", EntityName(entity))
	end,

	OnDestinationReached = function(self, entity)
		AI.SelectPipe(entity.id, 0, "HeliHovering")
		--self:AnalyzeSituation(entity)
	end,

	OnEnemyMemory = function(self, entity, distance)
		self:AnalyzeSituation(entity)
	end,
	

})