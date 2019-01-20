util.AddNetworkString( "enzofr60:gtav_casquemotocrosscasque:TimerBar" )
util.AddNetworkString( "enzofr60:gtav_casquemotocrosscasque:Equip" )
util.AddNetworkString( "enzofr60:gtav_casquemotocrosscasque:Drop" )
util.AddNetworkString( "enzofr60:gtav_casquemotocrosscasque:DermaMenu" )

hook.Add('PlayerDeath', 'enzofr60_gtav_casquemotocrosscasque_deadhook', function(victim, weapon, killer)
	if IsValid(victim) then
		if victim:GetNWBool("enzofr60_equiper_gtav_casquemotocrosscasque") == true then
			victim:SetNWBool("enzofr60_equiper_gtav_casquemotocrosscasque", false)
		end
	end
end)

hook.Add("PlayerButtonDown", "enzoFR60_equip_gtav_casquemotocrosscasque_KeyDown", function(ply, btn)
	if not IsValid(ply) then return end
	if btn == KEY_B then
		if ply:GetNWBool("enzofr60_equiper_gtav_casquemotocrosscasque") == false then return end
		net.Start( "enzofr60:gtav_casquemotocrosscasque:TimerBar" )
		net.Send( ply )
		ply:SetNWBool("enzofr60_equiper_gtav_casquemotocrosscasque", false)
	end
end)

net.Receive("enzofr60:gtav_casquemotocrosscasque:Drop", function(len, ply)
	if not IsValid(ply) then return end
	local helmet = ents.Create( "enzofr60_gtav_motocrosscasque" )
	if ( !IsValid( helmet ) ) then return end
	helmet:SetPos( ply:LocalToWorld(Vector(30, 0, 10)) )
	helmet:Spawn()
end)

net.Receive("enzofr60:gtav_casquemotocrosscasque:Equip", function(len, ply)
	if not IsValid(ply) then return end
	local ent, skins = net.ReadEntity(), net.ReadInt(32)
	if not IsValid(ent) then return end
	if ply:GetNWBool("enzofr60_equiper_casque") == true or ply:GetNWBool("enzofr60_equiper_gtav_casquemotocrosscasque") == true then return end

	ply:SetNWBool("enzofr60_equiper_gtav_casquemotocrosscasque", true)
	ply:SetNWInt("enzofr60_skin_gtav_casquemotocrosscasque", skins)
    ent:Remove()
end)