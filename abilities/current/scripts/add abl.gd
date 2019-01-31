extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(PackedScene) var add_ability
export(String) var add_to = 'on_damage'

var Game
var entity
func init(_entity):
	entity= _entity
	Game = entity.Game
	
func activate(_Game, _entity, val):
	for ent in get_tree().get_nodes_in_group('entities'):
		if ent.Unit.is_unit and ent.Owner == entity.Owner:
			var new_ab = add_ability.instance()
			ent.Unit.get_node(add_to).add_child(new_ab)
			ent.Unit.set(add_to, true)
			new_ab.init(ent)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
