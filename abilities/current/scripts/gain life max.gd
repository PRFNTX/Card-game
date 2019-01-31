extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(int) var max_life = 5
export(int) var life_gain =1
export(int) var attack_gain = 1


func activate(Game,entity,unused):
	if entity.Unit.is_unit:
		if entity.Unit.current_health < max_life:
			entity.Unit.current_health = entity.Unit.current_health+life_gain
			entity.Unit.current_attack =entity.Unit.current_attack +attack_gain
	else:
		if entity.Unit.current_val < max_life:
			entity.Unit.current_val = entity.Unit.current_val+life_gain

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

