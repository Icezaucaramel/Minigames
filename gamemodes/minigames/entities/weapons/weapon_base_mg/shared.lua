//This uses a somewhat modified version of weapon_base, found in garrysmod/gamemodes/base


IncludeCS( "ai_translations.lua" )
IncludeCS( "sh_anim.lua" )

-- Variables that are used on both client and server

SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_pistol.mdl"
SWEP.WorldModel		= "models/weapons/w_357.mdl"

SWEP.Spawnable			= false
SWEP.AdminOnly			= false

SWEP.Primary.ClipSize		= 8					-- Size of a clip
SWEP.Primary.DefaultClip	= 32				-- Default number of bullets in a clip
SWEP.Primary.Automatic		= false				-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "Pistol"

SWEP.Secondary.ClipSize		= 8					-- Size of a clip
SWEP.Secondary.DefaultClip	= 32				-- Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				-- Automatic/Semi Auto
SWEP.Secondary.Ammo			= "Pistol"
SWEP.UseHands = true


--[[---------------------------------------------------------
   Name: SWEP:Initialize( )
   Desc: Called when the weapon is first loaded
-----------------------------------------------------------]]
function SWEP:Initialize()

	if not self.FireModes then self.FireModes = {} end
	
	self:SetHoldType(self.HoldType)
	self.NextFireTime = 0

end


--[[---------------------------------------------------------
   Name: SWEP:Precache( )
   Desc: Use this function to precache stuff
-----------------------------------------------------------]]
function SWEP:Precache()
end


--[[---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
-----------------------------------------------------------]]
function SWEP:PrimaryAttack()

	self.Primary.Recoil = self.Primary.Recoil or 5
	-- Make sure we can shoot first
	if ( !self:CanPrimaryAttack() ) then return end

	-- Play shoot sound
	self:EmitSound(self.Primary.Sound)
	
	if self.Shotgun then
		self:FireBulletShotgun( self.Primary.Damage, 0, self.Shots)
    else
		self:ShootBullet(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone )
	end
	
	-- Remove 1 bullet from our clip
	self:TakePrimaryAmmo(1)

	-- Punch the player's view
	self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )

	self.NextFireTime = CurTime() + self.Primary.Delay

end


--[[---------------------------------------------------------
   Name: SWEP:SecondaryAttack( )
   Desc: +attack2 has been pressed
-----------------------------------------------------------]]
 
function SWEP:SecondaryAttack()
		return false
end

--[[---------------------------------------------------------
   Name: SWEP:Reload( )
   Desc: Reload is being pressed
-----------------------------------------------------------]]
function SWEP:Reload()
	self:SetIronsights(false)
	self.Weapon:DefaultReload( ACT_VM_RELOAD );
end


--[[---------------------------------------------------------
   Name: SWEP:Think( )
   Desc: Called every frame
-----------------------------------------------------------]]
function SWEP:Think()
 
self:IronSight()
 
end

--[[---------------------------------------------------------
   Name: SWEP:Holster( weapon_to_swap_to )
   Desc: Weapon wants to holster
   RetV: Return true to allow the weapon to holster
-----------------------------------------------------------]]
function SWEP:Holster( wep )
	return true
end

--[[---------------------------------------------------------
   Name: SWEP:Deploy( )
   Desc: Whip it out
-----------------------------------------------------------]]
function SWEP:Deploy()
	self:SetIronsights(false, self.Owner)                                   
	self:SetHoldType(self.HoldType)
	return true
end


--[[---------------------------------------------------------
   Name: SWEP:ShootBullet( )
   Desc: A convenience function to shoot bullets
-----------------------------------------------------------]]
function SWEP:ShootEffects()

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		-- View model animation
	self.Owner:MuzzleFlash()								-- Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				-- 3rd Person Animation

end


--[[---------------------------------------------------------
   Name: SWEP:ShootBullet( )
   Desc: A convenience function to shoot bullets
-----------------------------------------------------------]]
function SWEP:ShootBullet( dmg, recoil, numbul, cone )

		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

    self.Owner:MuzzleFlash()
    self.Owner:SetAnimation( PLAYER_ATTACK1 )

	
	numbul 	= numbul 	or 1
	cone 	= cone 		or 0.01
	recoil  = recoil or 0.1

	local bullet = {}
	bullet.Num 		= numbul
	bullet.Src 		= self.Owner:GetShootPos()			-- Source
	bullet.Dir 		= self.Owner:GetAimVector()			-- Dir of bullet
	bullet.Spread 	= Vector( cone, cone, 0 )			-- Aim Cone
	bullet.Tracer	= 4									-- Show a tracer on every x bullets 
	bullet.Force	= 5									-- Amount of force to give to phys objects
	bullet.Damage	= dmg
	
	self.Owner:FireBullets( bullet )
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		-- View model animation
	self.Owner:MuzzleFlash()								-- Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				-- 3rd Person Animation
	
	if ( self.Owner:IsNPC() ) then return end
	
	-- CUSTOM RECOIL !
	if ( (game.SinglePlayer() && SERVER) || ( !game.SinglePlayer() && CLIENT && IsFirstTimePredicted() ) ) then
	
		local eyeang = self.Owner:EyeAngles()
		eyeang.pitch = eyeang.pitch - recoil
		self.Owner:SetEyeAngles( eyeang )
	
	end
	
