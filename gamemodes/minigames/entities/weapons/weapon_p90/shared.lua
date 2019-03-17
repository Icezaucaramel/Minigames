AddCSLuaFile( "shared.lua" )

SWEP.PrintName			= "P90"			
SWEP.Slot				= 0
SWEP.SlotPos			= 1


SWEP.ViewModelFOV		= 57
SWEP.ViewModelFlip		= false

SWEP.HoldType			= "smg"
SWEP.Base				= "weapon_base_mg"
SWEP.Category			= "Primary"

//Primary
SWEP.Primary.Automatic		= true
SWEP.Primary.Sound 			= Sound( "Weapon_P90.Single" )
SWEP.Secondary.IronFOV			= 55
SWEP.Primary.Recoil = 0.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.01
SWEP.Primary.Damage = 14
SWEP.Primary.Delay = 0.08
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 420

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.WorldModel = "models/weapons/w_smg_p90.mdl"
SWEP.ViewModel                = "models/weapons/cstrike/c_smg_p90.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.IronSightsPos = Vector(-4.2, -4.228, 0.879)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.SightsPos = Vector(-4.2, -4.228, 0.879)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(5.75, -6.941, 0)
SWEP.RunSightsAng = Vector(-6.974, 49.881, -5.237)