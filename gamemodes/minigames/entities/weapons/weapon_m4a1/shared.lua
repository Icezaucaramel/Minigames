AddCSLuaFile( "shared.lua" )

SWEP.PrintName			= "M16"			
SWEP.Slot				= 0
SWEP.SlotPos			= 1

SWEP.ViewModelFOV		= 57
SWEP.ViewModelFlip		= false

SWEP.HoldType			= "ar2"
SWEP.Base				= "weapon_base_mg"
SWEP.Category			= "Primary"

//Primary
SWEP.Primary.Automatic		= true
SWEP.Primary.Sound 			= Sound( "Weapon_M4A1.Single" )
SWEP.Primary.Damage = 23
SWEP.Primary.Delay = 0.19
SWEP.Primary.ClipSize = 20
SWEP.Primary.DefaultClip = 60

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.WorldModel = "models/weapons/w_rif_m4a1.mdl"
SWEP.ViewModel	= "models/weapons/cstrike/c_rif_m4a1.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false