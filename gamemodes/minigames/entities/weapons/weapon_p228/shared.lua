AddCSLuaFile( "shared.lua" )

SWEP.PrintName			= "P228"			
SWEP.Slot				= 1
SWEP.SlotPos			= 1

SWEP.ViewModelFOV		= 57
SWEP.ViewModelFlip		= false

SWEP.HoldType			= "pistol"
SWEP.Base				= "weapon_base_mg"
SWEP.Category			= "Secondary"

//Primary
SWEP.Primary.Automatic = false
SWEP.Primary.Sound	= Sound( "Weapon_P228.Single" )
SWEP.Primary.Damage = 24
SWEP.Primary.Delay = 0.15
SWEP.Primary.ClipSize = 13
SWEP.Primary.DefaultClip = 78

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.WorldModel = "models/weapons/w_pist_p228.mdl"
SWEP.ViewModel	= "models/weapons/cstrike/c_pist_p228.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false