extends Node

export(int) var value = 1

export(String) var ab_name = ""
export(String) var ab_description = ""

var entity
var Game

func init(_entity):
	entity = _entity
	Game = entity.Game

func activate(type, target, new_state=null):
	var state = Game.state
	if new_state!=null:
		state = new_state
	if target == entity.Hex.id:
		if type == "AttackAdjOrCollect" or type == "AttackAdj":
			Game.get_hex_by_id(state.active_unit).get_unit().receive_damage(value)