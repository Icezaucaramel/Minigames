include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Draw()
	/*
	local pos = self.Entity:GetPos()

	local pSin = math.sin(CurTime() * 3)
	render.SetMaterial(Material("materials/niandralades/minigames/bullets.png"))
	render.DrawSprite(self.Entity:GetPos(),32,32, self:GetColor() )	
	*/
	
	self:DrawModel()
end

