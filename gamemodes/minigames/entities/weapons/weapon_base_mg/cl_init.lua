
include('shared.lua')

SWEP.PrintName			= "Scripted Weapon"		-- 'Nice' Weapon name (Shown on HUD)	
SWEP.Slot				= 0						-- Slot in the weapon selection menu
SWEP.SlotPos			= 10					-- Position in the slot
SWEP.DrawAmmo			= true					-- Should draw the default HL2 ammo counter
SWEP.DrawCrosshair		= true 					-- Should draw the default crosshair
SWEP.DrawWeaponInfoBox	= true					-- Should draw the weapon info box
SWEP.BounceWeaponIcon   = true					-- Should the weapon icon bounce?
SWEP.SwayScale			= 1.0					-- The scale of the viewmodel sway
SWEP.BobScale			= 1.0					-- The scale of the viewmodel bob
SWEP.IronSightsPos = Vector (2.4537, 1.0923, 0.2696)
SWEP.IronSightsAng = Vector (0.0186, -0.0547, 0)
SWEP.RenderGroup 		= RENDERGROUP_OPAQUE
local IRONSIGHT_TIME = 0.25
-- Override this in your SWEP to set the icon in the weapon selection
SWEP.WepSelectIcon		= surface.GetTextureID( "weapons/swep" )

-- This is the corner of the speech bubble
SWEP.SpeechBubbleLid	= surface.GetTextureID( "gui/speech_lid" )

--[[---------------------------------------------------------
	You can draw to the HUD here - it will only draw when
	the client has the weapon deployed..
-----------------------------------------------------------]]
	
	surface.CreateFont( "cssweapon", {
	font = "csd", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 100,
	} )
	surface.CreateFont( "NexaLight55plugran", {
	font = "NexaLight55", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 90,
	} )
	
function SWEP:DrawHUD()

		local weps = {
	["weapon_ak47"] = "b",
	["weapon_aug"] = "e",
	["weapon_awp"] = "r",
	["weapon_csfrag"] = "O",
	["weapon_deagle"] = "f",
	["weapon_elite"] = "s",
	["weapon_famas"] = "t",
	["weapon_fiveseven"] = "u",
	["weapon_g3sg1"] = "i",
	["weapon_galil"] = "v",
	["weapon_glock"] = "c",
	["weapon_knife"] = "j",
	["weapon_m3"] = "k",
	["weapon_m4a1"] = "w",
	["weapon_m249"] = "z",
	["weapon_mac10"] = "l",
	["weapon_mp5"] = "x",
	["weapon_p90"] = "m",
	["weapon_p228"] = "a",
	["weapon_scout"] = "n",
	["weapon_sg550"] = "o",
	["weapon_sg552"] = "A",
	["weapon_smoke"] = "",
	["weapon_tmp"] = "d",
	["weapon_ump45"] = "P",
	["weapon_usp"] = "y",
	["weapon_xm1014"] = "B",
	}

	-- No crosshair when ironsights is on
	if ( !self.Weapon:GetNetworkedBool( "Ironsights" ) ) then 
		
		self.Primary.Cone = self.Primary.Cone or 0.01
		local x, y

		-- If we're drawing the local player, draw the crosshair where they're aiming,
		-- instead of in the center of the screen.
		if ( self.Owner == LocalPlayer() && self.Owner:ShouldDrawLocalPlayer() ) then

			local tr = util.GetPlayerTrace( self.Owner )
	--		tr.mask = ( CONTENTS_SOLID|CONTENTS_MOVEABLE|CONTENTS_MONSTER|CONTENTS_WINDOW|CONTENTS_DEBRIS|CONTENTS_GRATE|CONTENTS_AUX )
			local trace = util.TraceLine( tr )
			
			local coords = trace.HitPos:ToScreen()
			x, y = coords.x, coords.y

		else
			x, y = ScrW() / 2.0, ScrH() / 2.0
		end
		
		local scale = 10 * self.Primary.Cone
		
		-- Scale the size of the crosshair according to how long ago we fired our weapon
		local LastShootTime = self.Weapon:GetNetworkedFloat( "LastShootTime", 0 )
		scale = scale * (2 - math.Clamp( (CurTime() - LastShootTime) * 5, 0.0, 1.0 ))
		
		surface.SetDrawColor( 0, 255, 0, 255 )
		
		-- Draw an awesome crosshair
		local gap = 40 * scale
		local length = gap + 20 * scale
		surface.DrawLine( x - length, y, x - gap, y )
		surface.DrawLine( x + length, y, x + gap, y )
		surface.DrawLine( x, y - length, x, y - gap )
		surface.DrawLine( x, y + length, x, y + gap )
	end
	
	if not Minigames.ScoreboardOpen or not Minigames.MapvoteOpen then
		surface.SetDrawColor(Color(255,255,255,255)) 
		--surface.SetMaterial(mat)
		--surface.DrawTexturedRect(20, ScrH()-32-64-32-38,32,32)
		local m=300
		if self:Clip1()!=-1 then
			draw.DrawText(self:Clip1(), "NexaLight55plugran", ScrW()-m-30, ScrH()-140, Color(255,255,255, 255),TEXT_ALIGN_LEFT)
			draw.DrawText(self:Ammo1(), "NexaLight55", ScrW()-m+80, ScrH()-80, Color(255,255,255, 255),TEXT_ALIGN_LEFT)
		end
		draw.DrawText(weps[self:GetClass()], "cssweapon", ScrW()-m+70, ScrH()-123, Color(255,255,255, 255),TEXT_ALIGN_LEFT)
	end

end



