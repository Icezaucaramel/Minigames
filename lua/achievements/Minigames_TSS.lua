local ACH = {}
ACH.IDName = "mg3" -- ID Name, to add progress.
ACH.PrintName = "Werewolf Gimmick" -- Print Name, this is displayed on the menu and such.
ACH.Description = "Be the only survivor in Team Survival."
ACH.Cat = "Minigames" -- Category to place the achievement in
ACH.Reward = "" -- File name of pointshop item to give, change to a number that's not in a string to give points instead.
ACH.RewardName = "" -- Name of the reward you want displayed on the menu.
ACH.AmountRequired = 1 -- How many times a player must do said task to get the achievement.

hook.Add("RoundEnd", "tmg", function(stateid)

	if not Minigames then return end
	if not Minigames:IsPlayingTeamSurvival() then return end

	if stateid == 2 or stateid == 3 then
		local num = 0
		local werewolf = nil
		for k, v in pairs(team.GetPlayers(stateid)) do
			if v:Alive() then
				num = num + 1
				werewolf = v
			end
			
			if num == 1 then
				werewolf:AddAchievementProgress(ACH.IDName, 1)
			end
		end
	end
end)

Achievements:RegisterAchievement(ACH)