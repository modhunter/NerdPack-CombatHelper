local _, CH = ...

local NeP_forceTarget = {
	-- WOD DUNGEONS/RAIDS
	[75966] = 100,	-- Defiled Spirit (Shadowmoon Burial Grounds)
	[76220] = 100,	-- Blazing Trickster (Auchindoun Normal)
	[76222] = 100,	-- Rallying Banner (UBRS Black Iron Grunt)
	[76267] = 100,	-- Solar Zealot (Skyreach)
	[76518] = 100,	-- Ritual of Bones (Shadowmoon Burial Grounds)
	[77252] = 100,	-- Ore Crate (BRF Oregorger)
	[77665] = 100,	-- Iron Bomber (BRF Blackhand)
	[77891] = 100,	-- Grasping Earth (BRF Kromog)
	[77893] = 100,	-- Grasping Earth (BRF Kromog)
	[86752] = 100,	-- Stone Pillars (BRF Mythic Kromog)
	[78583] = 100,	-- Dominator Turret (BRF Iron Maidens)
	[78584] = 100,	-- Dominator Turret (BRF Iron Maidens)
	[79504] = 100,	-- Ore Crate (BRF Oregorger)
	[79511] = 100,	-- Blazing Trickster (Auchindoun Heroic)
	[81638] = 100,	-- Aqueous Globule (The Everbloom)
	[86644] = 100,	-- Ore Crate (BRF Oregorger)
	[94873] = 100,	-- Felfire Flamebelcher (HFC)
	[90432] = 100,	-- Felfire Flamebelcher (HFC)
	[95586] = 100,	-- Felfire Demolisher (HFC)
	[93851] = 100,	-- Felfire Crusher (HFC)
	[90410] = 100,	-- Felfire Crusher (HFC)
	[94840] = 100,	-- Felfire Artillery (HFC)
	[90485] = 100,	-- Felfire Artillery (HFC)
	[93435] = 100,	-- Felfire Transporter (HFC)
	[93717] = 100,	-- Volatile Firebomb (HFC)
	[188293] = 100,	-- Reinforced Firebomb (HFC)
	[94865] = 100,	-- Grasping Hand (HFC)
	[93838] = 100,	-- Grasping Hand (HFC)
	[93839] = 100,	-- Dragging Hand (HFC)
	[91368] = 100,	-- Crushing Hand (HFC)
	[94455] = 100,	-- Blademaster Jubei'thos (HFC)
	[90387] = 100,	-- Shadowy Construct (HFC)
	[90508] = 100,	-- Gorebound Construct (HFC)
	[90568] = 100,	-- Gorebound Essence (HFC)
	[94996] = 100,	-- Fragment of the Crone (HFC)
	[95656] = 100,	-- Carrion Swarm (HFC)
	[91540] = 100,	-- Illusionary Outcast (HFC)
}

local function getTargetPrio(Obj)
	local objectType, _, _, _, _, _id, _ = strsplit('-', UnitGUID(Obj))
	local ID = tonumber(_id) or '0'
	local prio = 1
	-- Elite
	if NeP.DSL:Get('elite')(Obj) then
		prio = prio + 30
	end
	-- If its forced
	if NeP_forceTarget[tonumber(Obj)] ~= nil then
		prio = prio + NeP_forceTarget[tonumber(Obj)]
	end
	return prio
end

function CH:Target()
	-- If dont have a target, target is friendly or dead
	if not UnitExists('target') or UnitIsFriend('player', 'target') or UnitIsDeadOrGhost('target') then
		local setPrio = {}
		for GUID, Obj in pairs(NeP.OM:Get('Enemy')) do
			if UnitExists(Obj.key) and Obj.distance <= 40 then
				if (UnitAffectingCombat(Obj.key) or NeP.DSL:Get('isdummy')(Obj.key))
				and NeP.Protected:LineOfSight('player', Obj.key) then
					setPrio[#setPrio+1] = {
						key = Obj.key,
						bonus = getTargetPrio(Obj.key),
						name = Obj.name
					}
				end
			end
		end
		table.sort(setPrio, function(a,b) return a.bonus > b.bonus end)
		if setPrio[1] then
			NeP.Protected.Macro('/target '..setPrio[1].key)
		end
	end
end