extends Node

export(int) var gold_cost = 0
export(int) var action_cost = 0
export(int) var faeria_cost = 2
export(int) var energy_cost = 0

export(int) var power = 2
export(PackedScene) var unbuffer = null
export(String) var modName = "OrderOfValor"


var Game
var entity
func init(_entity):
	entity=_entity
	Game=entity.Game

func activate(_game, _entity, _unused):
	if verify_costs():
		pay_costs()
		var modName = entity.Unit.set_mod_att(modName, power, true)
		if unbuffer != null:
			var attach_unbuffer = unbuffer.instance()
			attach_unbuffer.set_name(modName)
			attach_unbuffer.init(entity)
			entity.Unit.get_node("on_end_turn").add_child(attach_unbuffer)
			entity.Unit.on_end_turn = true

func verify_costs():
	var ret = true
	if entity.get_energy()>=energy_cost and Game.players[entity.Owner].has_resource(gold_cost,faeria_cost,{0:0}) and Game.players[entity.Owner].actions>=action_cost:
		return true
	else:
		return false

func pay_costs():
	entity.use_energy(energy_cost)
	Game.players[entity.Owner].pay_costs(gold_cost,faeria_cost)
	Game.players[entity.Owner].useAction(action_cost)