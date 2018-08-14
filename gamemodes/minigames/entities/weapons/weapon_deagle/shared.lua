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
SWEP.Primary.Damage = 37
SWEP.Primary.Delay = 0.6
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 42

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.WorldModel = "models/weapons/w_pist_deagle.mdl"
SWEP.ViewModel	= "models/weapons/cstrike/c_pist_deagle.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false