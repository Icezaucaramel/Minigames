AddCSLuaFile( "shared.lua" )

SWEP.PrintName			= "G3SG1"			
SWEP.Slot				= 0
SWEP.SlotPos			= 1

SWEP.ViewModelFOV		= 57
SWEP.ViewModelFlip		= false

SWEP.HoldType			= "smg"
SWEP.Base				= "weapon_base_mg"
SWEP.Category			= "Primary"

//Primary
SWEP.Primary.Automatic		= true
SWEP.Primary.Sound 			= Sound( "Weapon_G3SG1.Single" )
SWEP.Primary.Damage = 65
SWEP.Primary.Delay = 0.25
SWEP.Primary.ClipSize = 20
SWEP.Primary.DefaultClip = 60

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.WorldModel = "models/weapons/w_snip_g3sg1.mdl"
SWEP.ViewModel	= "models/weapons/cstrike/c_snip_g3sg1.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false