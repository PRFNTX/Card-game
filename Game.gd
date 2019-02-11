
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"


var testing_solo = true
var god_mode = true

onready var globals = get_node('/root/master')

export(PackedScene) var BoardEntity = load('res://BoardEntity.tscn')
export(PackedScene) var OrbEntity = load('res://Cards/entities/orb_entity.tscn')
export(PackedScene) var WellEntity = load('res://Cards/entities/well_entity.tscn')

#signal SpawnFaeria
signal UpdateState
signal AutoCollect
signal GameStart
signal TurnStart
signal ActionPhase
signal TurnEnd

signal on_action

signal on_collect

var players = [null, null]

var global_player_num = 0

func set_player(val):
	global_player_num = val
	setState({'current_turn':val})



###### current_turn will be set to 0 during local players turn and 1 during remote players turn
var state={
	"action":"",
	'current_turn':0,
	'active_unit':null,
	'clock_time':0,
	'hovered':null,
	'building_card':null,
	'casting_card_num': null,
	'delegate_id':null,
	'delegate_node':null,
	'frame_card':null,
	'preview_card':null
}

var actionTimer

func _init(initial_state={}):
	pass


#STATE 
func setState(obj):
	$noTargets.hide()
	if god_mode:
		players[state['current_turn']].setActions(3)
		players[state['current_turn']].setFaeria(20)
		players[state['current_turn']].setGold(20)
	for key in obj.keys():
		call(key, obj[key])
		#call 'setters' instead?
	emit_signal("UpdateState",state,obj.keys())
	emit_signal("AutoCollect")

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
	if state['active_unit']!=null:
		print('hey')
	#if !(unit_hex_id==null):
	#	var unit = get_hex_by_id(unit_hex_id).get_unit()
	#	unit.setState({'active':true})

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

func casting_card_num(val):
	state['casting_card_num'] = val

var buttons=[]
func frame_card(card_name):
	complete = true
	if card_name !=null:
		#startTimer()
		state['frame_card'] = card_name
		for child in $DisplayFrame.get_children():
			if child.get_name()!="CardDetails":
				child.queue_free()
		buttons = []
		var displayCard = globals.card_resources[card_name].instance()
		displayCard.rect_scale = Vector2(1.5, 1.5)
		$DisplayFrame.add_child(displayCard)
		if state['active_unit']!=null:
			var framed_entity = get_hex_by_id(state['active_unit']).get_unit()
			var num=0
			for ability in framed_entity.actionList:
				print(ability)
				buttons.append(Button.new())
				buttons.back().text=ability
				$DisplayFrame.add_child(buttons.back())
				if not framed_entity.actionList[ability].verify_costs():
					buttons.back().disabled=true
				#buttons.back().name=ability
				#verify costs or disable
				buttons.back().connect('pressed', self, 'frame_activate', [ability])
				buttons.back().rect_position.y+=20*num
				num+=1
		else:
			var c_instance = globals.card_instances[card_name].get_node('Card')
			var f_cost = c_instance.cost_faeria
			var g_cost = c_instance.cost_gold
			var l_cost = {c_instance.lands_type:c_instance.lands_num}
			var thing = $DisplayFrame/CardDetails
			if c_instance.is_event:
				buttons = [Button.new()]
				$DisplayFrame.add_child(buttons.back())
				buttons[0].text='cast'
				if (players[state['current_turn']].has_resource(g_cost,f_cost,l_cost)
					and (
						(displayCard.get_node('Card').play_morning and state.clock_time==0)
						or (displayCard.get_node('Card').play_evening and state.clock_time==1)
						or (displayCard.get_node('Card').play_night and state.clock_time==2)
					)
				):
					buttons[0].disabled = false
					buttons[0].connect('pressed', self, 'frame_activate', ['cast'])
				else:
					buttons[0].disabled = true
			c_instance.scale = Vector2(1.5, 1.5)
			thing.text = c_instance.card_description
			
	else:
		for child in $DisplayFrame.get_children():
			if child.get_name()!="CardDetails":
				child.queue_free()
		buttons = []

