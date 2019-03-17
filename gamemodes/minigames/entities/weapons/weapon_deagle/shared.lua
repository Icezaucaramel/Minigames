AddCSLuaFile( "shared.lua" )

SWEP.PrintName			= "Deagle"			
SWEP.Slot				= 1
SWEP.SlotPos			= 1

SWEP.ViewModelFOV		= 57
SWEP.ViewModelFlip		= false

SWEP.HoldType			= "pistol"
SWEP.Base				= "weapon_base_mg"
SWEP.Category			= "Primary"

//Primary
SWEP.Primary.Automatic		= false
SWEP.Primary.Sound 			= Sound("Weapon_DEagle.Single")
SWEP.Primary.Recoil = 0.8
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.01
SWEP.Primary.Damage = 34
SWEP.Primary.Delay = 0.550
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 420

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.WorldModel = "models/weapons/w_pist_deagle.mdl"
SWEP.ViewModel	= "models/weapons/cstrike/c_pist_deagle.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
SWEP.Secondary.IronFOV			= 65
SWEP.IronSightsPos = Vector(-6.361, -5.579, 1.919)
SWEP.IronSightsAng = Vector(0.718, 0, 0)
SWEP.SightsPos = Vector(-6.361, -5.579, 1.919)
SWEP.SightsAng = Vector(0.718, 0, 0)
SWEP.RunSightsPos = Vector(2.405, -17.334, -15.011)
SWEP.RunSightsAng = Vector(70, 0, 0)
