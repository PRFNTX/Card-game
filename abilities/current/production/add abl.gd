extends Node

export(PackedScene) var add_ability
export(String) var add_to = "on_production"

#adds by replacing all
func activate(Game,entity,unused):
	var target = get_parent().get_parent().get_node(add_to)
	for child in target.get_children():
		child.queue_free()
	var replace = add_ability.instance()
	target.add_child(replace)
	if replace.has_method('init'):
		replace.init(entity)