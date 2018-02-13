
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"


onready var globals = get_node('/root/master')

var BoardEntity = load('res://BoardEntity.tscn')
var OrbEntity = load('res://Cards/entities/orb_entity.tscn')
var WellEntity = load('res://Cards/entities/well_entity.tscn')

#signal SpawnFaeria
signal UpdateState
signal GameStart
signal TurnStart
signal ActionPhase
signal TurnEnd

var players = [null, null]

var global_player_num = 0

func set_player(val):
	global_player_num = val
	setState({'current_turn':val})



###### current_turn will be set to 0 during local players turn and 1 during remote players turn
var state={"action":"", 'current_turn':0,'active_unit':null,'clock_time':0,'hovered':null,'building_card':null, 'delegate_id':null,'delegate_node':null, 'hand_cast':null}

var actionTimer

func _init(initial_state={}):
	pass


#STATE 
func setState(obj):
	for key in obj.keys():
		call(key, obj[key])
		#call 'setters' instead?
	emit_signal("UpdateState",state,obj.keys())

######## STATE FUNCTIONS
func action(val):
	state['action'] = val

func current_turn(val):
	state['current_turn'] = val
	if val==0:
		$endturn.show()
	else:
		$endturn.hide()

func delegate_res(val):
	state['delegate_res'] = val

func active_unit(unit_hex_id):
	state['active_unit']=unit_hex_id
	if !(unit_hex_id==null):
		var unit = get_unit_by_hex(get_hex_by_id(unit_hex_id))
		unit.setState({'active':true})

const MORNING=0
const EVENING=1
const NIGHT=2
func clock_time(val):
	$Clock.frame=val
	#if val == MORNING:
	#	emit_signal('SpawnFaeria')
	state['clock_time']=val

func hovered(hex):
	state['hovered'] = hex

func building_card(card):
	state['building_card'] = card

func hand_cast(card_name):
	state['hand_cast'] = card_name

func delegate_id(val):
	state['delegate_id'] = val

func delegate_node(path):
	state['delegate_node'] = path

################

func create_player(num):
	var res_playerObject = load('res://PlayerObject.tscn')
	var p = res_playerObject.instance()
	add_child(p)
	if num==0:
		p.position=$pointP1.position
	else:
		p.position=$pointP2.position
	p.onCreate(self,num)
	if !globals.deck_list==null and globals.deck_list.keys().size()>0 and num==0:
		p.Deck = globals.deck_list[globals.Deck]
	return p

var ready = false
func _ready():
	set_process_input(true)
	
	players[0]=create_player(0)
	players[1]=create_player(1)
	
	$Hand.assign_player(players[0])
	players[0].hand_object=$Hand
	
	setState({'current_turn':0})
	actionTimer = $actionTimer
	
	### spawn starting structures
	var ORB = 2
	var WELL = 8
	for hex in get_tree().get_nodes_in_group('Hex'):
		if hex.hexType.child.type==ORB:
			var starting_entity = BoardEntity.instance()
			hex.get_node('hexEntity').add_child(starting_entity)
			starting_entity.possess(OrbEntity,hex,hex.initial_owner,self)
		if hex.hexType.child.type==WELL:
			var starting_entity = BoardEntity.instance()
			hex.get_node('hexEntity').add_child(starting_entity)
			starting_entity.possess(WellEntity,hex,hex.initial_owner,self)
			#starting_entity.spawn_faeria()
	
	set_player(globals.player_num)
	emit_signal('GameStart')
	emit_signal('TurnStart', state['current_turn'])
	emit_signal('ActionPhase', state['current_turn'])
	ready = true

func change_turns(none,unused):
	if state['current_turn'] == 0:
		send_action('change_turns',0,{'empty':true})
	print('changing turns')
	cancelAction()
	emit_signal("TurnEnd", state['current_turn'])
	var current_time = state['clock_time']
	###TESTING
	if false:
		setState({'current_turn':(state['current_turn']+1)%1,'action':"",'active_unit':null,'clock_time':(current_time+1)%3})
	else:
		setState({'current_turn':(state['current_turn']+1)%2,'action':"",'active_unit':null,'clock_time':(current_time+1)%3})
	emit_signal("TurnStart", state['current_turn'])
	emit_signal("ActionPhase", state['current_turn'])
	

