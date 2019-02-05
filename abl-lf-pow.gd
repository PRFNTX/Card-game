extends Node

export(String) var ab_name = ""
export(String) var ab_description = ""

export(int) var cost = 1
export(int) var power = 1
export(bool) var stacks = true
export(PackedScene) var unbuffer = null
export(NodePath) var unmodNode

var Game
var entity
func init(_entity):
	entity=_entity
	Game=entity.Game

func activate(_game, _entity, _unused):
	if verify_costs():
		pay_costs()
	var modName = entity.Unit.set_mod_att('Lichorus', power, stacks)
	if get_node(unmodNode).has_method('add_mod_name'):
		get_node(unmodNode).call('add_mod_name', modName)
	if entity.Owner == 0:
		Game.send_activation(entity.Hex.id, get_parent().get_name()+"/"+get_name())

func verify_costs():
	return true

func pay_costs():
	entity.life_change(-1 * cost)

func get_relative_path():
	return get_parent().get_name()+'/'+get_name()