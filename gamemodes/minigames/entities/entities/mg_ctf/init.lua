AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/Roller.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetPlaybackRate(1)
	self:PhysicsDestroy()
	self.PickedUp = false
	
	timer.Simple(1, function()
		if self.TeamID == 2 then
			self:SetColor(Color(0,0,255))
		else
			self:SetColor(Color(255,0,0))
		end
	end)
end

function ENT:Use(ply)
end
 
function ENT:Touch(ply)
	if self.PickedUp then return end
	
	if ply:Team() == self.TeamID then 
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self.PickedUp = true
		Minigames.CaptureTheFlag.Holders[self.TeamID] = ply
		net.Start("CTF_FlagToggle")
			net.WriteBool(true)
			net.WriteString(Minigames.CaptureTheFlag.Holders[self.TeamID]:Nick())
			net.WriteString(self.TeamID)
		net.Broadcast()
		self:SetModelScale(0.5,0)
	else
		if table.HasValue(Minigames.CaptureTheFlag.Holders, ply) then
			self:FlagCaptured(ply)
		end
	end
end

function ENT:FlagCaptured(ply)

	if ply:Team() == 2 then
		Minigames.CaptureTheFlag.BlueCaptures = Minigames.CaptureTheFlag.BlueCaptures + 1
		Minigames.CaptureTheFlag.RedFlag.PickedUp = false
		Minigames.CaptureTheFlag.RedFlag:SetPos(Minigames.CaptureTheFlag.RedFlag.StartingPos)
		Minigames.CaptureTheFlag.RedFlag:SetCollisionGroup(COLLISION_GROUP_NONE)
		Minigames.CaptureTheFlag.Holders[3] = nil
		net.Start("CTF_AddCapture")
			net.WriteString("blue")
		net.Broadcast()
	else
		Minigames.CaptureTheFlag.RedCaptures = Minigames.CaptureTheFlag.RedCaptures + 1
		Minigames.CaptureTheFlag.BlueFlag.PickedUp = false
		Minigames.CaptureTheFlag.BlueFlag:SetPos(Minigames.CaptureTheFlag.BlueFlag.StartingPos)
		Minigames.CaptureTheFlag.BlueFlag:SetCollisionGroup(COLLISION_GROUP_NONE)
		Minigames.CaptureTheFlag.Holders[2] = nil
		net.Start("CTF_AddCapture")
			net.WriteString("red")
		net.Broadcast()
	end
	
	net.Start("CTF_Capt")
		net.WriteString(self.TeamID)
	net.Broadcast()
end

function ENT:DroppedFlag()
	
	self:SetModelScale(1.0,0)
	
	local drop = "Disconnected Player"
	if IsValid(Minigames.CaptureTheFlag.Holders[self.TeamID]) then
		drop = Minigames.CaptureTheFlag.Holders[self.TeamID]:Nick()
	end
	
	net.Start("CTF_FlagToggle")
		net.WriteBool(false)
		net.WriteString(drop)
		net.WriteString(self.TeamID)
	net.Broadcast()
	
	Minigames.CaptureTheFlag.Holders[self.TeamID] = nil

	self.PickedUp = false
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	
	timer.Simple(Minigames.CaptureTheFlag.FlagReset, function()
		self:FlagReset()
	end)
end

function ENT:FlagReset()
	if self.PickedUp then return end
	
	self:SetPos(self.StartingPos)

	net.Start("CTF_Reset")
		net.WriteString(self.TeamID)
	net.Broadcast()
	
end

function ENT:Think()
	if self.PickedUp then
		if IsValid(Minigames.CaptureTheFlag.Holders[self.TeamID]) then
			local offset = Vector(0,0,40)
			local eyeangles = Minigames.CaptureTheFlag.Holders[self.TeamID]:EyeAngles()
			local pos = Minigames.CaptureTheFlag.Holders[self.TeamID]:GetPos()+offset+eyeangles:Up()
			self:SetPos(pos)
			
			self:NextThink(CurTime())
			return true
		else
			self:DroppedFlag()
		end
	end
	
end
