extends Node

export(PackedScene) var ability
export(String) var ability_type = "Abilities"
export(Dictionary) var attributes = {
	'distance': 2,
	'medium': 2, #aquatic
	'method': 1, #jump
}

var Game
var entity
func init(_entity):
	entity = _entity
	Game = entity.Game

func activate(_game, _entity, target):
	var replace = ability.instance()
	var location = entity.Unit.get_node(ability_type)
	location.add_child(replace)
	if replace.has_method('init'):
		replace.init(entity)
		for key in attributes.keys():
			ability.set(key, attributes[key])
	else:
		replace.queue_free()
