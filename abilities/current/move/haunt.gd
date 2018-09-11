extends Node

var Game
var entity
func init(_entity):
	entity=_entity
	Game=entity.Game

func activate(Game,entity,target):
	if Game.get_hex_by_id(target).stateLocal.hex_owner != entity.Owner:
		if entity.Owner == 0:
			Game.get_hex_by_id(1).get_unit().life_change(-1*entity.current_attack)
		elif entity.Owner == 1:
			Game.get_hex_by_id(44).get_unit().life_change(-1*entity.current_attack)