##NOT STATE
func frame_activate(ability_name, set_state=null):
	var local = true
	var state = get_state()
	if set_state!=null:
		state=set_state
		local=false
	startBasictimeout()
	if ability_name=='cast' and actionReady:
		#also activate
		var this_unit = BoardEntity.instance()
		$hex0/hexEntity.add_child(this_unit)
		this_unit.hide()
		var to_instance = globals.card_instances[state['frame_card']].get_node('Card').board_entity
		this_unit.possess(to_instance, get_hex_by_id(0), state['current_turn'], self,state['frame_card'])
		if this_unit.do_play()==null:
			players[state['current_turn']].discard_selected() #make this function
			this_unit.queue_free()
			if local:
				send_cast({'frame_card':globals.get_id_by_name(state['frame_card']),'current_turn':(state['current_turn']+1)%2})
			actionDone()
	
	elif actionReady:
		get_hex_by_id(state['active_unit']).get_unit().activate(ability_name) #make this function
		## if no valid targets end activation
		if state['action']==null or state['action']=="":
			actionDone()
		elif not get_hex_by_id(state['active_unit']).get_unit().actionList[ability_name].has_method('complete'):
			actionDone()

##STATE AGAIN

func delegate_id(val):
	state['delegate_id'] = val
	#state['active_unit'] = val

func delegate_node(path):
	state['delegate_node'] = path

func preview_card(card_name):
	state['preview_card'] = card_name
	if globals.card_resources.keys().has(card_name):
		for child in $PreviewFrame.get_children():
			if child.get_name()!='CardDetails':
				child.queue_free()
		var previewCard = globals.card_resources[card_name].instance()
		get_node('PreviewFrame/CardDetails').text = previewCard.get_node('Card').card_description
		previewCard.rect_scale = Vector2(1.5, 1.5)
		$PreviewFrame.add_child(previewCard)

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
	print(players[0])
	players[0].drawCard()
	players[0].drawCard()
	players[0].drawCard()
	players[0].drawCard()
	players[0].drawCard()
	players[0].setGold(3)
	setState({'current_turn':0})
	actionTimer = $actionTimer
	
	### spawn starting structures
	var ORB = 2
	var WELL = 8
	for hex in get_tree().get_nodes_in_group('Hex'):
		if hex.hexType.child.type==ORB:
			var starting_entity = BoardEntity.instance()
			hex.get_node('hexEntity').add_child(starting_entity)
			starting_entity.possess(OrbEntity,hex,hex.initial_owner,self,"orb")
		if hex.hexType.child.type==WELL:
			var starting_entity = BoardEntity.instance()
			hex.get_node('hexEntity').add_child(starting_entity)
			starting_entity.possess(WellEntity,hex,hex.initial_owner,self,"well")
			#starting_entity.spawn_faeria()
	
	set_player(globals.player_num)
	emit_signal('GameStart')
	emit_signal('TurnStart', state['current_turn'])
	emit_signal('ActionPhase', state['current_turn'])
	ready = true

func change_turns(none, unused):
	if state['current_turn'] == 0:
		send_action('change_turns',0,{'empty':true})
	cancelAction()
	emit_signal("TurnEnd", state['current_turn'])
	var current_time = state['clock_time']
	###TESTING
	if testing_solo:
		setState({'current_turn':(state['current_turn']+1)%1,'action':"",'active_unit':null,'clock_time':(current_time+1)%3})
	else:
		setState({'current_turn':(state['current_turn']+1)%2,'action':"",'active_unit':null,'clock_time':(current_time+1)%3})
	emit_signal("TurnStart", state['current_turn'])
	players[state.current_turn].modCoin(2)
	emit_signal("ActionPhase", state['current_turn'])
	

var actionReady = true
var complete = true
func _input(event):
	if event.is_action("cancel"):
		cancelAction()
		startTimer()
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
		#get_hex_by_id(state['delegate_id']).get_unit().Unit.get_node(state['delegate_node']).targeting()
		var unit = get_hex_by_id(state['delegate_id']).get_unit().Unit
		unit.get_node(state['delegate_node']).targeting()
		poll_for_valid_targets()

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

func resetTargeting():
	for hex in get_tree().get_nodes_in_group('Hex'):
		hex.setState({'cover':Color(0,0,0,0), 'target':false})

func completeAction(target):
	if can_do:
		call(state["action"],target.id)
		startBasictimeout()

func actionDone():
	setState({"action":"",'active_unit':null, 'frame_card':null, 'delegate_id':null,"delegate_node":null,'building_card':null,'casting_card_num':null})
	if $hex0.has_unit():
		$hex0.get_unit().queue_free()
	resetTargeting()
	complete = true

