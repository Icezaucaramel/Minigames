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
SWEP.Primary.Sound 			= Sound( "Weapon_FAMAS.Single" )
SWEP.Primary.Damage = 23
SWEP.Primary.Delay = 0.09
SWEP.Primary.ClipSize = 35
SWEP.Primary.DefaultClip = 105

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.WorldModel = "models/weapons/w_rif_galil.mdl"
SWEP.ViewModel	= "models/weapons/cstrike/c_rif_galil.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false