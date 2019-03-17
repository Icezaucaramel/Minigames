AddCSLuaFile( "shared.lua" )

SWEP.PrintName			= "Ump"			
SWEP.Slot				= 0
SWEP.SlotPos			= 1

SWEP.ViewModelFOV		= 57
SWEP.ViewModelFlip		= false

SWEP.HoldType			= "ar2"
SWEP.Base				= "weapon_base_mg"
SWEP.Category			= "Primary"

//Primary
SWEP.Primary.Automatic		= true
SWEP.Primary.Sound 			= Sound( "Weapon_TMP.Single" )
SWEP.Secondary.IronFOV = 55
SWEP.Primary.Recoil = 0.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.01
SWEP.Primary.Damage = 12
SWEP.Primary.Delay = 0.09
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 420

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.WorldModel = "models/weapons/w_smg_tmp.mdl"
SWEP.ViewModel	= "models/weapons/cstrike/c_smg_tmp.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.IronSightsPos = Vector(-6.841, 0, 2.24)
SWEP.IronSightsAng = Vector(1.23, 0, 0)
SWEP.SightsPos = Vector(-6.841, 0, 2.24)
SWEP.SightsAng = Vector(1.23, 0, 0)
SWEP.RunSightsPos = Vector(9.135, -4.999, 0)
SWEP.RunSightsAng = Vector(-9.282, 21.198, 0)