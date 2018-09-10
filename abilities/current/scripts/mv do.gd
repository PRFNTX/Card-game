extends Node

func activate(Game, entity, target):
	for child in get_children():
		activate(Game, entity, target)