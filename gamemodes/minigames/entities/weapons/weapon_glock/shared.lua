AddCSLuaFile( "shared.lua" )

SWEP.PrintName			= "Glock"			
SWEP.Slot				= 1
SWEP.SlotPos			= 1

SWEP.ViewModelFOV		= 57
SWEP.ViewModelFlip		= false

SWEP.HoldType			= "pistol"
SWEP.Base				= "weapon_base_mg"
SWEP.Category			= "Secondary"

//Primary
SWEP.Primary.Automatic		= true
SWEP.Primary.Sound 			= Sound("Weapon_Glock.Single")
SWEP.Secondary.IronFOV			= 55
SWEP.Primary.Recoil = 0.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.01
SWEP.Primary.Damage = 12
SWEP.Primary.Delay = 0.095
SWEP.Primary.ClipSize = 20
SWEP.Primary.DefaultClip = 420


SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.WorldModel = "models/weapons/w_pist_glock18.mdl"
SWEP.ViewModel	= "models/weapons/cstrike/c_pist_glock18.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
SWEP.IronSightsPos = Vector(-5.781, -3.082, 2.68)
SWEP.IronSightsAng = Vector(0.824, 0, 0)
SWEP.SightsPos = Vector(-5.781, -3.082, 2.68)
SWEP.SightsAng = Vector(0.824, 0, 0)
SWEP.RunSightsPos = Vector(6.736, -2.495, 0)
SWEP.RunSightsAng = Vector(-9.343, 12.324, 0)
