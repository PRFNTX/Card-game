extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(int) var gold_cost = 0
export(int) var action_cost = 0
export(int) var faeria_cost = 0
export(int) var energy_cost = 1

export(bool) var then_free = false

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
		Game.delegate_action(entity.Hex.id,get_parent().get_parent().get_name()+'/'+get_parent().get_name()+'/'+get_name())
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
	

func conditions(hex):
	if hex.stateLocal['hex_type']==0 and not hex.has_unit():
		return true
	return false

func targeting():
	for hex in Game.get_hex_by_id(Game.state['active_unit']).adjacent:
		if conditions(hex):
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
	var from_hex = Game.get_hex_by_id(state['active_unit'])
	var to_hex = Game.get_hex_by_id(target)
	to_hex.setState({'hex_type':from_hex.stateLocal['hex_type'],'hex_owner':from_hex.stateLocal['hex_owner']})
	from_hex.setState({'hex_type':0,'hex_owner':-1})
	if from_hex.has_unit():
		from_hex.get_unit().on_move(to_hex.get_node('hexEntity'))
	if local:
		Game.send_action('moveHex',45-target,{'active_unit':45-state['active_unit']},true)
		if get_parent().repeat():
			return false
		elif then_free:
			entity.queue_free()
			return true
		else:
			return true

func cancel_action():
	Game.newAction()
	get_parent().iter-=1
	get_parent().activate(Game,entity,val)


