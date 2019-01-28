extends Node

export(int) var value = -3
export(int, "friendly", "enemy", "both") var player = 0

var Game
var entity
func init(_entity):
	entity = _entity
	Game = entity.Game

func acivate(_game, _entity, _val):
	if player == 0:
		Game.get_hex_by_id(1).get_unit().life_change(value)
	if player == 1:
		Game.get_hex_by_id(44).get_unit().life_change(value)
	if player == 2:
		Game.get_hex_by_id(1).get_unit().life_change(value)
		Game.get_hex_by_id(44).get_unit().life_change(value)