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
	var target_orb
	if Game.get_hex_by_id(target).stateLocal.hex_owner != entity.Owner:
		if entity.Owner == 0:
			target_orb = Game.get_hex_by_id(44).get_unit()
		elif entity.Owner == 1:
			target_orb = Game.get_hex_by_id(1).get_unit()
		if by_power:
			target_orb.life_change(-1*entity.Unit.current_attack)
		else:
			target_orb.life_change(-1*value)