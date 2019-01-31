extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(int,"Any","Owner","Opponent") var player = 2
export(int,"Unit","Creature","Building") var type = 1

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
	return entity.get_energy()==3


func conditions(hex):
	
	if not hex.has_unit():
		return false
	if player==0:
		if type == 0:
			return true
		elif type==1 and hex.unit_is_creature():
			return true
		elif type==2 and hex.unit_is_building():
			return true
	else:
		if type == 0:
			return (player==1 and hex.has_friendly_unit(entity.Owner)) or (player==2 and hex.has_opposing_unit(entity.Owner))
		elif type==1 and hex.unit_is_creature():
			return (player==1 and hex.has_friendly_unit(entity.Owner)) or (player==2 and hex.has_opposing_unit(entity.Owner))
		elif type==2 and hex.unit_is_building():
			return (player==1 and hex.has_friendly_unit(entity.Owner)) or (player==2 and hex.has_opposing_unit(entity.Owner))
	return false

func targeting():
	for hex in get_tree().get_nodes_in_group("Hex"):
		if conditions(hex):
			hex.setState({'cover':hex.targetOther , 'target' :true})
		else:
			hex.setState({'cover':Color(0,0,0,0) , 'target' :false})

func complete(target, set_state=null):
	
	var local = true
	var state = Game.get_state()
	if not set_state==null:
		state=set_state
		local= false
		
	var hex_target = get_hex_by_id(target).get_unit().on_death()
	entity.queue_free()
	if local:
		Game.send_action('delegate',45-target,{'delegate_id':entity.Hex.id,'delegate_node':get_parent().get_name()+"/"+get_name()})
	

func cancel_action():
	entity.queue_free()


"""
func verify_costs():
	var ret = true
	if entity.get_energy()>=energy_cost and Game.players[entity.Owner].has_resource(gold_cost,faeria_cost,0) and Game.players[entity.Owner].actions>=action_cost:
		return true
	else:
		return false

func pay_costs():
	entity.use_energy(energy_cost)
	Game.players[entity.Owner].pay_resource(gold_cost,faeria_cost)
	Game.players[entity.Owner].useAction(action_cost)
"""





func _ready():
	pass


