local Mesh = {}

local function MeshFilter(bx, by ,bz)
	local pass = true
	for i=1, #Mesh do
		if pass then
			local Mesh = Mesh[i]
			local ax, ay, az = Mesh.x, Mesh.y, Mesh.z
			if math.sqrt(((bx-ax)^2) + ((by-ay)^2) + ((bz-az)^2)) < 1 then
				pass = false
			end
		else
			break
		end
	end
	return pass
end

local function Build_Mesh()
	for i=1,#NeP.OM.unitFriend do
		local Obj = NeP.OM.unitFriend[i]
		if UnitExists(Obj.key)then
			local oX, oY, oZ = ObjectPosition(Obj.key)
			if MeshFilter(oX, oY, oZ) then
				Mesh[#Mesh+1] = {x = oX, y = oY, z = oZ}
			end
		end
	end
end

local losFlags = bit.bor(0x10, 0x100)
local function LoS_Check(ax, ay, az, bx, by, bz)
	local los = TraceLine(ax, ay, az+2.25, bx, by, bz+2.25, losFlags)
	return los == nil
end

local function GetPathDistance(ax, ay, az, bx, by, bz)
	return math.sqrt(((bx-ax)^2) + ((by-ay)^2) + ((bz-az)^2))
end

local function GetPath(ax, ay, az)
	local tempTable = {}
	for i=1, #Mesh do
		local Mesh = Mesh[i]
		local bx, by, bz = Mesh.x, Mesh.y, Mesh.z
		local mx, my, mb = ObjectPosition('player')
		local distance_A = GetPathDistance(ax, ay, az, bx, by, bz)
		local distance_B = GetPathDistance(mx, my, mb, bx, by, bz)
		tempTable[#tempTable+1] = {
			x = bx,
			y = by,
			z = bz,
			distance = distance_A + distance_B,
		}
	end
	table.sort(tempTable, function(a,b) return a.distance < b.distance end)
	return tempTable
end

-- /run NeP.Core.Move(ObjectPosition('target'))

local wx, wy, wz
function NeP.Core.Move(ox, oy, oz)
	local ax, ay, az = ObjectPosition('player')
	-- if we can go straight to the location
	if LoS_Check(ax, ay, az, ox,oy,oz) then
		MoveTo(ox,oy,oz)
	-- Move the mesh
	else
		wx, wy, wz = ox, oy, oz
		start = true
	end
end

C_Timer.NewTicker(1, (function()
	if start then
		local ax, ay, az = ObjectPosition('player')
		local tempTable = GetPath(wx, wy, wz)
		for i=1, #tempTable do
			local Mesh = Mesh[i] 
			local bx, by, bz = Mesh.x, Mesh.y, Mesh.z
			local distance = GetPathDistance(ax, ay, az, bx, by, bz)
			if distance > 1 then
				if LoS_Check(ax, ay, az, bx, by, bz) then
					MoveTo(bx, by, bz)
					break
				end
			elseif distance < 5 then
				start = false
				print('reached')
			end
		end
	end
end), nil)

C_Timer.NewTicker(1, (function()
	Build_Mesh()
end), nil)