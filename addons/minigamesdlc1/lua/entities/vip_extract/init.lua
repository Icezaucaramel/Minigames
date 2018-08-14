AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/Roller.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetPlaybackRate(1)
	self:PhysicsDestroy()
end

function ENT:Use(ply)
	if ply == Minigames.VIP.VIP then
		Minigames:RoundEnd(2)
		Minigames.VIP.VIP = nil
		ply:KillSilent()
	end
end

function ENT:Think()

end