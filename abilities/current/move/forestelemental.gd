extends Node

export(int) var max_health = 5
export(int, 'empty', 'orb','land','lake','tree','hill','sand') var land_type = 4
export(int) var gain_health = 1
export(bool) var destroy = true

var Game
var entity
func init(_entity):
	entity=_entity
	Game = entity.Game

func activate(_game, _entity, target):
	var target_hex = Game.get_hex_by_id(target)
	if target_hex.stateLocal.hex_type == land_type and entity.Unit.current_health < max_health:
		entity.life_change(gain_health)
		if destroy:
			target_hex.setState({'hex_type': 2})