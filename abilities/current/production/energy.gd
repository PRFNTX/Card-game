extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""
export(int) var to_max = 3
func activate(Game,entity,unused):
	if entity.Unit.current_energy < to_max:
		entity.Unit.add_one_energy()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

