extends Node

export(int) var value = 1

var Game
var entity
func init(_entity):
	entity=_entity
	Game = entity.Game

func activate(_game, _entity, targ):
	entity.life_change(value)