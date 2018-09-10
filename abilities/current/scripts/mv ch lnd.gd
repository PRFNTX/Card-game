extends Node

export(int, "Empty", "Land", "Lake", "Tree", "Hill", "Sand", "All") var from_type = 6
export(int, "Empty", "Land", "Lake", "Tree", "Hill", "Sand") var to_type = 0
export(int, "Any") var player = 0

var conv_land = [
	0,2,3,4,5,6
]

func activate(Game, entity, target):
	hex = Game.get_hex_by_id(target)
	hex.setState({"hex_type": conv_land[to_type]})


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