var actionReady = true
var complete = true
func _input(event):
	if state['current_turn']==0 and players[int(state['current_turn'])].actions>0 and actionReady and ready:
		if event.is_action("card"):
			actionReady=false
			complete = false
			startTimer()
			actionCard(null)
		if event.is_action("land") and check_valid_action('actionLand'):
			actionReady=false
			complete = false
			startTimer()
			setState({"action":"actionLand"})
		if event.is_action("tree") and check_valid_action('actionTree'):
			actionReady=false
			complete = false
			startTimer()
			setState({"action":"actionTree"})
		if event.is_action("lake") and check_valid_action('actionLake'):
			actionReady=false
			complete = false
			startTimer()
			setState({"action":"actionLake"})
		if event.is_action("hill") and check_valid_action('actionHill'):
			actionReady=false
			complete = false
			startTimer()
			setState({"action":"actionHill"})
		if event.is_action("sand")  and check_valid_action('actionSand'):
			actionReady=false
			complete = false
			startTimer()
			setState({"action":"actionSand"})
		if event.is_action("coin"):
			actionReady=false
			complete = false
			startTimer()
			actionCoin(null)
	elif event.is_action("cancel"):
		cancelAction()
		startTimer()



var building_card_ind


#func get_hand_card(ind):
#	return players[state['current_turn']].Hand[ind]

func delegate_action(delegate,nodepath):
	startBasictimeout()
	if actionReady:
		actionReady=false
		complete = false
		startTimer()
		setState({"action":'delegate','delegate_id':delegate,'delegate_node':nodepath})
		### how to find activating script
		get_hex_by_id(state['delegate_id']).get_unit().get_node(state['delegate_node']).targeting()

func start_unit_action(type):
	startBasictimeout()
	if actionReady and check_valid_action(type) and state['active_unit']!=null:
		actionReady=false
		complete = false
		startTimer()
		setState({"action":type})

func start_build_action(gold, faeria, lands,card_num, card, buildType):
	if actionReady and players[state['current_turn']].has_resource(gold,faeria,lands):
		setState({'building_card':card.get_node("Card").card_name})
		building_card_ind = card_num
		actionReady=false
		complete=false
		startTimer()
		setState({'action':buildType})

func activate(unit):
	startBasictimeout()
	if unit.Owner==state['current_turn'] and actionReady and state['active_unit']!=unit.Hex.id:
		setState({'active_unit':unit.Hex.id})
		unit.Unit.on_select(self, unit.Hex)


func completeAction(target):
	if can_do:
		call(state["action"],target.id)

func actionDone():
	
	setState({"action":"",'active_unit':null, 'hand_cast':null, 'delegate_id':null,"delegate_node":null})
	complete = true

func cancelAction():
	setState({"action":"",'active_unit':null, 'hand_cast':null, 'delegate_id':null,'delegate_node':null})
	complete = true




##ACTIONS
#for reasons
func get_state():
	return state


#currently only for remote
func hardMove(target, set_state=null):
	var local = false
	var state = get_state()
	if set_state!=null:
		state=set_state
	
	var hex_target = get_hex_by_id(target)
	var unit = get_unit_by_hex(get_hex_by_id(state['active_unit']))
	unit.on_move(hex_target.get_node('hexEntity'))
	unit.Hex=hex_target


