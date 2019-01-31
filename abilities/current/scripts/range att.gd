extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(int) var gold_cost = 0
export(int) var action_cost = 0
export(int) var faeria_cost = 0
export(int) var energy_cost = 1


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
	

func targeting():
	var nodes = [ring(entity.Hex,2)]
	var big_adj = []
	for hex in nodes:
		for ad in hex.adjacent:
			big_adj.append(ad)
	var neg = ring(entity.Hex,1)
	var outer = ring(entity.Hex,3)
	for fin in outer:
		if big_adj.find(fin)==big_adj.find_last(fin):
			nodes.append(fin)
	for hex in nodes:
		if hex.has_opposing_unit():
			hex.setState({'cover':hex.targetOther , 'target' :true})
		else:
			hex.setState({'cover':Color(0,0,0,0.2) , 'target' :false})


func complete(target, set_state=null):
	pay_costs()
	var local = true
	var state = Game.get_state()
	if not set_state==null:
		state=set_state
		local= false
		
	var unit = get_unit_by_hex(get_hex_by_id(state['active_unit']))
	unit.on_attack(get_hex_by_id(target).get_unit())
	
	if local:
		Game.send_action('AttackAdj',45-target,{'active_unit':45-entity.Hex.id})
	
	Game.actionDone()
	
func cancel_action():
	pass

func ring(hex,n):
	if n == 0:
		return hex
	if n==1:
		return hex.adjacent
	var adj=[hex,hex.adjacent]
	
	for i in range(2,n):
		var new = []
		for hex in adj[i-1]:
			for ad in hex.adjacent:
				new.append(ad)
		var rng = []
		for j in range(1,i):
			for hex in new:
				if adj[j].has(hex) or adj[0]==hex:
					new.erase(hex)
		adj.append(new)
	return adj[n-1]

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
