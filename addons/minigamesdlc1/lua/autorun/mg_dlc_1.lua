function LoadMGDLCData()
	if SERVER then
		include("minigames/mg_ff1.lua")
		AddCSLuaFile("minigames/mg_ff1.lua")
			
	else
		include("minigames/mg_ff1.lua")
	end	
end

LoadMGDLCData()