func newAction(set={'action':""}):
	actionReady=true
	setState(set)

func cancelAction():
	if state['action']=='delegate' and get_hex_by_id(state['delegate_id']).has_unit() and get_hex_by_id(state['delegate_id']).get_unit().Unit.get_node(state['delegate_node']).has_method('cancel_action'):
		get_hex_by_id(state['delegate_id']).get_unit().Unit.get_node(state['delegate_node']).cancel_action()
	setState({"action":"",'active_unit':null, 'frame_card':null,'casting_card_num':null, 'delegate_id':null,'delegate_node':null})
	if $hex0.has_unit():
		$hex0.get_unit().queue_free()
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
	unit.setState({'active':false})
	setState({'active_unit':target})
	unit.Hex=hex_target

func miscMove(target,set_state=null):
	var local = false
	var state = get_state()
	if set_state!=null:
		state=set_state
	
	var hex_target = get_hex_by_id(target)
	var unit = get_unit_by_hex(get_hex_by_id(state['active_unit']))
	unit.on_move(hex_target.get_node('hexEntity'))
	unit.setState({'active':false})
	setState({'active_unit':target})
	unit.Hex=hex_target
	unit.use_energy(1)

func moveHex(target,set_state=null):
	var local = false
	var state = get_state()
	if set_state!=null:
		state=set_state
	
	var from_hex = get_hex_by_id(state['active_unit'])
	var to_hex = get_hex_by_id(target)
	to_hex.setState({'hex_type':from_hex.stateLocal['hex_type'],'hex_owner':from_hex.stateLocal['hex_owner']})
	from_hex.setState({'hex_type':0,'hex_owner':-1})
	if from_hex.has_unit():
		from_hex.get_unit().on_move(to_hex.get_node('hexEntity'))
		from_hex.get_unit().setState({'active':false})
		setState({'active_unit':target})
	

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
	unit.use_energy(1)
	if local:
		send_action('moveBase',45-target,{'active_unit':45-state['active_unit']},state)
		unit.setState({'active':false})
		setState({'active_unit':target})
		if check_valid_action(unit.Unit.get_action_name('Attack')) and unit.Unit.current_health>0:
			actionReady=true
			unit.Unit.start_attack(self)
		else:
			actionDone()
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
	unit.use_energy(1)
	if local:
		send_action('moveWater',45-target,{'active_unit':45-state['active_unit']},state)
		unit.setState({'active':false})
		setState({'active_unit':target})
		if check_valid_action(unit.Unit.get_action_name('Attack')) and unit.Unit.current_health>0:
			actionReady=true
			unit.Unit.start_attack(self)
		else:
			actionDone()
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
	unit.use_energy(1)
	if local:
		send_action('moveAir',45-target,{'active_unit':45-state['active_unit']},state)
		unit.setState({'active':false})
		setState({'active_unit':target})
		if check_valid_action(unit.Unit.get_action_name('Attack')) and unit.Unit.current_health>0: ## do this better?
			actionReady=true
			unit.Unit.start_attack(self)
		else:
			actionDone()
	else:
		actionDone()

func AttackAdjOrCollect(target, set_state=null):
	var local = true
	var state = get_state()
	if not set_state==null:
		state.active_unit = set_state.active_unit #for collect
		state=set_state
		local= false
	var unit = get_unit_by_hex(get_hex_by_id(state['active_unit']))
	unit.on_attack(get_hex_by_id(target).get_node('hexEntity').get_node('BoardEntity'))
	if local:
		send_action('AttackAdjOrCollect',45-target,{'active_unit':45-state['active_unit']},state)
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
		send_action('AttackAdj',45-target,{'active_unit':45-state['active_unit']},state)
		unit.setState({'active':false})
	actionDone()

