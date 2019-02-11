extends Node

var to_remove = []

var Game
var entity
func init(_entity):
	Game = _entity.Game
	entity = _entity

func track_node(node):
	to_remove.append(weakref(node))

func activate(_game, _entity, _val):
	for node in to_remove:
		if node.get_ref():
			node.get_ref().queue_free()