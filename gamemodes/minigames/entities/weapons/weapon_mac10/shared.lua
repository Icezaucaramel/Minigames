AddCSLuaFile( "shared.lua" )

SWEP.PrintName			= "MAC10"			
SWEP.Slot				= 0
SWEP.SlotPos			= 1

SWEP.ViewModelFOV		= 57
SWEP.ViewModelFlip		= false

SWEP.HoldType			= "ar2"
SWEP.Base				= "weapon_base_mg"
SWEP.Category			= "Primary"

//Primary
SWEP.Primary.Automatic		= true
SWEP.Primary.Sound 			= Sound( "Weapon_Mac10.Single" )
SWEP.Primary.Damage = 12
SWEP.Primary.Delay = 0.065
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 90

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.ViewModel	= "models/weapons/cstrike/c_smg_mac10.mdl"
SWEP.WorldModel	= "models/weapons/w_smg_mac10.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false