extends Node

export(PackedScene) var add_ability
export(String) var add_to = "on_production"
# temp until export dict works
export(int, 'none', 'silvermoon dragon') var unit_attributes = 0
var attributes = {
}
var silvermoon_attributes = {
	'distance': 4,
	'medium': 1,
}

#adds by replacing all
func activate(Game,entity,unused):
	var use_attributes = get_attributes()
	var target = get_parent().get_parent().get_node(add_to)
	var replace = add_ability.instance()
	if not find_node(replace.get_name(), false):
		target.add_child(replace)
		if replace.has_method('init'):
			replace.init(entity)
			for key in get_attributes.keys():
				replace.set(key, get_attributes[key])
	else:
		replace.queue_free()

func get_attributes():
	if unit_attributes == 1:
		return silvermoon_attributes
	else:
		return attributes