AddCSLuaFile()

SWEP.HoldType               = "knife"

if CLIENT then
   SWEP.PrintName           = "Couteau"
   SWEP.Slot                = 0
   SWEP.SlotPos		        = 1

   SWEP.ViewModelFlip       = false
   SWEP.ViewModelFOV        = 54
   SWEP.DrawCrosshair       = false

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "knife_desc"
   };

   SWEP.Icon                = "vgui/ttt/icon_knife"
   SWEP.IconLetter          = "j"
end

SWEP.Base                   = "weapon_base_mg"

SWEP.UseHands               = true
SWEP.ViewModel              = "models/weapons/cstrike/c_knife_t.mdl"
SWEP.WorldModel             = "models/weapons/w_knife_t.mdl"

SWEP.Primary.Damage         = 25
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Delay          = 1.1
SWEP.Primary.Ammo           = "none"

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo         = "none"
SWEP.Secondary.Delay        = 1.4
SWEP.Secondary.IronFOV			= 0
SWEP.IsSilent               = true

-- Pull out faster than standard guns
SWEP.DeploySpeed            = 2


SWEP.Primary.ClipSize			= -1
SWEP.Primary.Damage				= -1
SWEP.Primary.DefaultClip		= -1
SWEP.Primary.Automatic			= true
SWEP.Primary.Ammo				= "none"


SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Damage			= -1
SWEP.Secondary.Automatic		= true
SWEP.Secondary.Ammo				= "none"

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function SWEP:Think()
if self.Idle and CurTime()>=self.Idle then
self.Idle = nil
self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
end
end

/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function SWEP:Initialize() 
	self:SetWeaponHoldType( "knife" ) 	 
end 

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	self.Weapon:EmitSound( "Weapon_Knife.Deploy" )
	return true
end

/*---------------------------------------------------------
PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 80 )
	tr.filter = self.Owner
	tr.mask = MASK_SHOT
	local trace = util.TraceLine( tr )

	self.Weapon:SetNextPrimaryFire(CurTime() + 0.4)
	self.Weapon:SetNextSecondaryFire(CurTime() + 1)
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	if ( trace.Hit ) then

	local DamageMath = math.random(0,5)

	if DamageMath == 3 then

		dmg = 20
	else

		dmg = 15
	end

		if trace.Entity:IsPlayer() or trace.Entity:IsNPC() then
			self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
			self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
			self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = dmg
			self.Owner:FireBullets(bullet) 
			self.Weapon:EmitSound( "Weapon_Knife.Hit" )
		else
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = dmg
			self.Owner:FireBullets(bullet)
			self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
			self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
			self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
			self.Weapon:EmitSound( "Weapon_Knife.HitWall" )

		end
	else
		self.Weapon:EmitSound("Weapon_Knife.Slash")
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
		self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	end
end

function SWEP:EntityFaceBack(ent)
	local angle = self.Owner:GetAngles().y -ent:GetAngles().y
	if angle < -180 then angle = 360 +angle end
	if angle <= 90 and angle >= -90 then return true end
	return false
end

/*---------------------------------------------------------
Reload
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 60 )
	tr.filter = self.Owner
	tr.mask = MASK_SHOT
	local trace = util.TraceLine( tr )

	self.Weapon:SetNextPrimaryFire(CurTime() + 0.4)
	self.Weapon:SetNextSecondaryFire(CurTime() + 1)
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	if ( trace.Hit ) then

	local damage

	if self:EntityFaceBack(trace.Entity) then

		damage = 195
	else
		damage = 65

	end

		if trace.Entity:IsPlayer() or trace.Entity:IsNPC() then
			self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
			self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = damage
			self.Owner:FireBullets(bullet) 
			self.Weapon:EmitSound( "Weapon_Knife.Stab" )
		else
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = 65
			self.Owner:FireBullets(bullet)

			self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
			self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
			self.Weapon:EmitSound("Weapon_Knife.HitWall")

		end
	else
		self.Weapon:EmitSound("Weapon_Knife.Slash")
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
		self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	end
end


/*---------------------------------------------------------
DrawWeaponSelection
---------------------------------------------------------*/
function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)


	self:PrintWeaponInfo(x + wide + 20, y + tall * 0.95, alpha)
	-- Print weapon information
end

function SWEP:DoImpactEffect( tr, nDamageType )
	util.Decal("ManhackCut", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)	
	return true;
	
end