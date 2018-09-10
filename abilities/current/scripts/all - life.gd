extends Node

export(int) var life = -1
export(int, "All", "Owner", "Enemy") var target_player = 0


func activate(Game,entity,unused):
	for hex in get_tree().get_nodes_in_group("entities"):
		if target_player==0 and hex.has_unit():
			hex.get_unit().life_change(life)
		elif target_player==1 and hex.has_friendly_unit(entity.Owner):
			hex.get_unit().life_change(life)
		elif target_player==2 and hex.has_opposing_unit(entity.Owner):
			hex.get_unit().life_change(life)
		

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
