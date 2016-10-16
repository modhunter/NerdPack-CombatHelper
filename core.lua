local n_name, CH = ...

CH.Version = 1.2

local config = {
	key = 'NeP_CombatHelper',
	title = n_name,
	subtitle = 'Settings',
	width = 250,
	height = 200,
	config = {
		{ type = 'header', text = 'Basic:', size = 25, align = 'Center' },
			{ type = 'checkbox', text = 'Auto Targets', key = 'Targets', default = true },

		{ type = 'spacer' },{ type = 'rule' },
		{ type = 'header', text = '|cfffd1c15Advanced|r Only:', size = 25, align = 'Center' },
			{ type = 'checkbox', text = 'Automated Facing', key = 'Facing', default = false },
			{ type = 'checkbox', text = 'Automated Movements', key = 'Movements', default = false },
	}
}

local GUI = NeP.Interface:BuildGUI(config)
NeP.Interface:Add('Combat Helper V:'..CH.Version, function() GUI:Show() end)
GUI:Hide()

local function manualMoving()
	local a = GetKeyState('65')
	local s = GetKeyState('83')
	local d = GetKeyState('68')
	local w = GetKeyState('87')
	if a or s or d or w then
		return true
	end
end

-- Ticker
C_Timer.NewTicker(0.1, (function()
	if UnitAffectingCombat('player') and NeP.DSL:Get('toggle')(nil, 'mastertoggle') then
		-- Targets
		if NeP.Interface:Fetch('NeP_CombatHelper', 'Targets', true) then
			CH:Target()
		end
		if IsHackEnabled and UnitExists('target') and not UnitChannelInfo('player') then
			if not manualMoving() then
				-- Facing
				if NeP.Interface:Fetch('NeP_CombatHelper', 'Facing', false) then
					CH:Face()
				end
				-- Movements
				if NeP.Interface:Fetch('NeP_CombatHelper', 'Movements', false) then
					CH:Move()
				end
			end
		end
	end
end), nil)