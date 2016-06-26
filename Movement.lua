local Core = NeP.Core

local rangeTable = {
	['HUNTER'] = 'ranged',
	['WARLOCK'] = 'ranged',
	['PRIEST'] = 'ranged',
	['PALADIN'] = 'melee',
	['MAGE'] = 'ranged', 
	['ROGUE'] = 'melee',
	['DRUID'] = 'melee',
	['SHAMAN'] = 'ranged',
	['WARRIOR'] = 'melee',
	['DEATHKNIGHT'] = 'melee',
	['MONK'] = 'melee'
}

function NeP.CombatHelper.Move()
	local pClass = select(2, UnitClass('player'))
	local tRange = rangeTable[pClass]
	local Range = Core.UnitAttackRange('player', 'target', tRange)
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