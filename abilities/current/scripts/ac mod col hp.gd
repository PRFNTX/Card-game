extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(int) var max_health_collect = 4


var Game
var entity
func init(_entity):
	entity = _entity
	Game = entity.Game

func activate(type,target,set_state=null):
	if (
		entity.Unit.current_health > max_health_collect
	):
		entity.Unit.collect = false
	else:
		entity.Unit.collect = true