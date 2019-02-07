extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(int) var max_cards = 3
export(int, 'card', 'gold', 'actions') var type = 0


var entity
var Game
func init(_entity):
	entity = _entity
	Game = entity.Game

var val

func activate(_Game, _entity, val):
	Game = _Game
	entity = _entity
	var unit_owner = Game.players[entity.Owner]
	if unit_owner.hand_cards < max_cards:
		unit_owner.drawCard() 