func Collect(target, set_state=null):
	var local = true
	var state= get_state()
	if not set_state==null:
		state.active_unit = set_state.active_unit #for collect
		state=set_state
		local = false
	var unit = get_unit_by_hex(get_hex_by_id(state['active_unit']))
	unit.on_attack(target.get_node('hexEntity').get_child())
	if local:
		send_action('Collect',45-target,{'active_unit':45-state['active_unit']},state)
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
		play_effect = entity.possess(child_card.board_entity,get_hex_by_id(cast_hex),state['current_turn'],self,child_card.card_name)
		entity.add_to_group('entities')
	if local:
		send_action('castAny', 45-cast_hex,{'current_turn':(state['current_turn']+1%2),'building_card':globals.get_id_by_name(state['building_card'])}, state)
	
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
	var end_if_null
	if players[state['current_turn']].pay_costs(costs['gold'],costs['faeria']):
		## replcae with actual board entity
		var child_card = globals.card_instances[state['building_card']].get_node('Card')
		var entity = BoardEntity.instance()
		get_hex_by_id(target).get_node('hexEntity').add_child(entity)
		entity.possess(child_card.board_entity,get_hex_by_id(target),state['current_turn'],self,child_card.card_name)
		if local:
			players[state['current_turn']].discard_hand(building_card_ind)
			send_action('buildAny', 45-target,{'current_turn':(state['current_turn']+1%2),'building_card':globals.get_id_by_name(state['building_card'])},state)
		else:
			## remove 1 card from enemy hand counter
			pass
		actionDone()
		newAction()
		end_if_null = entity.do_play()
		entity.add_to_group('entities')
	else:
		end_if_null = null
	if local:
		if end_if_null == null:
			actionDone()
	else:
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
	var end_if_null
	if players[state['current_turn']].pay_costs(costs['gold'],costs['faeria']):
		## replace with actual board entity
		var child_card = globals.card_instances[state['building_card']].get_node('Card')
		var entity = BoardEntity.instance()
		get_hex_by_id(target).get_node('hexEntity').add_child(entity)
		entity.possess(child_card.board_entity,get_hex_by_id(target),state['current_turn'],self,child_card.card_name)
		if local:
			players[state['current_turn']].discard_hand(building_card_ind)
			send_action(
				'buildLake',
				45-target,
				{'current_turn':(state['current_turn']+1%2),'building_card':globals.get_id_by_name(state['building_card'])},
				state
			)
		else:
			## remove 1 card from enemy hand counter
			pass
		actionDone()
		newAction()
		end_if_null = entity.do_play()
		entity.add_to_group('entities')
	else:
		end_if_null = null
	if local:
		if end_if_null == null:
			actionDone()
	else:
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
	var end_if_null
	if players[state['current_turn']].pay_costs(costs['gold'],costs['faeria']):
		## replcae with actual board entity
		var child_card = globals.card_instances[state['building_card']].get_node('Card')
		var entity = BoardEntity.instance()
		get_hex_by_id(target).get_node('hexEntity').add_child(entity)
		entity.possess(child_card.board_entity,get_hex_by_id(target),state['current_turn'],self,child_card.card_name)
		if local:
			players[state['current_turn']].discard_hand(building_card_ind)
			send_action('buildTree', 45-target,{'current_turn':(state['current_turn']+1%2),'building_card':globals.get_id_by_name(state['building_card'])},state)
		else:
			## remove 1 card from enemy hand counter
			pass
		actionDone()
		newAction()
		end_if_null = entity.do_play()
		entity.add_to_group('entities')
	else:
		end_if_null = null
	if local:
		if end_if_null == null:
			actionDone()
	else:
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
	var end_if_null
	if players[state['current_turn']].pay_costs(costs['gold'],costs['faeria']):
		## replcae with actual board entity
		var child_card = globals.card_instances[state['building_card']].get_node('Card')
		var entity = BoardEntity.instance()
		get_hex_by_id(target).get_node('hexEntity').add_child(entity)
		entity.possess(child_card.board_entity,get_hex_by_id(target),state['current_turn'],self,child_card.card_name)
		if local:
			players[state['current_turn']].discard_hand(building_card_ind)
			send_action('buildHill', 45-target,{'current_turn':(state['current_turn']+1%2),'building_card':globals.get_id_by_name(state['building_card'])},state)
		else:
			## remove 1 card from enemy hand counter
			pass
		actionDone()
		newAction()
		end_if_null = entity.do_play()
		entity.add_to_group('entities')
	else:
		end_if_null = null
	if local:
		if end_if_null == null:
			actionDone()
	else:
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
	var end_if_null
	if players[state['current_turn']].pay_costs(costs['gold'],costs['faeria']):
		## replcae with actual board entity
		var child_card = globals.card_instances[state['building_card']].get_node('Card')
		var entity = BoardEntity.instance()
		get_hex_by_id(target).get_node('hexEntity').add_child(entity)
		end_if_null = entity.possess(child_card.board_entity,get_hex_by_id(target),state['current_turn'],self,child_card.card_name)
		if local:
			players[state['current_turn']].discard_hand(building_card_ind)
			send_action('buildSand', 45-target,{'current_turn':(state['current_turn']+1%2),'building_card':globals.get_id_by_name(state['building_card'])},state)
		else:
			## remove 1 card from enemy hand counter
			pass
		actionDone()
		newAction()
		end_if_null = entity.do_play()
		entity.add_to_group('entities')
	else:
		end_if_null = null
	if local:
		if end_if_null == null:
			actionDone()
	else:
		actionDone()

