extends Node

export(int) var max_life = 5
export(int) var life_gain =1
export(int) var attack_gain = 1


func activate(Game,entity,unused):
	if entity.Unit.current_health <5:
		entity.Unit.current_health +=1
		entity.Unit.current_attack +=1

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

