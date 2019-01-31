extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

func activate():
	queue_free()
	return false