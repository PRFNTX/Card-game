extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

func init(entity):
	pass

func activate(Game, entity, source):
	queue_free()
	return false