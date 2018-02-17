extends Node


# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export(int) var gold_cost = 0
export(int) var action_cost = 0
export(int) var faeria_cost = 0
export(int) var energy_cost = 1


export(int, 'empty', 'orb', 'land','lake','tree','hill','sand','well', 'Any') var target_type = 8 #not well, not orb
export(int, 'Any', 'Owner', 'Opponent') var target_player = 0

var entity
var Game
func init(_entity):
	entity = _entity
	Game = entity.Game

var val

func activate(_Game, _entity, _val):
	if verify_costs():
		Game = _Game
		entity = _entity
		val=_val
		Game.delegate_action(entity.Hex.id,get_parent().get_name()+"/"+get_name())

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
		if hex.stateLocal['hex_type']>1 and hex.stateLocal['hex_type']<7:
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
	if hex_target.has_unit():
		hex_target.get_unit().on_death()
	hex_target.setState({'hex_owner':-1,'hex_type':0})
	if local:
		Game.send_action('delegate',45-target,{'delegate_id':45-entity.Hex.id,'delegate_node':get_parent().get_name()+"/"+get_name()})
	Game.actionDone()


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
