extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(PackedScene) var add_ability
export(String) var add_to = 'on_damage'

var Game
var entity
func init(_entity):
	entity=_entity
	Game=entity.Game

func activate(type,target,set_state=null):
	if type=="attack":
		var state = Game.get_state()
		if set_state!=null:
			state=set_state
		if type.find('build'):
			var ent = Game.get_hex_by_id(target).get_unit()
			if ent.Unit.is_unit and ent.Owner == entity.Owner:
				var new_ab = add_ability.instance()
				new_ab.set(entity)
				ent.Unit.get_node(add_to).add_child(new_ab)
				new_ab.init(ent)
				ent.Unit.on_damage=true

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
