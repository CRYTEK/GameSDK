local Behavior = CreateAIBehavior("InVehicleAlerted", "InVehicle",	{	Alertness = 2,	Exclusive = 1,

	Destructor = function( self, entity )	
		AI.SelectPipe(entity.id, 0,"do_nothing");
		AI.InsertSubpipe(entity.id, AIGOALPIPE_NOTDUPLICATE,"clear_all");
	end,
})