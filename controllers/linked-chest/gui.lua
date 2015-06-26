require 'lib'

function print(text)
	game.player.print(text)
end

--  library initialization  --
gui = {}
gui.location = 'top'

--  event handlers  --

function gui.ontick(event)
    for _, player in pairs(game.players) do
        if player.opened == nil then
            gui.destroy(player)
        elseif player.opened.name == lib.entity then
            gui.create(player, player.opened)
        end
    end
end

function gui.onguiclick(event)
    player = game.players[event.playerindex]
    chest = player.opened
    element = event.element
    if element.name == 'active_checkbox' then
        lib.set_active_state(chest, gui.get_active_state(player))
    elseif element.name == 'set_network_button' then
        lib.set_network(chest, gui.get_network(player))
    end
end

--  methods  --

function gui.create(player, chest)
    chest = lib.get_chest(chest)
    element = player.gui[gui.location]

    if element.linked_chest_frame == nil then
        -- create frame
        element.add{
            type = 'frame',
            caption = 'Linked Chest',
            name = 'linked_chest_frame',
            direction = 'vertical'
        }

        -- create flow
        element.linked_chest_frame.add{
            type = 'flow',
            name = 'linked_chest_flow',
            direction = 'vertical'
        }

        -- redefine element for cleaner code
        element = element.linked_chest_frame.linked_chest_flow

        -- create position label
        element.add{
            type = 'label',
            name = 'position',
            caption = 'Position ' .. chest.key
        }

        -- create active checkbox
        element.add{
            type = 'checkbox',
            name = 'active_checkbox',
            caption = 'Active',
            state = chest.active
        }

        -- create table for network
        element.add{
            type = 'table',
            name = 'network_table',
            colspan = 2
        }

        -- create network label
        element.network_table.add{
            type = 'label',
            name = 'network_label',
            caption = 'Network'
        }

        -- create text field for network
        element.network_table.add{
            type = 'textfield',
            name = 'network_name'
        }
        -- set text field to current network
        element.network_table.network_name.text = chest.network

        -- create button for setting network
        element.add{
            type = 'button',
            name = 'set_network_button',
            caption = 'Set Network'
        }

        -- create debug tick button
		if glob.debug == true then
        	element.add{
            	type = 'button',
            	name = 'debug_tick_button',
            	caption = 'DEBUG: Tick Networks'
        	}
		end
    end
end

function gui.destroy(player)
    element = player.gui[gui.location].linked_chest_frame
    if element ~= nil then
        element.destroy()
    end
end

--  getters  --

function gui.get_network(player)
    element = player.gui[gui.location].linked_chest_frame.linked_chest_flow
    return element.network_table.network_name.text
end

function gui.get_active_state(player)
    element = player.gui[gui.location].linked_chest_frame.linked_chest_flow
    return element.active_checkbox.state
end

--  export library  --

return gui
