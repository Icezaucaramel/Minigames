AddCSLuaFile( "shared.lua" )

SWEP.PrintName			= "MP5 Navy"			
SWEP.Slot				= 0
SWEP.SlotPos			= 1

SWEP.ViewModelFOV		= 57
SWEP.ViewModelFlip		= false

SWEP.HoldType			= "smg"
SWEP.Base				= "weapon_base_mg"
SWEP.Category			= "Primary"

//Primary
SWEP.Primary.Automatic		= true
SWEP.Primary.Sound 			= Sound( "Weapon_MP5Navy.Single" )
SWEP.Primary.Damage = 14
SWEP.Primary.Delay = 0.08
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 90

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.WorldModel = "models/weapons/w_smg_mp5.mdl"
SWEP.ViewModel	= "models/weapons/cstrike/c_smg_mp5.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false