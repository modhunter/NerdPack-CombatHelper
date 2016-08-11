function NeP.CombatHelper.Move()
	local classIndex = select(3, UnitClass('player'))
	local specIndex = GetSpecializationInfo(GetSpecialization())
	local tRange = NeP.Core.ClassTable[classIndex][specIndex].range
	local Range = NeP.Engine.UnitAttackRange('player', 'target', tRange)
	local unitSpeed = GetUnitSpeed('player')
	-- Stop Moving
	if Range > NeP.Engine.Distance('player', 'target') and unitSpeed ~= 0 then 
		local pX, pY, pZ = ObjectPosition('player')
		MoveTo(pX, pY, pZ)
	-- Start Moving
	elseif Range < NeP.Engine.Distance('player', 'target') then
		local oX, oY, oZ = ObjectPosition('target')
		MoveTo(oX, oY, oZ)
	end
end