extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export(int) var gold_cost = 0
export(int) var action_cost = 0
export(int) var faeria_cost = 0
export(int) var energy_cost = 0

export(bool) var random = true

export(int, 'Owner', 'Opponent') var target_player = 1 

var entity
var Game
func init(_entity):
	entity = _entity
	Game = entity.Game

func activate(_Game, _entity, val):
	Game = _Game
	entity=_entity
	if verify_costs():
		complete(0)

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
	

""" not used
func targeting():
	for hex in get_tree().get_nodes_in_group("Hex"):
		if target_player==0:
			if hex.has_friendly_unit() and (target_type==0 or (target_type==1 and hex.unit_is_creature()) or (target_type==1 and hex.unit_is_building())):
				hex.setState({'cover':hex.targetOther , 'target' :true})
			else:
				hex.setState({'cover':Color(0,0,0,0) , 'target' :false})
		elif target_player==1:
			if hex.has_enemy_unit() and (target_type==0 or (target_type==1 and hex.unit_is_creature()) or (target_type==1 and hex.unit_is_building())):
				hex.setState({'cover':hex.targetOther , 'target' :true})
			else:
				hex.setState({'cover':Color(0,0,0,0) , 'target' :false})
"""

func complete(target, set_state=null):
	pay_costs()
	var local = true
	var state = Game.get_state()
	if not set_state==null:
		state=set_state
		local= false
	
	if random:
		Game.players[(entity.Owner+target_player)%2].discard_hand()
	else:
		## implement selected discard
		pass
	if local:
		Game.send_action('delegate',0,{'delegate_id':entity.Hex.id,'delegate_node':'Abilities/discard'})
	


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
