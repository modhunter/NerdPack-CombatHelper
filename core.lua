NeP.CombatHelper = {}

local Interface = NeP.Interface
local CombatHelper = NeP.CombatHelper
local Fetch = NeP.Interface.fetchKey

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
Interface.CreatePlugin('Combat Helper', function() Interface.ShowGUI('NePCombatHelper') end)

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
C_Timer.NewTicker(1, (function()
	if NeP.Config.Read('bStates_MasterToggle', false)
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