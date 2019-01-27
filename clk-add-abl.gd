extends Node

export(PackedScene) var ability = null
export(String) var ability_category = "Abilities"
export(Dictionary) var attributes = {
	'distance': 2,
	'medium': 2, #aquatic
	'method': 1, #jump
}
export(bool) var clear_others = false
export(bool) var clear_after = true
export(bool) var night = true
export(bool) var morning = true
export(bool) var evening = true

var Game
var entity
func init(_entity):
	entity=_entity
	Game=_entity.Game

const MORNING=0
const EVENING=1
const NIGHT=2

func activate(_game, _entity, time):
	var abl_name = ability.get_name()
	if clear_after:
		var category = get_parent().get_parent().get_node(ability_category)
		category.find_node(abl_name).queue_free()
	if (
		time==MORNING and morning
		or time==EVENING and evening
		or time==NIGHT and night
	):
		var new_abl = ability.instance()
		ability.init(entity)
		for key in attributes.keys():
			ability.set(key, attributes[key])
	
