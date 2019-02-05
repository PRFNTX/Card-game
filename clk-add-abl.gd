extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

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
	activate(Game, entity, Game.state.clock_time)

const MORNING=0
const EVENING=1
const NIGHT=2

var added_node = null

func activate(_game, _entity, time):
	var abl_name = ability.get_name()
	if clear_after and added_node != null and added_node.get_ref():
		added_node.get_ref().queue_free()
	if (
		time==MORNING and morning
		or time==EVENING and evening
		or time==NIGHT and night
	):
		added_node = ability.instance()
		added_node.init(entity)
		for key in attributes.keys():
			added_node.set(key, attributes[key])
		get_parent().get_parent().get_node(ability_category).add_child(added_node)
	
