extends Node

export(int,'empty','null','land','lake','tree','hill','sand') var type = 2


export(String) var ab_name = ""
export(String) var ab_description = ""

export(int) var energy_cost = 1
export(int) var action_cost = 0
export(int) var faeria_cost = 0
export(int) var gold_cost = 0

var Game
var entity
func init(_entity):
	entity=_entity
	Game=entity.Game

func activate(Game,entity,loc):
	var try = false
	if verify_costs():
		for hex in entity.Hex.adjacent:
			if hex.stateLocal['hex_type']==0:
				try=true
		if try and entity.Owner==0:
			Game.delegate_action(entity.Hex.id,get_parent().get_name()+'/'+get_name())
		return true

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

func remote_convert(hex_id):
	if hex_id==0:
		return 0
	else:
		return 45-hex_id

func targeting():
	for hex in entity.Hex.adjacent:
		if hex.stateLocal['hex_type']==0 or hex.stateLocal['hex_type']==2: #empty or land, dont check owner
			hex.setState({'cover':hex.targetOther , 'target' :true})
		else: 
			hex.setState({'cover':Color(0,0,0,0) , 'target' :false})

func complete(target, set_state=null):
	var local= true
	var state=Game.get_state()
	pay_costs()
	if set_state!=null:
		local=false
		state=set_state
	var target_hex = Game.get_hex_by_id(target)
	target_hex.setState({'hex_type':type})
	if target_hex.stateLocal['hex_owner'] == -1:
		target_hex.setState({'hex_owner': entity.Owner})
	Game.update_lands_owned()
	if local:
		Game.send_action('delegate',remote_convert(target),{'delegate_id':remote_convert(entity.Hex.id), 'delegate_node':get_parent().get_name()+'/'+get_name()})
		
	Game.actionDone()