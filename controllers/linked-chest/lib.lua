require 'util'
require 'defines'

--  utility functions  --

function length(table, check)
	if type(table) ~= 'table' then
		return nil
	end

	count = 0
	for key, value in pairs(table) do
		if check == nil or check(key, value) then
			count = count + 1
		end
	end

	return count
end

function key(entity)
	if entity.position == nil then
		return nil
	end

	return util.positiontostr(entity.position)
end

--  library initialization  --

lib = {}
lib.entity = 'linked-chest'

--  event handlers  --

function lib.oninit()
	if glob.chests == nil then
		glob.chests = {}
	end

	if glob.networks == nil then
		glob.networks = {}
	end
end

function lib.ontick(event)
	networks = lib.get_networks({inventory = true})
	for network_name, network in pairs(networks) do
		if network_name ~= 'none' then
			contents = lib.get_contents(network)
			lib.destribute(contents, network, true)
		end
	end
end

function lib.onmarkedfordeconstruction(event)
	chest = lib.get_chest(event.entity)
	lib.set_active_state(chest, false)
end

function lib.oncanceleddeconstruction(event)
	chest = lib.get_chest(event.entity)
	lib.set_active_state(chest, true)
end

--  methods  --

function lib.add(chest, network, active)
	if network == nil then
		network = 'none'
	end

	if active == nil then
		active = false
	end

	if glob.networks[network] == nil then
		glob.networks[network] = {}
	end

	chest = {
		network = network,
		position = chest.position,
		key = key(chest),
		active = active
	}

	glob.networks[network][chest.key] = true
	glob.chests[chest.key] = chest
end

function lib.remove(chest)
	chest = glob.chests[key(chest)]
	glob.networks[chest.network][chest.key] = nil
	if length(glob.networks[chest.network]) == 0 then
		glob.networks[chest.network] = nil
	end
	glob.chests[chest.key] = nil
end

function lib.destribute(contents, network, isfirst, caninsert)
	if type(caninsert) ~= 'table' then
		caninsert = {}
		for _, chest in pairs(network) do
			caninsert[chest.key] = true
		end
	end

	for name, count in pairs(contents) do
		if type(count) == 'number' then
			contents[name] = {
				network = count,
				chest = math.ceil(count/length(caninsert))
			}
		else
			contents[name].chest = math.ceil(count.network/length(caninsert))
		end
	end

	for key, chest in pairs(network) do
		if chest.active then
			if isfirst then
				chest.inventory.clear()
			end

			for name, count in pairs(contents) do
				item = {
					name = name,
					count = 0
				}

				if count.network < count.chest then
					item.count = count.network
				else
					item.count = count.chest
				end


				if chest.inventory.caninsert(item) then
					chest.inventory.insert(item)
					contents[name].network = contents[name].network - item.count
					if contents[name].network <= 0 then
						contents[name] = nil
					end
				else
					caninsert[chest.key] = nil
				end
			end
		end
	end

	if length(contents) > 0 then
		lib.destribute(contents, network, false, caninsert)
	end
end

--  get_ters  --

function lib.get_chest(entity, options)
	if options == nil then options = {} end

	if type(entity) == 'string' then
		position = glob.chests[entity].position
		entity = game.findentity(lib.entity, position)
	end

	chest = glob.chests[key(entity)]
	chest.entity = entity

	if options.inventory == true then
		chest.inventory = chest.entity.getinventory(defines.inventory.chest)
	end

	return chest
end

function lib.get_chests(options)
	chests = {}

	for key,_ in pairs(glob.chests) do
		chests[key] = lib.get_chest(key, options)
	end

	return chests
end

function lib.get_network(network_name, options)
	network = {}

	for key, _ in pairs(glob.networks[network_name]) do
		network[key] = lib.get_chest(key, options)
	end

	return network
end

function lib.get_networks(options)
	networks = {}

	for network_name, _ in pairs(glob.networks) do
		networks[network_name] = lib.get_network(network_name, options)
	end

	return networks
end

function lib.get_contents(network)
	contents = {}
	for key, chest in pairs(network) do
		if chest.active then
			for name, count in pairs(chest.inventory.getcontents()) do
				if contents[name] == nil then
					contents[name] = count
				else
					contents[name] = contents[name] + count
				end
			end
		end
	end
	return contents
end

--  setters  --

function lib.set_active_state(chest, active)
	glob.chests[key(chest)].active = active
end

function lib.set_network(chest, network)
	chest = lib.get_chest(chest)
	lib.remove(chest.entity)
	lib.add(chest.entity, network, chest.active)
end

--  export library  --

return lib
