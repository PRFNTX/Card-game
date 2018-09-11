extends Node

export(int) var health_level = 4
export(bool) var inclusive = false
export(bool) var greater_than = false
export(bool) var on_condition_set = false

var Game
var entity
func init(_entity):
	entity = _entity
	Game = entity.Game

func activate(type,target,set_state=null):
	if (
		(greater_than and entity.current_health > health_level)
		or (greater_than and inclusive and entity.current_health >= health_level)
		or (not greater_than and entity.current_health < health_level)
		or (not greater_than and inclusive and entity.current_health <= health_level)
	):
		entity.Unit.collect = on_condition_set
	else:
		entity.Unit.collect = !on_condition_set