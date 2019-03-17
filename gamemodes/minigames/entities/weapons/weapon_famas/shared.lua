AddCSLuaFile( "shared.lua" )

SWEP.PrintName			= "Famas"			
SWEP.Slot				= 0
SWEP.SlotPos			= 1

SWEP.ViewModelFOV		= 57
SWEP.ViewModelFlip		= false

SWEP.HoldType			= "smg"
SWEP.Base				= "weapon_base_mg"
SWEP.Category			= "Primary"

//Primary
SWEP.Primary.Automatic		= true
SWEP.Primary.Sound 			= Sound( "weapon_famas.Single" )
SWEP.Primary.Recoil = 0.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.01
SWEP.Primary.Damage = 18
SWEP.Primary.Delay = 0.10
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 420

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.ViewModel				= "models/weapons/cstrike/c_rif_famas.mdl"
SWEP.WorldModel				= "models/weapons/w_rif_famas.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.IronSightsPos = Vector(-6.24, -3.324, 1.138)
SWEP.IronSightsAng = Vector(0.187, 0, -0.433)
SWEP.SightsPos = Vector(-6.24, -3.324, 1.138)
SWEP.SightsAng = Vector(0.187, 0, -0.433)
SWEP.RunSightsPos = Vector(8.27, -5.498, 0.243)
SWEP.RunSightsAng = Vector(-7.789, 51.139, 0)
SWEP.Secondary.IronFOV			= 55