func moveBase(target, set_state=null):
	var local = true
	var state = get_state()
	if set_state!=null:
		state=set_state
		local=false
	var hex_target = get_hex_by_id(target)
	startBasictimeout()
	var unit = get_unit_by_hex(get_hex_by_id(state['active_unit']))
	unit.on_move(hex_target.get_node('hexEntity'))
	
	#unit.rect_position = target.get_node('hexEntity/pos').position
	unit.Hex=hex_target
	unit.use_energy()
	if local:
		send_action('moveBase',45-target,{'active_unit':45-state['active_unit']})
		unit.setState({'active':false})
		setState({'active_unit':target})
	
	
	if check_valid_action(unit.Unit.get_action_name('Attack')):
		actionReady=true
		unit.Unit.start_attack(self)
	else:
		
		actionDone()

func moveWater(target, set_state=null):
	var local = true
	var state = get_state()
	if set_state!=null:
		state=set_state
		local=false
	var hex_target = get_hex_by_id(target)
	startBasictimeout()
	var unit = get_unit_by_hex(get_hex_by_id(state['active_unit']))
	unit.on_move(hex_target.get_node('hexEntity'))
	
	#unit.rect_position = target.get_node('hexEntity/pos').position
	unit.Hex=hex_target
	unit.use_energy()
	if local:
		send_action('moveAquatic',45-target,{'active_unit':45-state['active_unit']})
		unit.setState({'active':false})
		setState({'active_unit':target})
	
	
	if check_valid_action(unit.Unit.get_action_name('Attack')):
		actionReady=true
		unit.Unit.start_attack(self)
	else:
		
		actionDone()

func moveAir(target, set_state=null):
	var local = true
	var state = get_state()
	if set_state!=null:
		state=set_state
		local=false
	var hex_target = get_hex_by_id(target)
	startBasictimeout()
	var unit = get_unit_by_hex(get_hex_by_id(state['active_unit']))
	unit.on_move(hex_target.get_node('hexEntity'))
	
	#unit.rect_position = target.get_node('hexEntity/pos').position
	unit.Hex=hex_target
	unit.use_energy()
	if local:
		send_action('moveAir',45-target,{'active_unit':45-state['active_unit']})
		unit.setState({'active':false})
		setState({'active_unit':target})
	
	
	if check_valid_action(unit.Unit.get_action_name('Attack')):
		actionReady=true
		unit.Unit.start_attack(self)
	else:
		
		actionDone()

func AttackAdjOrCollect(target, set_state=null):
	var local = true
	var state = get_state()
	if not set_state==null:
		state=set_state
		local= false
	var unit = get_unit_by_hex(get_hex_by_id(state['active_unit']))
	unit.on_attack(get_hex_by_id(target).get_node('hexEntity').get_node('BoardEntity'))
	if local:
		send_action('AttackAdjOrCollect',45-target,{'active_unit':45-state['active_unit']})
		unit.setState({'active':false})
	
	actionDone()

func AttackAdj(target, set_state=null):
	var local = true
	var state= get_state()
	if set_state!=null:
		state=set_state
		local = false
	var unit = get_unit_by_hex(get_hex_by_id(state['active_unit']))
	unit.on_attack(get_hex_by_id(target).get_node('hexEntity').get_node('BoardEntity'))
	if local:
		send_action('AttackAdj',45-target,{'active_unit':45-state['active_unit']})
		unit.setState({'active':false})
	
	actionDone()

func Collect(target, set_state=null):
	var local = true
	var state= get_state()
	if not set_state==null:
		state=set_state
		local = false
	var unit = get_unit_by_hex(get_hex_by_id(state['active_unit']))
	unit.on_attack(target.get_node('hexEntity').get_child())
	if local:
		send_action('Collect',45-target,{'active_unit':45-state['active_unit']})
		unit.setState({'active':false})
	
	actionDone()

