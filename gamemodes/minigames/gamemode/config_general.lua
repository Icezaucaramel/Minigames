-- Pointshop
Minigames.UsePointshop = false -- Do you have a Pointshop installed and would you like players to get rewards for playing?
Minigames.UsePointshop_2 = true -- Do you have a Pointshop installed and would you like players to get rewards for playing?
Minigames.PointsPerKill = 10 -- How many Pointshop points should players get?

-- Misc
Minigames.GamevoteTimer = 15 -- How many seconds do players have to vote?
Minigames.MapvoteTimer = 15 -- How many seconds do players have to vote?
Minigames.EnableFastDL = true -- Set to true to use fastdl, instead of Workshop download

-- Addon support
Minigames.DefaultHUD = true -- Change to false if you're using a custom/different hud
Minigames.DefaultScoreboard = true -- Change to false to use a custom scoreboard addon
Minigames.DefaultMapvote = true -- Change to false if you're using a custom mapvote

-- Rounds
Minigames.LateJoinersTime = 10 -- How many seconds into a round can later joiners spawn, instead of waiting until next round?
Minigames.InitialPreRound = 10 -- When the server loads a map or is started, how many seconds until the first round? Give players enough time to load in!
Minigames.PreRound = 5 -- When the server loads a map or is started, how many seconds until the first round? Give players enough time to load in!
Minigames.EndOfRoundTime = 10 -- How many seconds should players get in between waves?

-- /Winning Points -- Only if Pointshop is enabled.
Minigames.TeamDeathmatch.WinningPoints = 25 -- How many points should the winning team get?
Minigames.FreeForAll.WinningPoints = 75 -- How many points should the remaining person in FFA get?
Minigames.AssaultCourse.WinningPoints = 100 -- How many points should a player get if they press E on a teddy during AC?
Minigames.TwoVersusAll.WinningPoints = 20 -- How many points should the winning team get in TVA?

-- Number of Rounds
Minigames.AssaultCourse.NumberOfRounds = 8 -- How many rounds of AC should we play?
Minigames.FreeForAll.NumberOfRounds = 10 -- How many rounds of FFA should we play?
Minigames.TeamDeathmatch.NumberOfRounds = 6 -- How many rounds of TDM should we play?
Minigames.TeamSurvival.NumberOfRounds = 10 -- How many rounds of TS should we play?
Minigames.TwoVersusAll.NumberOfRounds = 10 -- How many rounds of TVA should we play?

-- Round time
Minigames.AssaultCourse.RoundTime = 60*6
Minigames.TeamDeathmatch.RoundTime = 60*3
Minigames.TwoVersusAll.RoundTime = 60*3
Minigames.TeamSurvival.RoundTime = 60*4
Minigames.FreeForAll.RoundTime = 60*3

--

--Capture The Flag
Minigames.CaptureTheFlag.WinCondition = 3 -- How many captures does a team need to win?
Minigames.CaptureTheFlag.RespawnTime = 6 -- How many seconds is a player death before they come back to life?
Minigames.CaptureTheFlag.FlagReset = 10 -- How many seconds is a player death before they come back to life?
Minigames.CaptureTheFlag.NumberOfRounds = 1 -- How many rounds of CTF should we play?
Minigames.CaptureTheFlag.RoundTime = 60*8 -- How long should CTF rounds last?

--

--

--Walk Speeds
Minigames.AssaultCourse.WalkSpeed = 275
Minigames.TeamDeathmatch.WalkSpeed = 275
Minigames.TwoVersusAll.WalkSpeed = 275
Minigames.TeamSurvival.WalkSpeed = 275
Minigames.FreeForAll.WalkSpeed = 275
Minigames.CaptureTheFlag.WalkSpeed = 275

--Run Speeds
Minigames.AssaultCourse.RunSpeed = 275
Minigames.TeamDeathmatch.RunSpeed = 275
Minigames.TwoVersusAll.RunSpeed = 275
Minigames.TeamSurvival.RunSpeed = 275
Minigames.FreeForAll.RunSpeed = 275
Minigames.CaptureTheFlag.RunSpeed = 275

--

