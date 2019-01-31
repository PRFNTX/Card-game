extends Node

export(String) var ab_name = ""
export(String) var ab_description = ""

var free_target = null

func activate():
	if not free_target==null:
		var parent = free_target.get_parent()
		if parent.child_count() == 1:
			parent.get_parent().set(parent.get_name(), false)
		free_target.queue_free()
	if get_parent().child_count() == 1:
		get_parent().get_parent().set(get_parent().get_name(), false)
	queue_free()