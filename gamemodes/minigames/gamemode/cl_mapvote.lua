net.Receive("Minigames_MapVote", function()
	chat.AddText(Color(242,99,91), "[MINIGAMES] ", Color(255,255,255), "Nous avons atteint la limite des rounds! Lancement du vote...")
	
	timer.Simple(0.1, function()
		Minigames:Mapvote()
	end)
end)

net.Receive("Minigames_MapVote_SbtC", function()
	local voter_tbl = net.ReadTable()
	
	Minigames.Gamemodes[voter_tbl[1]] = Minigames.Gamemodes[voter_tbl[1]] + 1
	
	if voter_tbl[2] then
		Minigames.Gamemodes[voter_tbl[2]] = Minigames.Gamemodes[voter_tbl[2]] - 1
	end
end)

net.Receive("Minigames_MapChoice", function()
	
	Minigames:CloseMapvote()

	local winner = net.ReadString()
	local maps = net.ReadTable()
	
	local framesize = 128*5+60
	local frameheight = 35+10+128+10+35+10+128+35+20
	
	local key = Minigames:DefineVoteInfo(winner)
		
	local frame = vgui.Create("DFrame")
	frame:SetSize(framesize, frameheight)
	frame:Center()
	frame:ShowCloseButton(false)
	frame:SetTitle("")
	frame.Paint = function()
		draw.RoundedBox(0,0,0,frame:GetWide(),frame:GetTall(),Color(49,49,49,150))
		draw.DrawText(winner .. " wins!", "NexaLight40", frame:GetWide()/2, 5, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
	end
	frame.Think = function()
		gui.EnableScreenClicker(true)
	end
	
	local num = 0
	for k, v in pairs(maps) do
		
		local mapicon = vgui.Create("DImage", frame)
		mapicon:SetSize(128,128)
		mapicon:SetPos(10+num*138, 35+10)
		local check = file.Exists("materials/niandralades/minigames/mapicons/" .. v ..".png", "GAME")
		if check then
			mapicon:SetImage("materials/niandralades/minigames/mapicons/" .. v ..".png")
		else
			mapicon:SetImage("materials/niandralades/minigames/missing_map.png")
		end
	
		local mapbutton = vgui.Create("DButton",frame)
		mapbutton:SetText(table.KeyFromValue(key, v))
		mapbutton:SizeToContents()
		mapbutton:SetSize(128,35)
		mapbutton:SetColor(Color(255,255,255))
		mapbutton.Paint = function()
			draw.RoundedBox(0,0,0,mapbutton:GetWide(),mapbutton:GetTall(),Color(29, 33, 38))
			draw.RoundedBox(0,2,2,mapbutton:GetWide()-4,mapbutton:GetTall()-4,Color(47, 53, 61))
		end
		mapbutton:SetPos(10+num*138, 35+20+128)
		mapbutton.DoClick = function()
			net.Start("Minigames_SendMap")
				net.WriteString(v)
			net.SendToServer()
		end
		
		
		if num > 5 then
			continue
		else
			maps[k] = nil
		end
		num = num + 1
	end
		
	local num = 0 
	for k, v in pairs(maps) do
		
		if #maps < 1 then return end
	
		local mapicon = vgui.Create("DImage", frame)
		mapicon:SetSize(128,128)
		mapicon:SetPos(10+num*138, 35+10+128+45+10)
		local check = file.Exists("materials/niandralades/minigames/mapicons/" .. v ..".png", "GAME")
		if check then
			mapicon:SetImage("materials/niandralades/minigames/mapicons/" .. v ..".png")
		else
			mapicon:SetImage("materials/niandralades/minigames/missing_map.png")
		end
	
		local mapbutton = vgui.Create("DButton",frame)
		mapbutton:SetText(table.KeyFromValue(key, v))
		mapbutton:SizeToContents()
		mapbutton:SetColor(Color(255,255,255))
		mapbutton:SetSize(128,35)
		mapbutton.Paint = function()
			draw.RoundedBox(0,0,0,mapbutton:GetWide(),mapbutton:GetTall(),Color(29, 33, 38))
			draw.RoundedBox(0,2,2,mapbutton:GetWide()-4,mapbutton:GetTall()-4,Color(47, 53, 61))
		end
		mapbutton:SetPos(10+num*138, 35+10+mapicon:GetTall()+mapbutton:GetTall()+10+mapicon:GetTall()+20)
		mapbutton.DoClick = function()
			net.Start("Minigames_SendMap")
				net.WriteString(v)
				net.WriteBool(true)
			net.SendToServer()
		end
		num = num + 1
	end
end)	

function Minigames:Mapvote()
	Minigames.MapvoteOpen = true
	if LocalPlayer():Alive() then
		Minigames:ToggleAvatar(false)
	end
	
	local vote_size = 6

	local frame = vgui.Create("DFrame")
	frame:SetSize(600, 90+vote_size*50+10*vote_size)
	frame:Center()
	frame:ShowCloseButton(false)
	frame:SetTitle("")
	frame.Paint = function()
		draw.RoundedBox(0,0,0,frame:GetWide(),frame:GetTall(),Color(49,49,49,150))
		draw.DrawText("What should we play next?", "NexaLight40", frame:GetWide()/2, 8, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
		draw.DrawText("Click a gamemode below to vote for it.", "NexaLight25", frame:GetWide()/2, 40, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
	end
	frame.Think = function()
		gui.EnableScreenClicker(true)
	end
	
	local scroll = vgui.Create("DScrollPanel", frame)
	scroll:SetSize(frame:GetWide()-20,frame:GetTall()-100)
	scroll:SetPos(10,90)
	
	local pos = scroll:GetWide()-10
	if Minigames.DLC then
		pos = scroll:GetWide()-20
	end

	local num = 0
	for k, v in pairs(Minigames.Gamemodes) do
	
		if k == Minigames:ReturnGamemodeString() then
			continue
		end
	
		gamemode_button = vgui.Create("DButton", scroll)
		gamemode_button:SetText("")
		gamemode_button:SetSize(scroll:GetWide(), 50)
		gamemode_button:SetPos(0, 0+num*60)
		gamemode_button.DoClick = function()
			net.Start("Minigames_MapVote_CtS")
				net.WriteString(k)
			net.SendToServer()
		end
		gamemode_button.Paint = function()
			if IsValid(gamemode_button) then
				draw.RoundedBox(0,0,0,gamemode_button:GetWide(),gamemode_button:GetTall(),Color(29, 33, 38))
				draw.RoundedBox(0,2,2,gamemode_button:GetWide()-4,gamemode_button:GetTall()-4,Color(47, 53, 61))
				draw.DrawText(k, "NexaLight40", 10, 8, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)
				
				draw.DrawText(Minigames.Gamemodes[k], "NexaLight40", pos, 8, Color(255, 255, 255, 255),TEXT_ALIGN_RIGHT)
			end
		end
		num = num + 1
	end
	
	function Minigames:CloseMapvote()
		if frame then
			frame:Remove()
		end
	end
end


Minigames.NotifsOnScreen = 0
net.Receive("MG_VOTENotif", function()
	local user = net.ReadEntity()
	local vote = net.ReadString()
	local previous_vote = net.ReadString()
	
	if #previous_vote > 0 and vote ~= previous_vote then
		Minigames:VoteNotification(user,previous_vote,false)
	end
	
	if vote ~= previous_vote then
		Minigames:VoteNotification(user,vote,true)
	end

end)

function Minigames:VoteNotification(user,vote,bool)

	local sign = ""
	if bool then
		sign = "+"
	else
		sign = "-"
	end
	
	local size = string.len(vote)
	if size >= 17 then
		local calc = size-15
		local right = string.Right(vote,calc)
		local outcome = string.Replace(vote, right, "...")
		vote = outcome
	end
	
	local frame = vgui.Create("DFrame")
	frame:SetSize(250, 42)
	frame:SetTitle("")
	frame:ShowCloseButton(false)
	frame:SetPos(ScrW()+250, ScrH()-150-Minigames.NotifsOnScreen*50)
	frame.Paint = function()
		draw.RoundedBox(0,0,0,frame:GetWide(),frame:GetTall(),Color(29, 33, 38))
		draw.RoundedBox(0,2,2,frame:GetWide()-4,frame:GetTall()-4,Color(47, 53, 61))
	end
	
	frame:MoveTo(ScrW()-250, ScrH()-150-Minigames.NotifsOnScreen*50,0.4,0,2,nil)
	
	timer.Simple(3, function()
		frame:MoveTo(ScrW()+250, frame.y,0.4,0,2,function()
			Minigames.NotifsOnScreen = Minigames.NotifsOnScreen - 1
			frame:Remove()
		end)
	end)
	
	local avatar = vgui.Create("AvatarImage", frame)
	avatar:SetPos(frame:GetWide()-5-32, 5)
	avatar:SetSize(32,32)
	avatar:SetPlayer(user, 32)
	
	local text = vgui.Create("DLabel", frame)
	text:SetText(sign .. "1 " .. vote)
	text:SetFont("NexaLight20")
	text:SizeToContents()
	text:SetPos(5,10)
	
	Minigames.NotifsOnScreen = Minigames.NotifsOnScreen + 1
end