func actionLand(target, set_state=null):
	var local = true
	if not set_state==null:
		var state=set_state
		local = false
	
	if (players[state['current_turn']].useAction(1)):
		get_hex_by_id(target).setState({'hex_type':2,'hex_owner':state['current_turn']})
		#t_turn']].modLands('land',1)
		update_lands_owned()
	if local:
		send_action('actionLand', 45-target,{'empty':true, 'current_turn':(state['current_turn']+1)%2},state)
	actionDone()

func actionLake(target, set_state=null):
	var local = true
	if not set_state==null:
		var state=set_state
		local = false
	if (players[state['current_turn']].useAction(1)):
		get_hex_by_id(target).setState({'hex_type':3,'hex_owner':state['current_turn']})
		#players[state['current_turn']].modLands('lake',1)
		update_lands_owned()
	if local:
		send_action('actionLake', 45-target,{'empty':true,'current_turn':(state['current_turn']+1)%2},state)
	actionDone()

func actionTree(target, set_state=null):
	var local = true
	if not set_state==null:
		var state=set_state
		local = false
	if (players[state['current_turn']].useAction(1)):
		get_hex_by_id(target).setState({'hex_type':4,'hex_owner':state['current_turn']})
		#players[state['current_turn']].modLands('tree',1)
		update_lands_owned()
	if local:
		send_action('actionTree', 45-target,{'empty':true, 'current_turn':(state['current_turn']+1)%2},state)
	actionDone()

func actionHill(target, set_state=null):
	var local = true
	if not set_state==null:
		var state=set_state
		local = false
	if (players[state['current_turn']].useAction(1)):
		get_hex_by_id(target).setState({'hex_type':5,'hex_owner':state['current_turn']})
		#players[state['current_turn']].modLands('hill',1)
		update_lands_owned()
	if local:
		send_action('actionHill', 45-target,{'empty':true, 'current_turn':(state['current_turn']+1)%2},state)
	actionDone()

func actionSand(target, set_state=null):
	var local = true
	if not set_state==null:
		var state=set_state
		local = false
	if (players[state['current_turn']].useAction(1)):
		get_hex_by_id(target).setState({'hex_type':6,'hex_owner':state['current_turn']})
		#players[state['current_turn']].modLands('sand',1)
		update_lands_owned()
	if local:
		send_action('actionSand', 45-target,{'empty':true, 'current_turn':(state['current_turn']+1)%2},state)
	actionDone()

func actionCoin(target, set_state=null):
	var local = true
	if not set_state==null:
		var state=set_state
		local = false
	if (players[state['current_turn']].useAction(1)):
		players[state['current_turn']].modCoin(1)
		complete=true
	if local:
		send_action('actionCoin', 0,{'empty':true, 'current_turn':(state['current_turn']+1)%2},state)
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
		send_action('actionCard', 0,{'empty':true, 'current_turn':(state['current_turn']+1)%2},state)
	actionDone()


func delegate(target, set_state=null):
	var local = true
	var state = get_state()
	var this_unit
	if set_state!=null:
		#state=set_state
		local= false
	if not local and set_state.delegate_id == 0:
		this_unit = BoardEntity.instance()
		$hex0/hexEntity.add_child(this_unit)
		this_unit.hide()
		var to_instance = globals.card_instances[set_state['frame_card']].get_node('Card').board_entity.duplicate()
		this_unit.possess(to_instance, get_hex_by_id(0), state['current_turn'], self,set_state['frame_card'])
		var result = get_hex_by_id(set_state['delegate_id']).get_unit().Unit.get_node(set_state['delegate_node']).complete(target, set_state)
		actionDone()
	else:
		if not local:
			state = set_state
		var result = get_hex_by_id(state['delegate_id']).get_unit().Unit.get_node(state['delegate_node']).complete(target, set_state)
		if result == null or result:
			actionDone()

