AddCSLuaFile( "shared.lua" )

SWEP.PrintName			= "USP"			
SWEP.Slot				= 1
SWEP.SlotPos			= 1

SWEP.ViewModelFOV		= 57
SWEP.ViewModelFlip		= false

SWEP.HoldType			= "pistol"
SWEP.Base				= "weapon_base_mg"
SWEP.Category			= "Secondary"

//Primary
SWEP.Primary.Automatic		= false
SWEP.Primary.Sound 			= Sound("Weapon_USP.Single")
SWEP.Primary.Damage = 9999
SWEP.Primary.Delay = 0.05
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/cstrike/c_pist_usp.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_usp.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

function SWEP:DrawHUD()
end

function SWEP:PrimaryAttack()

	-- Make sure we can shoot first
	if ( !self:CanPrimaryAttack() ) then return end
	if not self.Owner.NumberOfBullets then
		self.Owner.NumberOfBullets = 1
	end
	
	self.Owner.NumberOfBullets = self.Owner.NumberOfBullets - 1

	-- Play shoot sound
	self:EmitSound(self.Primary.Sound)
	
	-- Shoot 9 bullets, 150 damage, 0.75 aimcone
	self:ShootBullet(self.Primary.Damage, 1, 0.01 )
	
	-- Remove 1 bullet from our clip
	self:TakePrimaryAmmo(1)
	
	-- Punch the player's view
	self.Owner:ViewPunch( Angle( -1, 0, 0 ) )

	self.NextFireTime = CurTime() + self.Primary.Delay
end

function SWEP:Reload()
	if self.Owner.NumberOfBullets and self.Owner.NumberOfBullets > 0 then
		self.Weapon:DefaultReload( ACT_VM_RELOAD )
	end
end

function SWEP:CanPrimaryAttack()

	if self.Owner.NumberOfBullets and self.Owner.NumberOfBullets <= 0 then return end
	
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