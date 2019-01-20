AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/enzofr60/gtav/enzofr60_gtav_casquemotocross/enzofr60_gtav_casquemotocross.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType( SIMPLE_USE )
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end
end

function ENT:Use(activator, caller)
	if IsValid(caller) and caller:IsPlayer() then
		if (!self.nextUse or CurTime() >= self.nextUse) then
			if caller:GetNWBool("enzofr60_equiper_gtav_casquemotocrosscasque") == false then
				net.Start( "enzofr60:gtav_casquemotocrosscasque:DermaMenu" )
				net.WriteEntity(self)
				net.Send(caller)
			end
		self.nextUse = CurTime() + 1;
		end
	end
end