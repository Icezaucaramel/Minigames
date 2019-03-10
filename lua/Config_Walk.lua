local function disablesprint( ply )
    ply:SprintDisable()
end
hook.Add( "PlayerSpawn", "Sprint_Disable", disablesprint)