--[[---------------------------------------------------------
	Checks the objects before any action is taken
	This is to make sure that the entities haven't been removed
-----------------------------------------------------------]]
function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	
	-- Set us up the texture
	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetTexture( self.WepSelectIcon )
	
	-- Lets get a sin wave to make it bounce
	local fsin = 0
	
	if ( self.BounceWeaponIcon == true ) then
		fsin = math.sin( CurTime() * 10 ) * 5
	end
	
	-- Borders
	y = y + 10
	x = x + 10
	wide = wide - 20
	
	-- Draw that mother
	surface.DrawTexturedRect( x + (fsin), y - (fsin),  wide-fsin*2 , ( wide / 2 ) + (fsin) )
	
	-- Draw weapon info box
	self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )
	
end


--[[---------------------------------------------------------
	This draws the weapon info box
-----------------------------------------------------------]]
function SWEP:PrintWeaponInfo( x, y, alpha )

	return false
	
end


--[[---------------------------------------------------------
	Name: SWEP:FreezeMovement()
	Desc: Return true to freeze moving the view
-----------------------------------------------------------]]
function SWEP:FreezeMovement()
	return false
end


--[[---------------------------------------------------------
	Name: SWEP:ViewModelDrawn( ViewModel )
	Desc: Called straight after the viewmodel has been drawn
-----------------------------------------------------------]]
function SWEP:ViewModelDrawn( ViewModel )
end


--[[---------------------------------------------------------
	Name: OnRestore
	Desc: Called immediately after a "load"
-----------------------------------------------------------]]
function SWEP:OnRestore()
end

--[[---------------------------------------------------------
	Name: OnRemove
	Desc: Called just before entity is deleted
-----------------------------------------------------------]]
function SWEP:OnRemove()
end

--[[---------------------------------------------------------
	Name: CustomAmmoDisplay
	Desc: Return a table
-----------------------------------------------------------]]
function SWEP:CustomAmmoDisplay()
end

--[[---------------------------------------------------------
	Name: GetViewModelPosition
	Desc: Allows you to re-position the view model
-----------------------------------------------------------]]
function SWEP:GetViewModelPosition( pos, ang )

	if ( !self.IronSightsPos ) then return pos, ang end

	local bIron = self.Weapon:GetNetworkedBool( "Ironsights" )
	
	if ( bIron != self.bLastIron ) then
	
		self.bLastIron = bIron 
		self.fIronTime = CurTime()
		
		if ( bIron ) then 
			self.SwayScale 	= 0.3
			self.BobScale 	= 0.1
		else 
			self.SwayScale 	= 1.0
			self.BobScale 	= 1.0
		end
	
	end
	
	local fIronTime = self.fIronTime or 0

	if ( !bIron && fIronTime < CurTime() - IRONSIGHT_TIME ) then 
		return pos, ang 
	end
	
	local Mul = 1.0
	
	if ( fIronTime > CurTime() - IRONSIGHT_TIME ) then
	
		Mul = math.Clamp( (CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1 )
		
		if (!bIron) then Mul = 1 - Mul end
	
	end

	local Offset	= self.IronSightsPos
	
	if ( self.IronSightsAng ) then
	
		ang = ang * 1
		ang:RotateAroundAxis( ang:Right(), 		self.IronSightsAng.x * Mul )
		ang:RotateAroundAxis( ang:Up(), 		self.IronSightsAng.y * Mul )
		ang:RotateAroundAxis( ang:Forward(), 	self.IronSightsAng.z * Mul )
	
	
	end
	
	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()
	
	

	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul

	return pos, ang
	
end

--[[---------------------------------------------------------
	Name: TranslateFOV
	Desc: Allows the weapon to translate the player's FOV (clientside)
-----------------------------------------------------------]]
function SWEP:TranslateFOV( current_fov )
	
	return current_fov

end


--[[---------------------------------------------------------
	Name: DrawWorldModel
	Desc: Draws the world model (not the viewmodel)
-----------------------------------------------------------]]
function SWEP:DrawWorldModel()
	
	self.Weapon:DrawModel()

end


--[[---------------------------------------------------------
	Name: DrawWorldModelTranslucent
	Desc: Draws the world model (not the viewmodel)
-----------------------------------------------------------]]
function SWEP:DrawWorldModelTranslucent()
	
	self.Weapon:DrawModel()

end


--[[---------------------------------------------------------
	Name: AdjustMouseSensitivity
	Desc: Allows you to adjust the mouse sensitivity.
-----------------------------------------------------------]]
function SWEP:AdjustMouseSensitivity()

	return nil
	
end

--[[---------------------------------------------------------
	Name: GetTracerOrigin
	Desc: Allows you to override where the tracer comes from (in first person view)
		 returning anything but a vector indicates that you want the default action
-----------------------------------------------------------]]
function SWEP:GetTracerOrigin()

--[[
	local ply = self:GetOwner()
	local pos = ply:EyePos() + ply:EyeAngles():Right() * -5
	return pos
--]]

end

--[[---------------------------------------------------------
	Name: FireAnimationEvent
	Desc: Allows you to override weapon animation events
-----------------------------------------------------------]]
function SWEP:FireAnimationEvent( pos, ang, event, options )

	if ( !self.CSMuzzleFlashes ) then return end

	-- CS Muzzle flashes
	if ( event == 5001 or event == 5011 or event == 5021 or event == 5031 ) then
	
		local data = EffectData()
		data:SetFlags( 0 )
		data:SetEntity( self.Owner:GetViewModel() )
		data:SetAttachment( math.floor( ( event - 4991 ) / 10 ) )
		data:SetScale( 1 )

		if ( self.CSMuzzleX ) then
			util.Effect( "CS_MuzzleFlash_X", data )
		else
			util.Effect( "CS_MuzzleFlash", data )
		end
	
		return true
	end

end
