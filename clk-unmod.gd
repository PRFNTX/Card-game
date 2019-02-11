extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""
export(bool) var free_after = true

var Game
var entity
func init(_entity):
	Game=_entity.Game
	entity=_entity

var modnames = []

func set_mod_name(namo):
	add_mod_name(namo) #just for already written abilities

func add_mod_name(modname):
	modnames.append(modname)

func activate(_game, _entity, unused):
	for modname in modnames:
		entity.Unit.unmod_att(modname)
	if free_after:
		if get_parent().get_child_count() == 1:
			entity.Unit.on_end_turn = false
		queue_free()