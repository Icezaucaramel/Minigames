function LoadMGSBData()
	if SERVER then
		include("minigames/mg_sb.lua")
		AddCSLuaFile("minigames/mg_sb.lua")
			
	else
		include("minigames/mg_sb.lua")
	end	
end

LoadMGSBData()