extends Node

export(int) var reduction = 1


export(String) var ab_name = ""
export(String) var ab_description = ""

var Game
var entity
func init(_entity):
	entity=_entity
	Game=entity.Game

func activate(Game,entity,damage):
	if entity.Owner == 0:
		Game.get_hex_by_id(1).get_unit().life_change(-1*damage)
	elif entity.Owner == 1:
		Game.get_hex_by_id(44).get_unit().life_change(-1*damage)
	return 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
