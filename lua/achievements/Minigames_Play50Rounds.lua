local ACH = {}
ACH.IDName = "mg4" -- ID Name, to add progress.
ACH.PrintName = "Tourist" -- Print Name, this is displayed on the menu and such.
ACH.Description = "Play 50 rounds of Minigames."
ACH.Cat = "Minigames" -- Category to place the achievement in
ACH.Reward = "" -- File name of pointshop item to give, change to a number that's not in a string to give points instead.
ACH.RewardName = "" -- Name of the reward you want displayed on the menu.
ACH.AmountRequired = 50 -- How many times a player must do said task to get the achievement.

hook.Add("RoundPlayer", "tourist", function(ply)
	ply:AddAchievementProgress(ACH.IDName, 1)
end)	

Achievements:RegisterAchievement(ACH)