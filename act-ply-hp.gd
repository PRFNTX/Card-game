extends Node

export(int, "unit", "creature", "building") var target_type = 1
export(int, "friendly", "enemy", "any") var target_player = 0
export(int) var value = 1

var Game
var entity

func init(_entity):
	Game = _entity.Game
	entity = _entity

func activate(type,target,set_state=null):
	if type.to_lower().includes(build) and conditions(target):
		var unit = Game.get_hex_by_id(target).get_unit()
		unit.life_change(1)

func conditions(target):
	if Game.get_hex_by_id(target).has_unit():
		var hex = Game.get_hex_by_id(target)
		var unit = hex.get_unit()
		if (target_type == 0):
			if target_player == 2:
				return true
			elif (target_player == 0 and unit.Owner == entity.Owner):
				return true
			elif (target_player == 1 and unit.Owner != entity.Owner):
				return true
		elif (target_type == 1 and hex.unit_is_creature()):
			if target_player == 2:
				return true
			elif (target_player == 0 and unit.Owner == entity.Owner):
				return true
			elif (target_player == 1 and unit.Owner != entity.Owner):
				return true
		elif (target_type == 2 and unit.Unit.is_building):
			if target_player == 2:
				return true
			elif (target_player == 0 and unit.Owner == entity.Owner):
				return true
			elif (target_player == 1 and unit.Owner != entity.Owner):
				return true
	return false