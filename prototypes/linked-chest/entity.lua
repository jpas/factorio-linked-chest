data:extend({
{
	type = "smart-container",
	name = "linked-chest",
	icon = "__linked-chest__/graphics/linked-chest/icon.png",
	flags = {"placeable-neutral", "player-creation"},
	open_sound = {
		filename = "__base__/sound/metallic-chest-open.ogg",
		volume=0.65
	},
	close_sound = {
		filename = "__base__/sound/metallic-chest-close.ogg",
		volume = 0.7
	},
	minable = {
		hardness = 0.2,
		mining_time = 0.5,
		result = "linked-chest"
	},
	max_health = 150,
	corpse = "small-remnants",
	resistances = {
		{
			type = "fire",
			percent = 70
		}
	},
	collision_box = {
		{-0.35, -0.35},
		{0.35, 0.35}
	},
	selection_box = {
		{-0.5, -0.5},
		{0.5, 0.5}
	},
	fast_replaceable_group = "container",
	inventory_size = 48,
	picture = {
		filename = "__linked-chest__/graphics/linked-chest/entity.png",
		priority = "extra-high",
		width = 62,
		height = 41,
		shift = {0.4, -0.13}
	},
	connection_point = {
		shadow = {
			red = {0.7, -0.3},
			green = {0.7, -0.3}
		},
		wire = {
			red = {0.3, -0.8},
			green = {0.3, -0.8}
		}
	}
}
})