end

function SWEP:FireBulletShotgun(damage, cone, bullets)
	
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

    self.Owner:MuzzleFlash()
    self.Owner:SetAnimation( PLAYER_ATTACK1 )



	sp = GetShootPos(self.Owner)
	math.randomseed(CommandNumber(GetCurrentCommand(self.Owner)))

	cone = cone or 0.1
	--cone = cone + CalculateConeImprecision(self.Owner)
	
	Dir = (self.Owner:EyeAngles() + self.Owner:GetPunchAngle() + Angle(math.Rand(-cone, cone), math.Rand(-cone, cone), 0) * 5):Forward()

	for i = 1, bullets do
		Dir2 = Dir
		
		if self.ClumpSpread and self.ClumpSpread > 0 then
			Dir2 = Dir2 + Vector(math.Rand(-1, 1), math.Rand(-1, 1), math.Rand(-1, 1)) * self.ClumpSpread
		end
		
		bul.Num = 1
		bul.Src = self.Owner:GetShootPos()
		bul.Dir = (self.ClumpSpread and self.ClumpSpread > 0 and Dir2) or self.Owner:GetAimVector()
		bul.Spread 	= Vector(cone, cone, 0)
		bul.Tracer	= 4
		bul.Force	= 1
		bul.Damage = damage
		
		if CLIENT then
			bul.Callback = function(ply, tr, dmginfo)
				if LCT and tr.Entity and IsValid(tr.Entity) and (tr.Entity:IsPlayer() or tr.Entity:IsNPC()) then LCT(tr.Entity,tr,dmginfo,self) return end
			end
		elseif SERVER then
			bul.Callback = DoBulletEffects
		end
	
		if SERVER then 
			if LagComp then 
				LagComp.FireBulletsLua(self.Owner, bul) 
			else 
				self.Owner:FireBullets( bul ) 
			end
		else 
			self.Owner:FireBullets( bul ) 
		end
		
	end
		
	tr.mask = trace_normal
end

--[[---------------------------------------------------------
   Name: SWEP:TakePrimaryAmmo(   )
   Desc: A convenience function to remove ammo
-----------------------------------------------------------]]
function SWEP:TakePrimaryAmmo( num )
	
	-- Doesn't use clips
	if ( self.Weapon:Clip1() <= 0 ) then 
	
		if ( self:Ammo1() <= 0 ) then return end
		
		self.Owner:RemoveAmmo( num, self.Weapon:GetPrimaryAmmoType() )
	
	return end
	
	self.Weapon:SetClip1( self.Weapon:Clip1() - num )	
	
end


--[[---------------------------------------------------------
   Name: SWEP:TakeSecondaryAmmo(   )
   Desc: A convenience function to remove ammo
-----------------------------------------------------------]]
function SWEP:TakeSecondaryAmmo( num )
	
	-- Doesn't use clips
	if ( self.Weapon:Clip2() <= 0 ) then 
	
		if ( self:Ammo2() <= 0 ) then return end
		
		self.Owner:RemoveAmmo( num, self.Weapon:GetSecondaryAmmoType() )
	
	return end
	
	self.Weapon:SetClip2( self.Weapon:Clip2() - num )	
	
end


--[[---------------------------------------------------------
   Name: SWEP:CanPrimaryAttack( )
   Desc: Helper function for checking for no ammo
-----------------------------------------------------------]]
function SWEP:CanPrimaryAttack()

	if ( self.Weapon:Clip1() <= 0 ) then
	
		self:EmitSound( "Weapon_Pistol.Empty" )
		self:SetNextPrimaryFire( CurTime() + 0.2 )
		self:Reload()
		return false
		
	end

	if CurTime() > self.NextFireTime then
		return true
	end

	return false

end


--[[---------------------------------------------------------
   Name: SWEP:CanSecondaryAttack( )
   Desc: Helper function for checking for no ammo
-----------------------------------------------------------]]
--[[function SWEP:CanSecondaryAttack()

	if ( self.Weapon:Clip2() <= 0 ) then
	
		self.Weapon:EmitSound( "Weapon_Pistol.Empty" )
		self.Weapon:SetNextSecondaryFire( CurTime() + 0.2 )
		return false
		
	end

	return true

end]]


--[[---------------------------------------------------------
   Name: OnRemove
   Desc: Called just before entity is deleted
-----------------------------------------------------------]]
function SWEP:OnRemove()
end


--[[---------------------------------------------------------
   Name: OwnerChanged
   Desc: When weapon is dropped or picked up by a new player
-----------------------------------------------------------]]
function SWEP:OwnerChanged()
end


