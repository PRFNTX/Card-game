extends Node

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
	if Game.players[Game.state['current_turn']].hand_cards < max_cards:
		Game.players[Game.state['current_turn']].drawCard() 