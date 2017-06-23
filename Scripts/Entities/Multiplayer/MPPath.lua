MPPath=
{
	Editor={
		--Model="%EDITOR%/Objects/ForbiddenArea.cgf",
		Icon="forbiddenarea.bmp",
	},
		
	type = "MPPath",

	Properties = 
	{
		fileNodeDataFile = "",
	},
}


----------------------------------------------------------------------------------------------------
function MPPath:IsShapeOnly()
    return 1;
end

----------------------------------------------------------------------------------------------------
 MPPath.FlowEvents =
{
	Inputs =
	{
	},
	Outputs =
	{
	},
}		
