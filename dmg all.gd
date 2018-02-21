extends Node

export(int,'All','Structures','Creatures') var type = 1
export(int) var effect = -2

var entity
var Game
func init(_entity):
	entity = _entity
	Game = entity.Game

func activate(Game, entity, unused):
	for ent in get_tree().get_nodes_in_group("entities"):
		if ent.Owner!=entity.Owner:
			if type==0:
				ent.life_change(effect)
			elif type==1 and ent.Unit.is_building:
				ent.life_change(effect)
			elif type==2 and ent.Unit.is_unit:
				ent.life_change(effect)
	return null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
