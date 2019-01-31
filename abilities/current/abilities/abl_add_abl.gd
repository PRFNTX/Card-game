extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(int) var gold_cost = 0
export(int) var action_cost = 0
export(int) var faeria_cost = 0
export(int) var energy_cost = 1

export(PackedScene) var ability = null
export(String) var ability_type = "Movement"
export(Dictionary) var attributes = {
	'distance': 3,
}

export(int, 'Unit', 'Creature', 'Building') var target_type = 1
export(int, 'Owner', 'Opponent') var target_player = 0
export(bool) var adjacent_only = false
export(bool) var free_after_turn = true
var ability_freer = load('res://abilities/current/clock/free_abl.tscn')

var entity
var Game
func init(_entity):
	entity = _entity
	Game = _entity.Game

func activate(_Game, _entity, val):
	Game = _Game
	entity = _entity
	if verify_costs():
		Game.delegate_action(entity.Hex.id,get_relative_path())

func get_relative_path():
	return get_parent().get_name()+'/'+get_name()

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
	

func targeting():
	for hex in get_tree().get_nodes_in_group("Hex"):
		if target_player==0:
			if hex.has_friendly_unit() and (target_type==0 or (target_type==1 and hex.unit_is_creature()) or (target_type==1 and hex.unit_is_building())) and (entity.Hex.adjacent.has(hex) or adjacent_only==false):
				hex.setState({'cover':hex.targetOther , 'target' :true})
			else:
				hex.setState({'cover':Color(0,0,0,0) , 'target' :false})
		elif target_player==1:
			if hex.has_opposing_unit() and (target_type==0 or (target_type==1 and hex.unit_is_creature()) or (target_type==1 and hex.unit_is_building())) and (entity.Hex.adjacent.has(hex) or adjacent_only==false):
				hex.setState({'cover':hex.targetOther , 'target' :true})
			else:
				hex.setState({'cover':Color(0,0,0,0) , 'target' :false})

var unactivatable_types = ["Attack", "Movement"]

func complete(target, set_state=null):
	pay_costs()
	var local = true
	var state = Game.get_state()
	if not set_state==null:
		state=set_state
		local= false
	var unit = Game.get_hex_by_id(target).get_unit()
	var replace = ability.instance()
	var target_node = unit.get_node(ability_type)
	var target_clock = unit.get_node('on_end_turn')
	if not find_node(replace.get_name(), false):
		target.add_child(replace)
		var freer = ability_freer.instance()
		freer.free_target = replace
		target_clock.add_child(freer)
		if not unit.on_clock:
			unit.on_end_turn = true
		if not unit.get(ability_type) and not unactivatable_types.has(ability_type):
			unit.set(ability_type, true)
		target_node.move_node(replace, 0)
		if replace.has_method('init'):
			replace.init(entity)
	else:
		replace.queue_free()
	
	if local:
		Game.send_action('delegate',45-target,{'delegate_id':entity.Hex.id,'delegate_node':get_relative_path()})
	Game.actionDone()
	

func cancel_action():
	pass
