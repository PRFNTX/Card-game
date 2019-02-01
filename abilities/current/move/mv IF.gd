extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

func activate(Game, entity, target):
	var children = get_children()
	if children[0].activate(Game, entity, target):
		children[1].activate(Game, entity, target)