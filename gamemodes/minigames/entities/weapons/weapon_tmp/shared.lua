AddCSLuaFile( "shared.lua" )

SWEP.PrintName			= "TMP"			
SWEP.Slot				= 0
SWEP.SlotPos			= 1

SWEP.ViewModelFOV		= 57
SWEP.ViewModelFlip		= false

SWEP.HoldType			= "ar2"
SWEP.Base				= "weapon_base_mg"
SWEP.Category			= "Primary"

//Primary
SWEP.Primary.Automatic		= true
SWEP.Primary.Sound 			= Sound( "Weapon_TMP.Single" )
SWEP.Primary.Damage = 13
SWEP.Primary.Delay = 0.07
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 90

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.WorldModel = "models/weapons/w_smg_tmp.mdl"
SWEP.ViewModel	= "models/weapons/cstrike/c_smg_tmp.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false