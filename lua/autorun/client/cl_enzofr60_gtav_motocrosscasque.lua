surface.CreateFont( "enzoFR60:gtav_casquemotocrosscasque:TimerBar:Font", {
	font = "Arial Black",
	size = ScrH()*0.04,
	weight = 800,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

local blur = Material("pp/blurscreen")
local function DrawBlur( p, a, d )
	local x, y = p:LocalToScreen( 0, 0 )
	
	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( blur )
	
	for i = 1, d do
		blur:SetFloat( "$blur", (i / d ) * ( a ) )
		blur:Recompute()
		
		render.UpdateScreenEffectTexture()
		
		surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
	end
end


net.Receive("enzofr60:gtav_casquemotocrosscasque:DermaMenu", function()
	local ply, ent, scrw, scrh = LocalPlayer(), net.ReadEntity(), ScrW(), ScrH()
	
	if not IsValid(ply) then return end

	local enzofr60_gtav_casquemotocrosscasque_panel = vgui.Create( "DFrame" )
	enzofr60_gtav_casquemotocrosscasque_panel:SetSize( scrw*0.45, scrh*0.5 )
	enzofr60_gtav_casquemotocrosscasque_panel:Center()
	enzofr60_gtav_casquemotocrosscasque_panel:SetTitle( "" )
	enzofr60_gtav_casquemotocrosscasque_panel:SetDraggable( false )
	enzofr60_gtav_casquemotocrosscasque_panel:ShowCloseButton( false )
	enzofr60_gtav_casquemotocrosscasque_panel:MakePopup()
	enzofr60_gtav_casquemotocrosscasque_panel.Paint = function( self, w, h )
		DrawBlur( self, 3, 16 )
		draw.RoundedBox( 0, 0, 0, w, h, Color(0,0,0,120) )
		draw.RoundedBox( 0, 0, 0, w, scrh*0.05, Color(255,255,255,70) )

		draw.SimpleText(ent.PrintName, "enzoFR60:gtav_casquemotocrosscasque:TimerBar:Font", w/2, scrh*0.025, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local close = vgui.Create( "DButton", enzofr60_gtav_casquemotocrosscasque_panel )
	close:SetSize( ScrW() * 0.04, ScrH() * 0.04 )
	close:SetPos( ScrW() * 0.42, ScrH() * -0.008 )
	close:SetText( "X" )
	close:SetFont("enzoFR60:gtav_casquemotocrosscasque:TimerBar:Font")
	close:SetTextColor(  Color( 255, 255, 255, 255 ) )
	close.Paint = function( self, w, h )
	end
	close.DoClick = function(self, w, h)
		enzofr60_gtav_casquemotocrosscasque_panel:Remove()
	end

	local icon = vgui.Create( "DModelPanel", enzofr60_gtav_casquemotocrosscasque_panel )
	icon:SetSize( ScrW() * 0.3, ScrH() * 0.3 )
	icon:SetPos( ScrW() * 0.09, ScrH() * 0.07  )
	icon:SetEntity( ent )
	icon:SetModel("models/enzofr60/gtav/enzofr60_gtav_casquemotocross/enzofr60_gtav_casquemotocross.mdl")

	icon:SetCamPos( Vector( -50, -2, 0 ) )

	function icon:LayoutEntity( ent )

		self:SetLookAng( Angle(0,0,0) )

		ent:SetAngles( Angle( 0, RealTime()*30,	0 ) )

		surface.SetDrawColor( Color(255,255,255) )
		surface.DrawOutlinedRect( 0, 0, icon:GetWide(), icon:GetTall() )

	end

	local DComboBox = vgui.Create( "DComboBox", enzofr60_gtav_casquemotocrosscasque_panel )
	DComboBox:SetSize( ScrW() * 0.3, ScrH() * 0.025 )
	DComboBox:SetPos( ScrW() * 0.09, ScrH() * 0.4 )
	DComboBox:SetValue( "Skins" )
	for i = 0, 7 do
		DComboBox:AddChoice( i )
	end
	DComboBox.OnSelect = function( self, index, value )
		icon:GetEntity():SetSkin(value)
	end

	local Equiper = vgui.Create("DButton", enzofr60_gtav_casquemotocrosscasque_panel)
	Equiper:SetSize(ScrW() * 0.4, ScrH() * 0.04)
	Equiper:SetPos(ScrW() * 0.03, ScrH() * 0.45)
	Equiper:SetText( "Equiper" )
	Equiper:SetFont("enzoFR60:gtav_casquemotocrosscasque:TimerBar:Font")
	Equiper:SetTextColor(  Color( 255, 255, 255, 255 ) )
	Equiper.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(0,0,0, 120) )
		surface.SetDrawColor( Color(255,255,255) )
		surface.DrawOutlinedRect( 0, h-1, self:GetWide(), 1 )
	end
	Equiper.DoClick = function(self, w, h)
		if DComboBox:GetValue() == "Skins" then
			DComboBox:SetValue( 0 )
		end
		net.Start( "enzofr60:gtav_casquemotocrosscasque:Equip" )
		net.WriteEntity(ent)
		net.WriteInt(DComboBox:GetValue(),32)
		net.SendToServer()
		enzofr60_gtav_casquemotocrosscasque_panel:Remove()
	end
end)


net.Receive("enzofr60:gtav_casquemotocrosscasque:TimerBar", function()
	local CurTimeDelete = CurTime()
	
	hook.Add("HUDPaint", "HUDPaint:enzoFR60:gtav_casquemotocrosscasque:TimerBar", function()
		local scrw, scrh = ScrW(), ScrH()
		local enzofr60_casquetimer_progress = math.Remap( CurTime() - CurTimeDelete, 1, 0, 400, 0 )
		surface.SetDrawColor( Color( 30, 30, 30, 200 ) )
		surface.DrawRect( scrw*.74, scrh*.5, scrw*.25, scrh*.09 )
	  	draw.RoundedBox( 1, scrw*.74, scrh*.5, enzofr60_casquetimer_progress-49, scrh*.09, Color( 30, 30, 30, 200 ) )

	  	draw.SimpleText( "Wait ...", "enzoFR60:gtav_casquemotocrosscasque:TimerBar:Font", scrw*.865, scrh*.545, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )	
	end)

	timer.Simple(1,function()
		hook.Remove( "HUDPaint", "HUDPaint:enzoFR60:gtav_casquemotocrosscasque:TimerBar" )
		net.Start("enzofr60:gtav_casquemotocrosscasque:Drop")
		net.SendToServer()
	end )
end )

local modelcasque = ClientsideModel( "models/enzofr60/gtav/enzofr60_gtav_casquemotocross/enzofr60_gtav_casquemotocross.mdl" )
if IsValid(modelcasque) then
	modelcasque:SetNoDraw( true )
	hook.Add("PostPlayerDraw", "enzofr60_gtav_casquemotocrosscasque_PostDrawPlayer", function(ply)
			if not IsValid( ply ) or not ply:Alive() then return end
			if ply:GetNWBool("enzofr60_equiper_gtav_casquemotocrosscasque") == true then
				local attach_id = ply:LookupAttachment( "eyes" )
				if not attach_id then return end
				local attach = ply:GetAttachment( attach_id )
				if not attach then return end

				local pos = attach.Pos
				local ang = attach.Ang

				modelcasque:SetModelScale( 0.8, 0 )
				pos = pos + ( ang:Forward() * -3.75 ) + ( ang:Up() * -3 ) + ( ang:Right() * 0 )
				ang:RotateAroundAxis( ang:Up(), 0 )
				ang:RotateAroundAxis( ang:Forward(), 0 )

				modelcasque:SetPos( pos )
				modelcasque:SetAngles( ang )

				modelcasque:SetSkin(ply:GetNWInt("enzofr60_skin_gtav_casquemotocrosscasque"))

				modelcasque:SetRenderOrigin( pos )
				modelcasque:SetRenderAngles( ang )
				modelcasque:SetupBones()
				modelcasque:DrawModel()
				modelcasque:SetRenderOrigin()
				modelcasque:SetRenderAngles()
		end
	end)
end