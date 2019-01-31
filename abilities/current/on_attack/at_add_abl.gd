extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(PackedScene) var add_ability
export(String) var ability_type = "on_death"
#temporary until export dict works
export(int, "none", "Spirit of Agony") var attribute_set = 0
export(bool) var remove_after_action = true

var Game
var entity
func init(_entity):
	entity = _entity
	Game = entity.Game

func activate(_game, _entity, target):
	var attributes = get_attributes()
	var target_entity = Game.get_hex_by_id(target).get_unit()
	var new_ab = add_ability.instance()
	target_entity.Unit.get_node(ability_type).add_child(new_ab)
	target_entity.Unit.set(ability_type, true)
	for key in attributes.keys():
		new_ab.set(key, attributes[key])
	new_ab.init(ent)

func get_attributes():
	if attribute_set==0:
		return {}
	elif attribute_set==1:
		return {}

var added_ability = null
var unsettable_types = ['Attack', 'Movement']
func end():
	if remove_after_action and not added_ability==null:
		if added_ability.get_parent().child_cound() == 1 and not unsettable_types.has(ability_type):
			added_ability.get_parent().get_parent().set(ability_type, false)
		added_ability.queue_free()