--[[---------------------------------------------------------
   Name: Ammo1
   Desc: Returns how much of ammo1 the player has
-----------------------------------------------------------]]
function SWEP:Ammo1()
	return self.Owner:GetAmmoCount( self.Weapon:GetPrimaryAmmoType() )
end


--[[---------------------------------------------------------
   Name: Ammo2
   Desc: Returns how much of ammo2 the player has
-----------------------------------------------------------]]
function SWEP:Ammo2()
	return self.Owner:GetAmmoCount( self.Weapon:GetSecondaryAmmoType() )
end

--[[---------------------------------------------------------
   Name: SetDeploySpeed
   Desc: Sets the weapon deploy speed. 
		 This value needs to match on client and server.
-----------------------------------------------------------]]
function SWEP:SetDeploySpeed( speed )
	self.m_WeaponDeploySpeed = tonumber( speed )
end

--[[---------------------------------------------------------
   Name: DoImpactEffect
   Desc: Callback so the weapon can override the impact effects it makes
		 return true to not do the default thing - which is to call UTIL_ImpactTrace in c++
-----------------------------------------------------------]]
function SWEP:DoImpactEffect( tr, nDamageType )
		
	return false;
	
end

--[[---------------------------------------------------------
	SetIronsights
---------------------------------------------------------]]--
function SWEP:SetIronsights( b )

	self.Weapon:SetNetworkedBool( "Ironsights", b )

end

function SWEP:IronSight()

		self.Secondary.IronFOV = self.Secondary.IronFOV or 0
 
		if not IsValid(self) then return end
		if not IsValid(self.Owner) then return end
 
		if !self.Owner:IsNPC() then
		if self.ResetSights and CurTime() >= self.ResetSights then
		self.ResetSights = nil
	   
		if self.Silenced then
				self:SendWeaponAnim(ACT_VM_IDLE_SILENCED)
		else
				self:SendWeaponAnim(ACT_VM_IDLE)
		end
		end end
	   
		if self.CanBeSilenced and self.NextSilence < CurTime() then
				if self.Owner:KeyDown(IN_USE) and self.Owner:KeyPressed(IN_ATTACK2) then
						self:Silencer()
				end
		end
	   
		if self.SelectiveFire and self.NextFireSelect < CurTime() and not (self.Weapon:GetNWBool("Reloading")) then
				if self.Owner:KeyDown(IN_USE) and self.Owner:KeyPressed(IN_RELOAD) then
						self:SelectFireMode()
				end
		end    
	   
-- //copy this...
		if self.Owner:KeyPressed(IN_SPEED) and not (self.Weapon:GetNWBool("Reloading")) then            -- If you are running
		if self.Weapon:GetNextPrimaryFire() <= (CurTime()+0.3) then
				self.Weapon:SetNextPrimaryFire(CurTime()+0.3)                           -- Make it so you can't shoot for another quarter second
		end
		self.IronSightsPos = self.RunSightsPos                                  -- Hold it down
		self.IronSightsAng = self.RunSightsAng                                  -- Hold it down
		self:SetIronsights(true, self.Owner)                                    -- Set the ironsight true
		self.Owner:SetFOV( 0, 0.3 )
		self.DrawCrosshair = false
		end                                                            
 
		if self.Owner:KeyReleased (IN_SPEED) then       -- If you release run then
		self:SetIronsights(false, self.Owner)                                   -- Set the ironsight true
		self.Owner:SetFOV( 0, 0.3 )
		self.DrawCrosshair = self.OrigCrossHair
		end                                                             -- Shoulder the gun
 
-- //down to this
		if !self.Owner:KeyDown(IN_USE) and !self.Owner:KeyDown(IN_SPEED) then
		-- //If the key E (Use Key) is not pressed, then
 
				if self.Owner:KeyPressed(IN_ATTACK2) and not (self.Weapon:GetNWBool("Reloading")) then
						self.Owner:SetFOV( self.Secondary.IronFOV, 0.3 )
						self.IronSightsPos = self.SightsPos                                     -- Bring it up
						self.IronSightsAng = self.SightsAng                                     -- Bring it up
						self:SetIronsights(true, self.Owner)
						self.DrawCrosshair = false
						-- //Set the ironsight true
 
						if CLIENT then return end
				end
		end
 
		if self.Owner:KeyReleased(IN_ATTACK2) and !self.Owner:KeyDown(IN_USE) and !self.Owner:KeyDown(IN_SPEED) then
		-- //If the right click is released, then
				self.Owner:SetFOV( 0, 0.3 )
				self.DrawCrosshair = self.OrigCrossHair
				self:SetIronsights(false, self.Owner)
				-- //Set the ironsight false
 
				if CLIENT then return end
		end
 
				if self.Owner:KeyDown(IN_ATTACK2) and !self.Owner:KeyDown(IN_USE) and !self.Owner:KeyDown(IN_SPEED) then
				self.SwayScale  = 0.05
				self.BobScale   = 0.05
				else
				self.SwayScale  = 1.0
				self.BobScale   = 1.0
				end
end
function SWEP:GetIronsights()
        return self.Weapon:GetNWBool("Ironsights")
end