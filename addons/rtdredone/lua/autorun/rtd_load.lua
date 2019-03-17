RTD = {}

if (SERVER) then
	include("rtd.lua")
	
	local tags = GetConVar("sv_tags"):GetString()
	
	if (!string.find(tags, "RTD")) then
		RunConsoleCommand("sv_tags", tags .. ",RTD 2.1")
	end	
else
	include("cl_rtd.lua")
end