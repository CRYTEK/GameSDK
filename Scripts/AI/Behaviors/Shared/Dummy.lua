local Behavior = CreateAIBehavior("Dummy",
{
	Constructor = function(behavior, entity)
		AI.SelectPipe(entity.id, 0, "Empty")
	end,
})