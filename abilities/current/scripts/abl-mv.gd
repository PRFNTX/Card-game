extends Node


# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export(int) var gold_cost = 0
export(int) var action_cost = 0
export(int) var faeria_cost = 1
export(int) var energy_cost = 0


export(int, 'empty', 'orb', 'land','lake','tree','hill','sand','well') var target_type = 0
export(int, 'Any', 'Owner', 'Opponent') var target_player = 0

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
	entity.use_energy(energy_cost)
	Game.players[entity.Owner].pay_costs(gold_cost,faeria_cost)
	Game.players[entity.Owner].useAction(action_cost)
	
#for thing in array
# if (anything is true)
# set target = true
func targeting():
	for hex in get_tree().get_nodes_in_group("Hex"):
		if target_player==0:
			if hex.stateLocal['hex_type']==target_type and not hex.has_unit():
				hex.setState({'cover':hex.targetOther , 'target' :true})
			else:
				hex.setState({'cover':Color(0,0,0,0) , 'target' :false})
		elif (target_player==1 and hex.stateLocal['hex_owner']==entity.Owner) or (target_player==2 and hex.stateLocal['hex_owner']!=entity.Owner) and hex.stateLocal['hex_type']==target_type and not hex.has_unit():
			hex.setState({'cover':hex.targetOther , 'target' :true})
		else:
			hex.setState({'cover':Color(0,0,0,0) , 'target' :false})


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
