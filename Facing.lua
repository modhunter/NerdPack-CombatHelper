local _, CH = ...

function CH:Face()
	local unitSpeed = GetUnitSpeed('player')
	if unitSpeed == 0 and not NeP.Protected:Infront('player', 'target') then
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