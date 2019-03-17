AddCSLuaFile( "shared.lua" )

SWEP.PrintName			= "MP5 Navy"			
SWEP.Slot				= 0
SWEP.SlotPos			= 1

SWEP.ViewModelFOV		= 57
SWEP.ViewModelFlip		= false

SWEP.HoldType			= "smg"
SWEP.Base				= "weapon_base_mg"
SWEP.Category			= "Primary"

//Primary
SWEP.Primary.Automatic		= true
SWEP.Primary.Sound 			= Sound( "Weapon_MP5Navy.Single" )
SWEP.Secondary.IronFOV			= 55
SWEP.Primary.Recoil = 0.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.01
SWEP.Primary.Damage = 10
SWEP.Primary.Delay = 0.095
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 420

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.WorldModel = "models/weapons/w_smg_mp5.mdl"
SWEP.ViewModel	= "models/weapons/cstrike/c_smg_mp5.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.IronSightsPos = Vector(-5.321, 0, 1.84)
SWEP.IronSightsAng = Vector(1.149, 0.023, 0)
SWEP.SightsPos = Vector(-5.321, 0, 1.84)
SWEP.SightsAng = Vector(1.149, 0.023, 0)
SWEP.RunSightsPos = Vector(5.748, -9.686, 0)
SWEP.RunSightsAng = Vector(-6.974, 49.881, -5.237)