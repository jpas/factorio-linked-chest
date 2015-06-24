data:extend({
	{
		type = "technology",
		name = "linked-chest",
		icon = "__linked-chest__/graphics/linked-chest/icon.png",
		effects = {
			{type = "unlock-recipe", recipe = "linked-chest"}
		},
		prerequisites = {
			"logistic-robotics",
			"alien-technology"
		},
		unit = {
			count = 150,
			ingredients = {
				{"science-pack-1", 1},
				{"science-pack-2", 1},
				{"science-pack-3", 1},
				{"alien-science-pack", 1}
			},
			time = 30
		},
		order = "c-k-d",
	}
})
