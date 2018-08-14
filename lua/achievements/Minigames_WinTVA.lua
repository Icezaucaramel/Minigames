local ACH = {}
ACH.IDName = "mg1" -- ID Name, to add progress.
ACH.PrintName = "Angel From Hell" -- Print Name, this is displayed on the menu and such.
ACH.Description = "As Team Red, win Two Versus All."
ACH.Cat = "Minigames" -- Category to place the achievement in
ACH.Reward = "" -- File name of pointshop item to give, change to a number that's not in a string to give points instead.
ACH.RewardName = "" -- Name of the reward you want displayed on the menu.
ACH.AmountRequired = 1 -- How many times a player must do said task to get the achievement.

hook.Add("RoundEnd", "afh", function(stateid)
	
	if not Minigames then return end
	if not Minigames:IsPlayingTwoVersusAll() then return end

	if stateid == 3 then
		for k, v in pairs(team.GetPlayers(3)) do
			if v:Alive() then
				v:AddAchievementProgress(ACH.IDName, 1)
			end
		end
	end
end)	

Achievements:RegisterAchievement(ACH)