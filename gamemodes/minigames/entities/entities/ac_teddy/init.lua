AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/maxofs2d/companion_doll.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetPlaybackRate(1)
	self:PhysicsDestroy()
end

function ENT:Use(ply)
	if Minigames.RoundState != 1 then return end
	Minigames:RoundEnd(1, ply:Nick())
	self:Remove()
	ply:SendLua([[LocalPlayer():ConCommand("act dance")]])
	ply:StripWeapons()
	
	if Minigames.UsePointshop then
		ply:PS_GivePoints(Minigames.AssaultCourse.WinningPoints or 50)
	end
	
	hook.Call("UsedTeddy", GAMEMODE, ply)
end
 
function ENT:Think()
end
