local ACH = {}
ACH.IDName = "mg2" -- ID Name, to add progress.
ACH.PrintName = "Holy Nova" -- Print Name, this is displayed on the menu and such.
ACH.Description = "Kill 3 or more people in round of Team Deathmatch"
ACH.Cat = "Minigames" -- Category to place the achievement in
ACH.Reward = "" -- File name of pointshop item to give, change to a number that's not in a string to give points instead.
ACH.RewardName = "" -- Name of the reward you want displayed on the menu.
ACH.AmountRequired = 1 -- How many times a player must do said task to get the achievement.

hook.Add("PlayerSpawn", "HN1", function(ply)
	ply.HolyNova = 0
end)	

hook.Add("PlayerDeath", "MG1", function(ply,inflictor,attacker)
	if not Minigames then return end
	
	if Minigames:IsPlayingTeamDeathmatch() then
		attacker.HolyNova = attacker.HolyNova + 1
		
		if attacker.HolyNova >= 3 then
			ply:AddAchievementProgress(ACH.IDName, 1)
		end
	end
end)

Achievements:RegisterAchievement(ACH)