func castAny(target, set_state=null):
	var local = true
	var state = get_state()
	var cast_hex = 0
	if set_state!=null:
		cast_hex=45
		state=set_state
		local = false
	
	var costs = {
		'gold': globals.card_instances[state['building_card']].get_node('Card').cost_gold,
		'faeria':globals.card_instances[state['building_card']].get_node('Card').cost_faeria
	}
	var play_effect = null
	if players[state['current_turn']].pay_costs(costs['gold'],costs['faeria']):
		## replcae with actual board entity
		var child_card = globals.card_instances[state['building_card']].get_node('Card')
		if local:
			players[state['current_turn']].discard_by_name(state['building_card'])
		else:
			players[state['current_turn']].set_hand_cards(players[state['current_turn']].hand_cards-1)
		var entity = BoardEntity.instance()
		get_hex_by_id(cast_hex).get_node('hexEntity').add_child(entity)
		play_effect = entity.possess(child_card.board_entity,get_hex_by_id(cast_hex),state['current_turn'],self)
		entity.Owner = state['current_turn']
		entity.add_to_group('entities')
	if local:
		send_action('castAny', 45-cast_hex,{'current_turn':(state['current_turn']+1%2),'building_card':state['building_card']})
	
	if play_effect==null:
		actionDone()
	else:
		actionReady=true

func buildAny(target, set_state=null):
	var local = true
	var state = get_state()
	if set_state!=null:
		
		state=set_state
		local = false
	
	var costs = {
		'gold': globals.card_instances[state['building_card']].get_node('Card').cost_gold,
		'faeria':globals.card_instances[state['building_card']].get_node('Card').cost_faeria
	}
	
	if players[state['current_turn']].pay_costs(costs['gold'],costs['faeria']):
		## replcae with actual board entity
		var child_card = globals.card_instances[state['building_card']].get_node('Card')
		if local:
			players[state['current_turn']].discard_hand(building_card_ind)
		else:
			## remove 1 card from enemy hand counter
			pass
		var entity = BoardEntity.instance()
		get_hex_by_id(target).get_node('hexEntity').add_child(entity)
		entity.possess(child_card.board_entity,get_hex_by_id(target),state['current_turn'],self)
		entity.Owner = state['current_turn']
		entity.add_to_group('entities')
	if local:
		send_action('buildAny', 45-target,{'current_turn':(state['current_turn']+1%2),'building_card':state['building_card']})
	actionDone()

func buildLake(target, set_state=null):
	var local = true
	var state = get_state()
	if set_state!=null:
		
		state=set_state
		local = false
	
	var costs = {
		'gold': globals.card_instances[state['building_card']].get_node('Card').cost_gold,
		'faeria':globals.card_instances[state['building_card']].get_node('Card').cost_faeria
	}
	
	if players[state['current_turn']].pay_costs(costs['gold'],costs['faeria']):
		## replcae with actual board entity
		var child_card = globals.card_instances[state['building_card']].get_node('Card')
		if local:
			players[state['current_turn']].discard_hand(building_card_ind)
		else:
			## remove 1 card from enemy hand counter
			pass
		var entity = BoardEntity.instance()
		get_hex_by_id(target).get_node('hexEntity').add_child(entity)
		entity.possess(child_card.board_entity,get_hex_by_id(target),state['current_turn'],self)
		entity.Owner = state['current_turn']
		entity.add_to_group('entities')
	if local:
		send_action('buildLake', 45-target,{'current_turn':(state['current_turn']+1%2),'building_card':state['building_card']})
	actionDone()

func buildTree(target, set_state=null):
	var local = true
	var state = get_state()
	if set_state!=null:
		
		state=set_state
		local = false
	
	var costs = {
		'gold': globals.card_instances[state['building_card']].get_node('Card').cost_gold,
		'faeria':globals.card_instances[state['building_card']].get_node('Card').cost_faeria
	}
	
	if players[state['current_turn']].pay_costs(costs['gold'],costs['faeria']):
		## replcae with actual board entity
		var child_card = globals.card_instances[state['building_card']].get_node('Card')
		if local:
			players[state['current_turn']].discard_hand(building_card_ind)
		else:
			## remove 1 card from enemy hand counter
			pass
		var entity = BoardEntity.instance()
		get_hex_by_id(target).get_node('hexEntity').add_child(entity)
		entity.possess(child_card.board_entity,get_hex_by_id(target),state['current_turn'],self)
		entity.Owner = state['current_turn']
		entity.add_to_group('entities')
	if local:
		send_action('buildTree', 45-target,{'current_turn':(state['current_turn']+1%2),'building_card':state['building_card']})
	actionDone()

