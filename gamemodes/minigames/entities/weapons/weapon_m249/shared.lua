AddCSLuaFile( "shared.lua" )

SWEP.PrintName			= "M249"			
SWEP.Slot				= 0
SWEP.SlotPos			= 1

SWEP.ViewModelFOV		= 57
SWEP.ViewModelFlip		= false

SWEP.HoldType			= "ar2"
SWEP.Base				= "weapon_base_mg"
SWEP.Category			= "Primary"

//Primary
SWEP.Primary.Automatic		= true
SWEP.Primary.Sound 			= Sound( "Weapon_m249.Single" )
SWEP.Secondary.IronFOV			= 55
SWEP.Primary.Recoil = 0.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.01
SWEP.Primary.Damage = 7
SWEP.Primary.Delay = 0.085
SWEP.Primary.ClipSize = 100
SWEP.Primary.DefaultClip = 420

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/cstrike/c_mach_m249para.mdl"
SWEP.WorldModel			= "models/weapons/w_mach_m249para.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.IronSightsPos = Vector(-5.933, -1.727, 2.279)
SWEP.IronSightsAng = Vector(0.209, 0.057, 0)
SWEP.SightsPos = Vector(-5.933, -1.727, 2.279)
SWEP.SightsAng = Vector(0.209, 0.057, 0)
SWEP.RunSightsPos = Vector(13.307, -15.827, 0)
SWEP.RunSightsAng = Vector(-10.749, 70, -3.583)