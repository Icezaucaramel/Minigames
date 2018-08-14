local ACH = {}
ACH.IDName = "tfm" -- ID Name, to add progress.
ACH.PrintName = "Up The Wolves" -- Print Name, this is displayed on the menu and such.
ACH.Description = "Kill 10 players in Team Deathmatch"
ACH.Cat = "Minigames" -- Category to place the achievement in
ACH.Reward = "" -- File name of pointshop item to give, change to a number that's not in a string to give points instead.
ACH.RewardName = "" -- Name of the reward you want displayed on the menu.
ACH.AmountRequired = 10 -- How many times a player must do said task to get the achievement.

hook.Add("PlayerDeath", "utw", function(ply,inflictor,attacker)
	
	if not Minigames then return end
	if not Minigames:IsPlayingTeamDeathmatch() then return end

	if ply != attacker and attacker:IsPlayer() then
		attacker:AddAchievementProgress(ACH.IDName,1)
	end
end)	

Achievements:RegisterAchievement(ACH)