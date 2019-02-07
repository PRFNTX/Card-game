extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

func activate(Game, entity, source):
	queue_free()
	return false