###############
### MESSAGE FUNCTIONS

func send_cast(send_state, cancel=false):
	var send = {'game_cast':{
		'player':global_player_num,
		'type':'cast',
		'state':send_state,
		'cancel': cancel
	}}
	#once sent, actions are final
	if state['delegate_id']==0 and state['frame_card']:
		#players[state['current_turn']].discard_selected()
		players[state['current_turn']].play_selected()
		setState({'frame_card':null})
	elif state['casting_card_num'] != null:
		pass
	
	globals.send_msg(send)
	emit_signal('on_action', 'cast', 0, state)

func send_action(type, target, loc_state, true_state=null, echo=false):
	var send = {'game_action':{
		'player':global_player_num,
		'type':type,
		'target':target,
		'state':loc_state
	}}
	#once sent, actions are final
	if state['delegate_id']==0 and state['frame_card']:
		#players[state['current_turn']].discard_selected()
		players[state['current_turn']].play_selected()
		setState({'frame_card':null})
	
	globals.send_msg(send)
	emit_signal('on_action', send['game_action'].type, 45-target, true_state)
	if echo:
		game_action(send['game_action'])

func send_activation(hex, relative_path):
	var send = {'game_activation':{
		'hex': hex,
		'node': relative_path,
	}}

func deck_cards(val):
	players[1].deck_init(val)

func game_cast(val):
	if val.cancel:
		cancelAction()
	frame_activate('cast', val.state)

func game_action(val):
	print("TO ACTION")
	
	if val.state.keys().has('building_card'):
		val['state']['building_card'] = globals.get_card_by_id(val.state['building_card'])
		
	if val.state.keys().has('frame_card'):
		setState({'preview_card':val.state.frame_card})
		
	if val.state.keys().has('active_unit') and get_hex_by_id(val.state['active_unit']).has_unit():
		setState({'preview_card':get_hex_by_id(val.state['active_unit']).get_unit().card_name})
	
	call(val.type, val.target, val.state)
	emit_signal('on_action', val.type, int(val.target), val.state)

func game_activation(val):
	if val.state.keys().has('frame_card'):
		val.state['frame_card'] = globals.get_card_by_id(val.state['frame_card'])
		setState({'frame_card': val.state['frame-card']})
	var entity = get_hex_by_id(val.hex).get_unit()
	entity.Unit.get_node(val.node).activate(self, entity, null)

##
#HELPERS
func get_hex_by_id(id):
	for hex in get_tree().get_nodes_in_group("Hex"):
		if hex.id == id:
			return hex

func get_unit_by_hex(hex):
	return hex.get_unit()
	

#land, lake, tree, hill, sand
func update_lands_owned():
	var mods = [{0:0,1:0,2:0,3:0,4:0},{0:0,1:0,2:0,3:0,4:0}]
	for hex in get_tree().get_nodes_in_group('Hex'):
		if hex.stateLocal['hex_owner']>=0 and hex.stateLocal['hex_type']>1 and hex.stateLocal['hex_type']<7:
			mods[hex.stateLocal['hex_owner']][hex.stateLocal['hex_type']-2]+=1
	players[0].setLands(mods[0])
	players[1].setLands(mods[1])
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
	setState({'building_Card':card_name})
	castAny(0)


#### VERFIFICATIONS

func check_valid_action(action):
	var targets = false
	var unit
	for hex in get_tree().get_nodes_in_group('Hex'):
		if hex.id!=0 and hex.action(action,state['current_turn'], true):
			targets = true
	if not targets:
		no_valid_targets()
		pass
	return targets

func poll_for_valid_targets():
	for hex in get_tree().get_nodes_in_group('Hex'):
		if hex.stateLocal.target:
			return
	print('no target')
	no_valid_targets()

func no_valid_targets():
	cancelAction()
	$noTargets.show()

func startTimer():
	#actionTimer.wait_time=0.4
	actionTimer.start()

var can_do = true
func startBasictimeout():
	can_do = false
	set_process_input(false)
	$basic_timeout.start()

func _on_Timer_timeout():
	if complete:
		actionReady=true
	else:
		startTimer()


func _on_endturn_pressed():
	change_turns(1,2)


func _on_basic_timeout_timeout():
	can_do=true
	set_process_input(true)
