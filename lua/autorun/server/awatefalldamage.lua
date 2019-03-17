--Awate's mp_falldamage implementation
--Thanks to FOSS for informing me of the formula that the source engine uses for fall damage calculation.
function AwateFallDamage( pl, flFallSpeed )
	local gravity = server_settings.Int( "sv_gravity", 600 )
	return (flFallSpeed-580) * GetConVarNumber( "mp_falldamage" ) * (gravity)/600
end
hook.Add( "GetFallDamage", "AwateFallDamage", AwateFallDamage)
