local Core = NeP.Core

function NeP.CombatHelper.Face()
	local unitSpeed = GetUnitSpeed('player')
	if unitSpeed == 0 then 
		if not NeP.Engine.Infront('player', 'target') then
			local ax, ay, az = ObjectPosition('player')
			local bx, by, bz = ObjectPosition('target')
			local angle = rad(atan2(by - ay, bx - ax))
			if angle < 0 then
				FaceDirection(rad(atan2(by - ay, bx - ax) + 360))
			else
				FaceDirection(angle)
			end
		end
	end
end