extends Node

export(int,'None','Aquatic','Flying') var method = 0

var entity
var Game
func init(_entity):
	entity=_entity
	Game=_entity.Game

func start_action(entity):
	if method == 0:
		entity.Game.start_unit_action('moveBase')
	elif method == 1:
		entity.Game.start_unit_action('moveWater')
	elif method == 2:
		entity.Game.start_unit_action('moveAir')

func get_action_type():
	if method == 0:
		return('moveBase')
	elif method == 1:
		return('moveWater')
	elif method == 2:
		return('moveAir')

func verify_costs():
	return entity.get_energy()>=1
	

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
