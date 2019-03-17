local alpha = 0
local starttime, duration;
local on = false
 
hook.Add("HUDPaint", "Blind", function()
	if on then
		alpha = alpha + 255*FrameTime()/3
		if alpha >= 255 then
				alpha = 255
		end
		surface.SetDrawColor(0, 0, 0, alpha)
		surface.DrawRect(0, 0, ScrW(), ScrH())
		if starttime + duration <= CurTime() then
			on = false
		end
	else
		if alpha > 0 then
			alpha = alpha - 255*FrameTime()/2
			if alpha <= 0 then
				alpha = 0
			end
			surface.SetDrawColor(0, 0, 0, alpha)
			surface.DrawRect(0, 0, ScrW(), ScrH())
		end
	end
end)
 
usermessage.Hook("BlindPlayer", function(um)
	on = true
	starttime = CurTime()
	duration = um:ReadShort()
end)

usermessage.Hook("rtd_cmsg", function(um)
	local text = um:ReadString()
	chat.AddText(Color(255, 255, 0, 255), "[RTD]", Color(255, 255, 255, 255), text)
end)