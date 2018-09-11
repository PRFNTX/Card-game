extends Node


export(int, "Any","Opponent","Owner") var player = 0
export(int,"Hex") var type = 0
export(bool) var empty_only = true
export(bool) var then_free = false
export(bool) var adjacent_only = false

export(int) var gold_cost = 0
export(int) var action_cost = 1
export(int) var faeria_cost = 0
export(int) var energy_cost = 0

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
	if entity.Owner==0:
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

func conditions(hex):
	if hex.stateLocal['hex_type'] >1 and hex.stateLocal['hex_type'] <7 and ( not empty_only or not hex.has_unit() ):
		if player == 0:
			return true
		elif hex.stateLocal['hex_owner']==player%2:
			return true
	return false

func targeting():
	if not adjacent_only:
		for hex in get_tree().get_nodes_in_group("Hex"):
			if conditions(hex):
				hex.setState({'cover':hex.targetOther , 'target' :true})
			else:
				hex.setState({'cover':Color(0,0,0,0) , 'target' :false})
	else:
		for hex in entity.Hex.adjacent:
			if conditions(hex):
				hex.setState({'cover':hex.targetOther , 'target' :true})
			else:
				hex.setState({'cover':Color(0,0,0,0) , 'target' :false})


var iter = 0
export(int) var max_iter=5
func complete(target, set_state=null):
	
	var local = true
	var state = Game.get_state()
	if not set_state==null:
		state=set_state
		local= false
	Game.setState({'active_unit':target})
	Game.actionReady=true
	get_children()[0].activate(Game,entity,val)
	return false

func repeat():
	if iter<max_iter:
		Game.newAction({'action':'','active_unit':null})
		activate(Game,entity,val)
		iter+=1
		return true
	else:
		return false

func cancel_action():
	if iter>0:
		#remove card and end
		pass
	else:
		#done remove card but end
		pass

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
