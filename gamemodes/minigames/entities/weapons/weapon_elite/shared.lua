AddCSLuaFile( "shared.lua" )

SWEP.PrintName			= "Dual Elites"			
SWEP.Slot				= 1
SWEP.SlotPos			= 1

SWEP.ViewModelFOV		= 57
SWEP.ViewModelFlip		= false

SWEP.HoldType			= "pistol"
SWEP.Base				= "weapon_base_mg"
SWEP.Category			= "Primary"

//Primary
SWEP.Primary.Automatic		= false
SWEP.Primary.Sound 			= Sound("Weapon_ELITE.Single")
SWEP.Primary.Recoil = 0.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.01
SWEP.Primary.Damage = 18
SWEP.Primary.Delay = 0.12

SWEP.Primary.ClipSize = 25
SWEP.Primary.DefaultClip = 420

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.WorldModel = "models/weapons/w_pist_elite.mdl"
SWEP.ViewModel	= "models/weapons/cstrike/c_pist_elite.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.IronSightsPos = Vector(0, 0, 0)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.SightsPos = Vector(0, 0, 0)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(0, 0, 2.131)
SWEP.RunSightsAng = Vector(-13.771, 0, 0)
SWEP.Secondary.IronFOV			= 0	