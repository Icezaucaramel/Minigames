local ACH = {}
ACH.IDName = "ac" -- ID Name, to add progress.
ACH.PrintName = "Prize Collector" -- Print Name, this is displayed on the menu and such.
ACH.Description = "Win Assault Course by picking up the Teddy."
ACH.Cat = "Minigames" -- Category to place the achievement in
ACH.Reward = "" -- File name of pointshop item to give, change to a number that's not in a string to give points instead.
ACH.RewardName = "" -- Name of the reward you want displayed on the menu.
ACH.AmountRequired = 1 -- How many times a player must do said task to get the achievement.

hook.Add("UsedTeddy", "td", function(ply)
	if Minigames:IsPlayingAssaultCourse() then
		ply:GiveAchievementProgress(ACH.IDName, 1)
	end
end)	

Achievements:RegisterAchievement(ACH)