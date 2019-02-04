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

func activate(_Game, _entity,by, _val):
	Game = _Game
	entity = _entity
	val=_val
	if by == entity.Hex.id:
		if Game.players[entity.Owner].hand_cards < max_cards:
			Game.players[entity.Owner].drawCard() 