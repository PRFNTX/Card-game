extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

func activate(Game, entity, target):
	for child in get_children():
		activate(Game, entity, target)