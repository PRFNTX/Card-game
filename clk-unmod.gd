extends Node

var Game
var entity
func init(_entity):
	Game=_entity.Game
	entity=_entity

var modName = ""

func set_mod_name(name):
	modName = name

func activate(_game, _entity, unused):
	entity.Unit.unmod_att(modName)
	if get_parent().get_child_count() == 1:
		entity.Unit.on_end_turn = false
	queue_free()