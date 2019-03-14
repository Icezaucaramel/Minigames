SWEP.PrintName 		= "Knife"
 
 
SWEP.AdminSpawnable = true  
SWEP.Spawnable 		= false 
 
SWEP.ViewModelFOV 	= 64 
SWEP.ViewModel 		= "models/weapons/knife.mdl" 

 
SWEP.AutoSwitchTo 	= false
SWEP.AutoSwitchFrom = false 
 
SWEP.Slot 			= 1 
SWEP.SlotPos = 1 
SWEP.HoldType = "Knife" 
 
SWEP.FiresUnderwater = true 

SWEP.Weight = 5  
 
SWEP.DrawCrosshair = true 
 
SWEP.Category = "CS:S Weapons" 
 
SWEP.DrawAmmo = false  
 
SWEP.Gun = ("weapon_knife") -- must be the name of your swep but NO CAPITALS!
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
    if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "bobs_blacklisted" SWEP.PrintName = SWEP.Gun return end
    
--//General settings\\
 
--//PrimaryFire Settings\\ -- C'est le clique gauche BB
SWEP.Primary.Sound = "knife_deploy1.wav" 
SWEP.Primary.Damage = 30 
SWEP.Primary.TakeAmmo = 1 
SWEP.Primary.ClipSize = 100 
SWEP.Primary.DefaultClip = 100 
SWEP.Primary.Spread = 0.001 
SWEP.Primary.NumberofShots = 1 
SWEP.Primary.Automatic = false 
SWEP.Primary.Recoil = 0 
SWEP.Primary.Delay = 3 
SWEP.Primary.Force = 1000
--//PrimaryFire settings\\
 
--//Secondary Fire Variables\\ 
SWEP.Secondary.NumberofShots = 0 
SWEP.Secondary.Force = 1000 
SWEP.Secondary.Spread = 0.001 
SWEP.Secondary.Sound = "knife_deploy1.wav" .
SWEP.Secondary.Automatic = false 
SWEP.Secondary.Recoil = 10 
SWEP.Secondary.Delay = 3 
SWEP.Secondary.TakeAmmo = 1 
SWEP.Secondary.ClipSize = 100 
SWEP.Secondary.Damage = 0 
SWEP.Secondary.Magnitude = "0" 
--//Secondary Fire Variables\\
 
--//SWEP:Initialize\\ 
function SWEP:Initialize() 
	util.PrecacheSound(self.Primary.Sound) 
	util.PrecacheSound(self.Secondary.Sound) 
        self:SetWeaponHoldType( self.HoldType )
end 
--//SWEP:Initialize\\
 
--SWEP:PrimaryFire\\ 
function SWEP:PrimaryAttack()
 
	if ( !self:CanPrimaryAttack() ) then return end
 
	local bullet = {} 
		bullet.Num = self.Primary.NumberofShots
		bullet.Src = self.Owner:GetShootPos() 
		bullet.Dir = self.Owner:GetAimVector() 
		bullet.Spread = Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0)
                
		bullet.Tracer = 0 
		bullet.Force = self.Primary.Force 
		bullet.Damage = self.Primary.Damage 
		bullet.AmmoType = self.Primary.Ammo 
 
	local rnda = self.Primary.Recoil * -1 
	local rndb = self.Primary.Recoil * math.random(-1, 1) 
 
	self:ShootEffects()
 
	self.Owner:FireBullets( bullet ) 
	self:EmitSound(Sound(self.Primary.Sound)) 
	self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) ) 
	self:TakePrimaryAmmo(self.Primary.TakeAmmo) 
 
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self:SetNextSecondaryFire( CurTime() + self.Primary.Delay ) 
end 
--//SWEP:PrimaryFire\\
 
--//SWEP:SecondaryFire\\ 
function SWEP:SecondaryAttack() 
	if ( !self:CanSecondaryAttack() ) then return end 
 
	local rnda = -self.Secondary.Recoil 
	local rndb = self.Secondary.Recoil * math.random(-1, 1) 
 
	self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) ) //Makes the gun have recoil
        
 
	local eyetrace = self.Owner:GetEyeTrace()
	self:EmitSound ( self.Secondary.Sound ) //Adds sound
	self:ShootEffects() 
	local explode = ents.Create("env_explosion")
		explode:SetPos( eyetrace.HitPos ) //Puts the explosion where you are aiming
		explode:SetOwner( self.Owner ) //Sets the owner of the explosion
		explode:Spawn()
		explode:SetKeyValue("iMagnitude","175") //Sets the magnitude of the explosion
		explode:Fire("Explode", 0, 0 ) //Tells the explode entity to explode
		explode:EmitSound("weapon_AWP.Single", 400, 400 ) //Adds sound to the explosion
 
	self:SetNextPrimaryFire( CurTime() + self.Secondary.Delay ) 
	self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay ) 
	self:TakePrimaryAmmo(self.Secondary.TakeAmmo) 
end 