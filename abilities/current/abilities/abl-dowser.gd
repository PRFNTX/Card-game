extends Node


# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export(String) var ab_name = ""
export(String) var ab_description = ""

export(int) var gold_cost = 0
export(int) var action_cost = 1
export(int) var faeria_cost = 1
export(int) var energy_cost = 0
export(bool) var single_use = true

export(int) var structureDamage = 2


export(int, 'empty', 'orb', 'land','lake','tree','hill','sand','well') var make_type = 3

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
	

var valid_targets = [1,2,4,5,6]
func targeting():
	for hex in entity.hex.adjacent:
		if (
			hex.stateLocal.hex_type.has(valid_targets)
		):
			hex.setState({
				'cover':hex.summon, 'target':true
			})
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
	hex_target.setState({
		'hex_type': 3
	})
	if hex_target.unit_is_building():
		$hexEntity.get_children()[1].receive_damage(structureDamage)
	if local:
		Game.send_action('delegate',45-target,{'delegate_id':entity.Hex.id,'delegate_node':get_relative_path()})
	Game.actionDone()
	queue_free()

func cancel_action():
	pass

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
