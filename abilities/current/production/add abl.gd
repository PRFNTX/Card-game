extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(PackedScene) var add_ability
export(String) var add_to = "on_production"
export(String) var ability_name = ""
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
	var target = entity.Unit.get_node(add_to)
	var replace = add_ability.instance()
	replace.ab_name = ability_name
	var thinger = find_node(replace.get_name(), false)
	print(thinger)
	if not find_node(replace.get_name(), false) or  find_node(replace.get_name(), false)==null:
		target.add_child(replace)
		entity.Unit.set(add_to, true)
		entity.actionList[ability_name] = replace
		if replace.has_method('init'):
			replace.init(entity)
			for key in use_attributes.keys():
				replace.set(key, use_attributes[key])
	else:
		replace.queue_free()

func get_attributes():
	if unit_attributes == 1:
		return silvermoon_attributes
	else:
		return attributes