func buildHill(target, set_state=null):
	var local = true
	var state = get_state()
	if set_state!=null:
		
		state=set_state
		local = false
	
	var costs = {
		'gold': globals.card_instances[state['building_card']].get_node('Card').cost_gold,
		'faeria':globals.card_instances[state['building_card']].get_node('Card').cost_faeria
	}
	
	if players[state['current_turn']].pay_costs(costs['gold'],costs['faeria']):
		## replcae with actual board entity
		var child_card = globals.card_instances[state['building_card']].get_node('Card')
		if local:
			players[state['current_turn']].discard_hand(building_card_ind)
		else:
			## remove 1 card from enemy hand counter
			pass
		var entity = BoardEntity.instance()
		get_hex_by_id(target).get_node('hexEntity').add_child(entity)
		entity.possess(child_card.board_entity,get_hex_by_id(target),state['current_turn'],self)
		entity.Owner = state['current_turn']
		entity.add_to_group('entities')
	if local:
		send_action('buildHill', 45-target,{'current_turn':(state['current_turn']+1%2),'building_card':state['building_card']})
	actionDone()

func buildSand(target, set_state=null):
	var local = true
	var state = get_state()
	if set_state!=null:
		
		state=set_state
		local = false
	
	var costs = {
		'gold': globals.card_instances[state['building_card']].get_node('Card').cost_gold,
		'faeria':globals.card_instances[state['building_card']].get_node('Card').cost_faeria
	}
	
	if players[state['current_turn']].pay_costs(costs['gold'],costs['faeria']):
		## replcae with actual board entity
		var child_card = globals.card_instances[state['building_card']].get_node('Card')
		if local:
			players[state['current_turn']].discard_hand(building_card_ind)
		else:
			## remove 1 card from enemy hand counter
			pass
		var entity = BoardEntity.instance()
		get_hex_by_id(target).get_node('hexEntity').add_child(entity)
		entity.possess(child_card.board_entity,get_hex_by_id(target),state['current_turn'],self)
		entity.Owner = state['current_turn']
		entity.add_to_group('entities')
	if local:
		send_action('buildSand', 45-target,{'current_turn':(state['current_turn']+1%2),'building_card':state['building_card']})
	actionDone()

func actionLand(target, set_state=null):
	var local = true
	if not set_state==null:
		var state=set_state
		local = false
	
	if (players[state['current_turn']].useAction(1)):
		get_hex_by_id(target).affectState({'hex_type':2}, state['current_turn'])
		players[state['current_turn']].modLands('land',1)
	if local:
		send_action('actionLand', 45-target,{'empty':true, 'current_turn':(state['current_turn']+1)%2})
	actionDone()

func actionLake(target, set_state=null):
	var local = true
	if not set_state==null:
		var state=set_state
		local = false
	if (players[state['current_turn']].useAction(1)):
		get_hex_by_id(target).affectState({'hex_type':3}, state['current_turn'])
		players[state['current_turn']].modLands('lake',1)
	if local:
		send_action('actionLake', 45-target,{'empty':true,'current_turn':(state['current_turn']+1)%2})
	actionDone()

func actionTree(target, set_state=null):
	var local = true
	if not set_state==null:
		var state=set_state
		local = false
	if (players[state['current_turn']].useAction(1)):
		get_hex_by_id(target).affectState({'hex_type':4}, state['current_turn'])
		players[state['current_turn']].modLands('tree',1)
	if local:
		send_action('actionTree', 45-target,{'empty':true, 'current_turn':(state['current_turn']+1)%2})
	actionDone()

