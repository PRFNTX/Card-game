extends Node

export(int) var gold_cost = 0
export(int) var action_cost = 1
export(int) var faeria_cost = 1
export(int) var energy_cost = 0

export(int, 'empty', 'orb', 'land','lake','tree','hill','sand','well') var type = 2

var Game
var entity
func init(_entity):
	entity = _entity
	Game = entity.Game

func activate(_game, _entity, _val):
	Game = _game
	entity = _entity
	Game.delegate_action(entity.Hex.id,get_parent().get_name()+'/'+get_name())


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

func conditions(hex):
	if hex.hexType.child.ActionLand(hex, entity.Owner) and hex.hex_is_empty():
		return true

func targeting():
	var valid_targets = false
	for hex in get_tree().get_nodes_in_group("Hex"):
		if conditions(hex):
			hex.setState({'cover':hex.targetOther , 'target' :true})
			valid_targets = true
		else:
			hex.setState({'cover':Color(0,0,0,0) , 'target' :false})
	if not valid_targets:
		Game.no_valid_targets()

func complete(target, set_state=null):
	var local = true
	var state = Game.get_state()
	if not set_state==null:
		state=set_state
		local= false
	var hex = Game.get_hex_by_id(target)
	hex.setState({'hex_type':type,'hex_owner':entity.Owner})
	Game.update_lands_owned()
	if local:
		Game.send_action('delegate',45-target,{'delegate_id':entity.Hex.id,'delegate_node':get_parent().get_name()+'/'+get_name()})
	Game.actionDone()

