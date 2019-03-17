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
SWEP.Primary.Sound 			= Sound( "Weapon_UMP45.Single" )
SWEP.Primary.Recoil = 0.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.01
SWEP.Primary.Damage = 12
SWEP.Primary.Delay = 0.1
SWEP.Primary.ClipSize = 35
SWEP.Primary.DefaultClip = 420

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.ViewModel				= "models/weapons/cstrike/c_smg_ump45.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_smg_ump45.mdl"	-- Weapon world model

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.IronSightsPos = Vector(-8.754, -5.351, 4.219)
SWEP.IronSightsAng = Vector(-1.331, -0.28, -2.112)
SWEP.SightsPos = Vector(-8.754, -5.351, 4.219)
SWEP.SightsAng = Vector(-1.331, -0.28, -2.112)
SWEP.RunSightsPos = Vector(8.135, -7.776, 0)
SWEP.RunSightsAng = Vector(-5.575, 39.759, 0)
SWEP.Secondary.IronFOV			= 55