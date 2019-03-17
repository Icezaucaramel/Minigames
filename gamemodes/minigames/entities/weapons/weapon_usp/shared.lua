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
SWEP.Secondary.IronFOV			= 55
SWEP.Primary.Recoil = 0.01
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.01
SWEP.Primary.Damage = 14
SWEP.Primary.Delay = 0.05
SWEP.Primary.ClipSize = 13
SWEP.Primary.DefaultClip = 216


SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/cstrike/c_pist_usp.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_usp.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.IronSightsPos = Vector(-5.89, -3.237, 2.68)
SWEP.IronSightsAng = Vector(0.087, 0.041, 0)
SWEP.SightsPos = Vector(-5.89, -3.237, 2.68)
SWEP.SightsAng = Vector(0.087, 0.041, 0)
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(-9.469, -1.701, 0)