extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(bool) var by_power = true
export(int) var value = 1

var Game
var entity
func init(_entity):
	entity=_entity
	Game=entity.Game

func activate(Game,entity,target):
	if Game.get_hex_by_id(target).stateLocal.hex_owner != entity.Owner:
		if entity.Owner == 0:
			if by_power:
				Game.get_hex_by_id(1).get_unit().life_change(-1*entity.current_attack)
			else:
				Game.get_hex_by_id(1).get_unit().life_change(-1*value)
		elif entity.Owner == 1:
			if by_power:
				Game.get_hex_by_id(44).get_unit().life_change(-1*entity.current_attack)
			else:
				Game.get_hex_by_id(44).get_unit().life_change(-1*value)