include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

surface.CreateFont( "Coolvetica40", {
	font = "Coolvetica", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 50,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

function ENT:Draw()

	if LocalPlayer() == Minigames.VIP_CS then
		local offset = Vector( 0, 0, 40 )
		local ang = LocalPlayer():EyeAngles()
		local pos = self:GetPos() + offset

		ang:RotateAroundAxis( ang:Forward(), 90 )
		ang:RotateAroundAxis( ang:Right(), 90 )
		
		cam.Start3D2D(pos+Vector(0,0,-10), Angle( 0, ang.y, 90 ), 0.25 )
			draw.DrawText("Appuie sur E !", "Coolvetica40", 2, 2, Color(34,167,240), TEXT_ALIGN_CENTER )
		cam.End3D2D()
	end
	
	self:DrawModel()
end

