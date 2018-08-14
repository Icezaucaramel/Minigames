AddCSLuaFile( "shared.lua" )

SWEP.PrintName			= "AK47"			
SWEP.Slot				= 0
SWEP.SlotPos			= 1

SWEP.ViewModelFOV		= 57
SWEP.ViewModelFlip		= false

SWEP.HoldType			= "smg"
SWEP.Base				= "weapon_base_mg"
SWEP.Category			= "Primary"

//Primary
SWEP.Primary.Automatic		= true
SWEP.Primary.Sound 			= Sound( "Weapon_AK47.Single" )
SWEP.Primary.Damage = 27
SWEP.Primary.Delay = 0.1
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 90

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.WorldModel = "models/weapons/w_rif_ak47.mdl"
SWEP.ViewModel	= "models/weapons/cstrike/c_rif_ak47.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false