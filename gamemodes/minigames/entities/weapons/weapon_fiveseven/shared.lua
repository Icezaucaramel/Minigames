AddCSLuaFile( "shared.lua" )

SWEP.PrintName			= "Pistol"			
SWEP.Slot				= 1
SWEP.SlotPos			= 1

SWEP.ViewModelFOV		= 57
SWEP.ViewModelFlip		= false

SWEP.HoldType			= "pistol"
SWEP.Base				= "weapon_base_mg"
SWEP.Category			= "Secondary"

//Primary
SWEP.Primary.Automatic		= false
SWEP.Primary.Sound 			= Sound( "Weapon_FiveSeven.Single" )
SWEP.Primary.Damage = 20
SWEP.Primary.Delay = 1.5
SWEP.Primary.ClipSize = 20
SWEP.Primary.DefaultClip = 120

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.WorldModel = "models/weapons/w_pist_fiveseven.mdl"
SWEP.ViewModel	= "models/weapons/cstrike/c_pist_fiveseven.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false