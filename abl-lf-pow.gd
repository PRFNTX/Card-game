extends Node

export(int) var cost = 1
export(int) var power = 1
export(PackedScene) var unbuffer = null

var Game
var entity
func init(_entity):
	entity=_entity
	Game=entity.Game

func activate(_game, _entity, _unused):
	entity.life_change(-1 * cost)
	var modName = entity.Unit.set_mod_att('Lichorus', power, true)
	if unbuffer != null:
		var attach_unbuffer = unbuffer.instance()
		attach_unbuffer.set_name(modName)
		attach_unbuffer.init(entity)
		entity.Unit.get_node("on_end_turn").add_child(attach_unbuffer)
		entity.Unit.on_end_turn = true