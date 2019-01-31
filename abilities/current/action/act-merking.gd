extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(int) var damage = 1
export(int) var gold_gain = 1

var Game
var entity
func init(_entity):
	entity=_entity
	Game = entity.Game

func activate(type,target,set_state=null):
	var active_unit = Game.state.active_unit
	if set_state != null:
		if set_state.keys().has('active_unit'):
			active_unit = set_state.active_unit
	if target==entity.Hex.id:
		if type.to_lower().find('attack')>=0:
			var source_hex = Game.get_hex_by_id(active_unit).get_unit().receive_damage(damage)
			Game.players[entity.Owner].mod_coin(gold_gain)
			queue_free()