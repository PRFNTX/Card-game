extends Node

export(int) var energy_cost = 0
export(int) var gold_cost = 0
export(int) var faeria_cost = 0
export(int) var action_cost = 0

export(int, "None", "Aquatic", "Flying", "As Target") var medium = 0

var entity
var Game
func init(_entity):
	entity = _entity
	Game = entity.Game

var val

func activate(_Game, _entity, _val):
	Game = _Game
	entity = _entity
	val=_val
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
	if get_parent().has_method('pay_costs'):
		get_parent().pay_costs()
	else:
		entity.use_energy(energy_cost)
		Game.players[entity.Owner].pay_costs(gold_cost,faeria_cost)
		Game.players[entity.Owner].useAction(action_cost)
	

func targeting():
	for hex in entity.Hex.adjacent:
		if medium==0:
			if hex.hexType.child.moveLand and hex.hex_is_empty_or_self() and hex.is_adjacent_or_equal_to(hex.stateLocal['active_unit'].Hex):
				hex.setState({'cover':hex.move,'target':true})
			else:
				hex.setState({'cover':Color(0,0,0,0), 'target':false})
		elif medium==2:
			if hex.hexType.child.moveAir and hex.hex_is_empty_or_self() and hex.is_adjacent_or_equal_to(hex.stateLocal['active_unit'].Hex):
					setState({'cover':hex.move,'target':true})
			else:
				setState({'cover':Color(0,0,0,0), 'target':false})
		elif medium==1:
			if hex.hexType.child.moveWater and hex.hex_is_empty_or_self() and hex.is_adjacent_or_equal_to(hex.stateLocal['active_unit'].Hex):
				setState({'cover':hex.move,'target':true})
			else:
				setState({'cover':Color(0,0,0,0), 'target':false})


func complete(target, set_state=null):
	pay_costs()
	var local = true
	var state = Game.get_state()
	if not set_state==null:
		state=set_state
		local= false
		
	var hex_target = Game.get_hex_by_id(target)
	if local:
		Game.send_action('hardMove',45-target,{'active_unit':45-entity.Hex.id})
	entity.on_move(hex_target.get_node('hexEntity'))
	Game.actionDone()
	
func cancel_action():
	pass

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