func actionHill(target, set_state=null):
	var local = true
	if not set_state==null:
		var state=set_state
		local = false
	if (players[state['current_turn']].useAction(1)):
		get_hex_by_id(target).affectState({'hex_type':5}, state['current_turn'])
		players[state['current_turn']].modLands('hill',1)
	if local:
		send_action('actionHill', 45-target,{'empty':true, 'current_turn':(state['current_turn']+1)%2})
	actionDone()

func actionSand(target, set_state=null):
	var local = true
	if not set_state==null:
		var state=set_state
		local = false
	if (players[state['current_turn']].useAction(1)):
		get_hex_by_id(target).affectState({'hex_type':6}, state['current_turn'])
		players[state['current_turn']].modLands('sand',1)
	if local:
		send_action('actionSand', 45-target,{'empty':true, 'current_turn':(state['current_turn']+1)%2})
	actionDone()

func actionCoin(target, set_state=null):
	var local = true
	if not set_state==null:
		var state=set_state
		local = false
	print('coin')
	if (players[state['current_turn']].useAction(1)):
		print('coin 2')
		players[state['current_turn']].modCoin(1)
		complete=true
	if local:
		send_action('actionCoin', 0,{'empty':true, 'current_turn':(state['current_turn']+1)%2})
	actionDone()

func actionCard(target, set_state=null):
	var local = true
	if not set_state==null:
		var state=set_state
		local = false
	if players[state['current_turn']].cards>0:
		if (players[state['current_turn']].useAction(1)):
			players[state['current_turn']].drawCard()
			complete=true
	if local:
		send_action('actionCard', 0,{'empty':true, 'current_turn':(state['current_turn']+1)%2})
	actionDone()


func delegate(target, set_state=null):
	var local = true
	var state = get_state()
	print(set_state)
	if set_state!=null:
		state=set_state
		local= false
	print(state)
	if (get_hex_by_id(state['delegate_id']).get_unit().get_node(state['delegate_node']).complete(target, set_state)):
		actionDone()

###############
### MESSAGE FUNCTIONS

func send_action(type,target, loc_state):
	var send = {'game_action':{
		'player':global_player_num,
		'type':type,
		'target':target,
		'state':loc_state
	}}
	print(send)
	var jsn = to_json(send)
	var nojsn = parse_json(jsn)
	globals.send_msg(send)

func deck_cards(val):
	players[1].deck_init(val)

func game_action(val):
	print("TO ACTION")
	call(val.type, val.target, val.state)
	print("END STATE")
	print(state)

##
#HELPERS
func get_hex_by_id(id):
	for hex in get_tree().get_nodes_in_group("Hex"):
		if hex.id == id:
			return hex

func get_unit_by_hex(hex):
	return hex.get_unit()

""" added instances to globals
func get_card_properties_by_name(card,props):
	var card_instance = globals.card_resources[name].instance()
	var ret = {}
	for prop in props:
		ret[prop] = card[prop]
	card_instance.queue_free()
	return ret
"""

##DISPLAY FRAME

func set_displayframe(card):
	$DisplayFrame.empty()
	$DisplayFrame.show()
	$DisplayFrame.set_card(card)

func hide_displayframe():
	$DisplayFrame.empty()
	$DisplayFrame.hide()

var temp_card
func cast_from_hand(card_node):
	## CHECK COSTS
	var card_name = card_node.get_node('Card').card_name
	set_state({'building_Card':card_name})
	castAny(0)






#### VERFIFICATIONS

func check_valid_action(action):
	var targets = false
	for hex in get_tree().get_nodes_in_group('Hex'):
		if hex.action(action,state['current_turn'],true):
			targets = true
	print("IS VALID ACTION:")
	print(targets)
	return targets


func startTimer():
	#actionTimer.wait_time=0.4
	actionTimer.start()

var can_do = true
func startBasictimeout():
	can_do = false
	set_process_input(false)
	$basic_timeout.start()

func _on_Timer_timeout():
	print('TIMER')
	if complete:
		actionReady=true
	else:
		startTimer()


func _on_endturn_pressed():
	change_turns(1,2)


func _on_basic_timeout_timeout():
	can_do=true
	set_process_input(true)