-- Player Models that users can pick if it's Assault Course and Free For All
Minigames.GenericPlayerModels = {
	"models/player/alyx.mdl",
	"models/player/barney.mdl",
	"models/player/breen.mdl",
	"models/player/charple.mdl",
	"models/player/p2_chell.mdl",
	"models/player/corpse1.mdl",
	"models/player/combine_soldier.mdl",
	"models/player/combine_soldier_prisonguard.mdl",
	"models/player/combine_super_soldier.mdl",
	"models/player/eli.mdl",
	"models/player/gman_high.mdl",
	"models/player/kleiner.mdl",
	"models/player/monk.mdl",
	"models/player/mossman.mdl",
	"models/player/mossman_arctic.mdl",
	"models/player/odessa.mdl",
	"models/player/police.mdl",
	"models/player/police_fem.mdl",
	"models/player/magnusson.mdl",
	"models/player/soldier_stripped.mdl",
	"models/player/zombie_classic.mdl",
	"models/player/zombie_fast.mdl",
	"models/player/Group01/female_01.mdl",
	"models/player/Group01/female_02.mdl",
	"models/player/Group01/female_03.mdl",
	"models/player/Group01/female_04.mdl",
	"models/player/Group01/female_05.mdl",
	"models/player/Group01/female_06.mdl",
	"models/player/Group03/female_01.mdl",
	"models/player/Group03/female_02.mdl",
	"models/player/Group03/female_03.mdl",
	"models/player/Group03/female_04.mdl",
	"models/player/Group03/female_05.mdl",
	"models/player/Group03/female_06.mdl",
	"models/player/Group01/male_01.mdl",
	"models/player/Group01/male_02.mdl",
	"models/player/Group01/male_03.mdl",
	"models/player/Group01/male_04.mdl",
	"models/player/Group01/male_05.mdl",
	"models/player/Group01/male_06.mdl",
	"models/player/Group01/male_07.mdl",
	"models/player/Group01/male_08.mdl",
	"models/player/Group01/male_09.mdl",
	"models/player/Group03/male_01.mdl",
	"models/player/Group03/male_02.mdl",
	"models/player/Group03/male_01.mdl",
	"models/player/Group03/male_03.mdl",
	"models/player/Group03/male_04.mdl",
	"models/player/Group03/male_05.mdl",
	"models/player/Group03/male_06.mdl",
	"models/player/Group03/male_07.mdl",
	"models/player/Group03/male_08.mdl",
	"models/player/Group03/male_09.mdl",
	"models/player/Group03m/male_01.mdl",
	"models/player/Group03m/male_02.mdl",
	"models/player/Group03m/male_03.mdl",
	"models/player/Group03m/male_03.mdl",
	"models/player/Group03m/male_04.mdl",
	"models/player/Group03m/male_05.mdl",
	"models/player/Group03m/male_06.mdl",
	"models/player/Group03m/male_07.mdl",
	"models/player/Group03m/male_08.mdl",
	"models/player/Group03m/male_09.mdl",
	"models/player/Group03m/female_01.mdl",
	"models/player/Group03m/female_02.mdl",
	"models/player/Group03m/female_03.mdl",
	"models/player/Group03m/female_04.mdl",
	"models/player/Group03m/female_05.mdl",
	"models/player/Group03m/female_06.mdl",
	"models/player/Group02/male_02.mdl",
	"models/player/Group02/male_04.mdl",
	"models/player/Group02/male_06.mdl",
	"models/player/Group02/male_08.mdl",
	"models/player/skeleton.mdl",
	"models/player/zombie_soldier.mdl",
	"models/player/hostage/hostage_01.mdl",
	"models/player/hostage/hostage_02.mdl",
	"models/player/hostage/hostage_03.mdl",
	"models/player/hostage/hostage_04.mdl",
	"models/player/arctic.mdl",
	"models/player/gasmask.mdl",
	"models/player/guerilla.mdl",
	"models/player/leet.mdl",
	"models/player/phoenix.mdl",
	"models/player/riot.mdl",
	"models/player/swat.mdl",
	"models/player/urban.mdl",
	"models/player/dod_american.mdl",
	"models/player/dod_german.mdl"
}

Minigames.HelpCommands = {
	["/afk"] = "Toggle spectator.",
	["/help"] = "Re-open this menu.",
	["/teams"] = "Change your team.",
	["/rtv"] = "Vote to change map.",
}

-- NEWLY ADDED IN MAY/JUNE 2016 UPDATE - FROM HERE 
Minigames.AdminGroups = {
	"superadmin",
	"admin"
}

Minigames.FallbackMap = "mg_sweeper" -- If the current map file does not exist on the server, what should we change to? 

-- NEWLY ADDED IN MAY/JUNE 2016 UPDATE - TO HERE
