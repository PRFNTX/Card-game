extends Node

export(String) var rem_name = 'on_damage/set redir'

var Game
var entity
func init(_entity):
	entity= _entity
	Game = entity.Game
	
func activate(_Game, _entity, val):
	for ent in get_tree().get_nodes_in_group('entities'):
		if ent.Unit.is_unit and ent.Owner == entity.Owner:
			var rem_ab = ent.Unit.get_node(rem_name)
			rem_ab.queue_free()
			if not ent.Unit.get_node('on_damage').get_child_cound()>0:
				ent.Unit.on_damage=false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
