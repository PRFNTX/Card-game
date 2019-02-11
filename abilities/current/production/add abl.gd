extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(PackedScene) var add_ability
export(String) var add_to = "on_production"
export(String) var ability_name = ""
export(bool) var free_first = true
# temp until export dict works
export(Dictionary) var attributes = {}

var added_node = null

var Game
var entity
func init(_entity):
	entity = _entity
	Game = _entity.Game
	activate(Game, entity, null)

#adds by replacing all
func activate(Game, entity, unused):
	var target = entity.Unit.get_node(add_to)
	if free_first and added_node != null and added_node.get_ref():
		added_node.get_ref().queue_free()
	var new_node = add_ability.instance()
	new_node.ab_name = ability_name
	new_node.init(entity)
	for key in attributes.keys():
		new_node.set(key, attributes[key])
	get_parent().get_parent().get_node(add_to).add_child(new_node)
	target.add_child(new_node)
	entity.Unit.set(add_to, true)
	if add_to == "Abilities":
		entity.actionList[ability_name] = weakref(new_node).get_ref()
	added_node = weakref(new_node)
	