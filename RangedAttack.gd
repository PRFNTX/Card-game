extends Node

var Game
var entity
func init(_entity):
	entity = _entity
	Game = entity.Game

func activate(_game, _entity, _val):
	