NeP.CombatHelper = {
	Version = 1.0
}

local Interface = NeP.Interface
local CombatHelper = NeP.CombatHelper
local Fetch = NeP.Interface.fetchKey

-- Core version check
if NeP.Info.Version >= 70.2 then
	NeP.Core.Print('Loaded Combat Helper Module v:'..NeP.CombatHelper.Version)
else
	NeP.Core.Print('Failed to Combat Helper Module.\nYour Core is outdated.')
	return
end

local config = {
	key = 'NePCombatHelper',
	profiles = true,
	title = '|T'..Interface.Logo..':10:10|t'..' '..NeP.Info.Name,
	subtitle = 'Combat Helper Settings',
	color = Interface.addonColor,
	width = 250,
	height = 200,
	config = {
		{ type = 'header', text = 'Basic:', size = 25, align = 'Center' },
			{ type = 'checkbox', text = 'Auto Targets', key = 'Targets', default = true },

		{ type = 'spacer' },{ type = 'rule' },
		{ type = 'header', text = '|cfffd1c15FireHack|r Only:', size = 25, align = 'Center' },
			{ type = 'checkbox', text = 'Automated Facing', key = 'Facing', default = false },
			{ type = 'checkbox', text = 'Automated Movements', key = 'Movements', default = false },
	}
}

Interface.buildGUI(config)
Interface.CreatePlugin('Combat Helper'..NeP.CombatHelper.Version, function() Interface.ShowGUI('NePCombatHelper') end)

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
C_Timer.NewTicker(0.25, (function()
	if NeP.DSL.get('toggle')('mastertoggle')
	and UnitAffectingCombat('player') then
		-- Targets
		if Fetch('NePCombatHelper', 'Targets', true) then
			CombatHelper.Target()
		end
		if FireHack and UnitExists('target') and not UnitChannelInfo('player') then
			if not manualMoving() then
				-- Facing
				if Fetch('NePCombatHelper', 'Facing', false) then
					CombatHelper.Face()
				end
				-- Movements
				if Fetch('NePCombatHelper', 'Movements', false) then
					CombatHelper.Move()
				end
			end
		end
	end
end), nil)
