AddCSLuaFile( "shared.lua" )

SWEP.PrintName			= "P228"			
SWEP.Slot				= 1
SWEP.SlotPos			= 1

SWEP.ViewModelFOV		= 57
SWEP.ViewModelFlip		= false

SWEP.HoldType			= "pistol"
SWEP.Base				= "weapon_base_mg"
SWEP.Category			= "Secondary"

//Primary
SWEP.Primary.Automatic = false
SWEP.Primary.Sound	= Sound( "Weapon_P228.Single" )
SWEP.Secondary.IronFOV			= 55
SWEP.Primary.Recoil = 0.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.01
SWEP.Primary.Damage = 24
SWEP.Primary.Delay = 0.15
SWEP.Primary.ClipSize = 13
SWEP.Primary.DefaultClip = 420

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.WorldModel = "models/weapons/w_pist_p228.mdl"
SWEP.ViewModel	= "models/weapons/cstrike/c_pist_p228.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.IronSightsPos = Vector(-5.973, -4.194, 2.96)
SWEP.IronSightsAng = Vector(-0.47, -0.069, -0.144)
SWEP.SightsPos = Vector(-5.973, -4.194, 2.96)
SWEP.SightsAng = Vector(-0.47, -0.069, -0.144)
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(-9.469, -1.701, 0)