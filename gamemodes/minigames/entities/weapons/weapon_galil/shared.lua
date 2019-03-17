AddCSLuaFile( "shared.lua" )

SWEP.PrintName			= "Galil"			
SWEP.Slot				= 0
SWEP.SlotPos			= 1

SWEP.ViewModelFOV		= 57
SWEP.ViewModelFlip		= false

SWEP.HoldType			= "smg"
SWEP.Base				= "weapon_base_mg"
SWEP.Category			= "Primary"

//Primary
SWEP.Primary.Automatic		= true
SWEP.Primary.Sound 			= Sound( "Weapon_GALIL.Single" )
SWEP.Primary.Recoil = 0.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.01
SWEP.Primary.Damage = 16
SWEP.Primary.Delay = 0.140
SWEP.Primary.ClipSize = 35
SWEP.Primary.DefaultClip = 420

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.WorldModel = "models/weapons/w_rif_galil.mdl"
SWEP.ViewModel	= "models/weapons/cstrike/c_rif_galil.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.IronSightsPos = Vector(-6.362, -3.52, 2.64)
SWEP.IronSightsAng = Vector(-0.159, 0, 0)
SWEP.SightsPos = Vector(-6.362, -3.52, 2.64)
SWEP.SightsAng = Vector(-0.159, 0, 0)
SWEP.RunSightsPos = Vector(9.369, -17.244, -3.689)
SWEP.RunSightsAng = Vector(6.446, 62.852, 0)
SWEP.Secondary.IronFOV			= 55