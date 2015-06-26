require 'util'
require 'defines'

function print(text)
	game.player.print(text)
end

require 'lib'
require 'gui'

game.oninit(function()
	lib.oninit()
end)

game.onevent({
	defines.events.onbuiltentity,
	defines.events.onrobotbuiltentity
}, function(event)
	entity = event.createdentity
	if entity.name == lib.entity then
		lib.add(entity)
	end
end)

game.onevent({
	defines.events.onentitydied,
	defines.events.onpreplayermineditem,
	defines.events.onrobotpremined
}, function(event)
	entity = event.entity
	if event.entity.name == lib.entity then
		lib.remove(entity)
	end
end)

game.onevent(defines.events.ontick, function(event)
	gui.ontick(event)
	lib.ontick(event)
end)

game.onevent(defines.events.onguiclick, function(event)
	gui.onguiclick(event)
	lib.onguiclick(event)
end)

game.onevent(defines.events.onmarkedfordeconstruction, function(event)
	lib.onmarkedfordeconstruction(event)
end)

game.onevent(defines.events.oncanceleddeconstruction, function(event)
	lib.oncanceleddeconstruction(event)
end)
