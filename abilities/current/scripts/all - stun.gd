extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

var entity
var Game
func init(_entity):
	entity = _entity
	Game = entity.Game

func activate(Game, entity, unused):
	for ent in get_tree().get_nodes_in_group("entities"):
		if ent.Owner!=entity.Owner:
			ent.stunned = true
	
	return null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
