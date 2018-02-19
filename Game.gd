
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"


var testing_solo = false

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

signal on_action

var players = [null, null]

var global_player_num = 0

func set_player(val):
	global_player_num = val
	setState({'current_turn':val})



###### current_turn will be set to 0 during local players turn and 1 during remote players turn
var state={"action":"", 'current_turn':0,'active_unit':null,'clock_time':0,'hovered':null,'building_card':null, 'delegate_id':null,'delegate_node':null, 'frame_card':null,'preview_card':null}

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

var buttons=[]
func frame_card(card_name):
	complete = true
	if card_name !=null:
		#startTimer()
		state['frame_card'] = card_name
		for child in $DisplayFrame.get_children():
			child.queue_free()
			buttons = []
		$DisplayFrame.add_child(globals.card_resources[card_name].instance())
		if state['active_unit']!=null:
			var framed_entity = get_hex_by_id(state['active_unit']).get_unit()
			var num=0
			for ability in framed_entity.Unit.get_actions().keys():
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
			buttons = [Button.new()]
			$DisplayFrame.add_child(buttons.back())
			buttons[0].text='cast'
			var c_instance = globals.card_instances[card_name].get_node('Card')
			var f_cost = c_instance.cost_faeria
			var g_cost = c_instance.cost_gold
			var l_cost = {c_instance.lands_type:c_instance.lands_num}
			if !players[state['current_turn']].has_resource(g_cost,f_cost,l_cost):
				buttons[0].disabled = true
			#buttons[0].name = 'cast'
			
			buttons[0].connect('pressed', self, 'frame_activate', ['cast'])
	else:
		for child in $DisplayFrame.get_children():
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
		if local:
			send_action('frame_activate', ability_name ,{'frame_card':globals.get_id_by_name(state['frame_card']),'current_turn':(state['current_turn']+1)%2})
			
		if this_unit.possess(to_instance, get_hex_by_id(0), state['current_turn'], self,state['frame_card'])==null:
			players[state['current_turn']].discard_selected() #make this function
			this_unit.queue_free()
			actionDone()
		
	else:
		get_hex_by_id(state['active_unit']).get_unit().activate(ability_name) #make this function
##STATE AGAIN

func delegate_id(val):
	state['delegate_id'] = val

func delegate_node(path):
	state['delegate_node'] = path

func preview_card(card_name):
	state['preview_card'] = card_name
	if globals.card_resources.keys().has(card_name):
		for child in $PreviewFrame.get_children():
			child.queue_free()
	
		$PreviewFrame.add_child(globals.card_resources[card_name].instance())

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

func change_turns(none,unused):
	if state['current_turn'] == 0:
		send_action('change_turns',0,{'empty':true})
	print('changing turns')
	cancelAction()
	emit_signal("TurnEnd", state['current_turn'])
	var current_time = state['clock_time']
	###TESTING
	if testing_solo:
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
		#get_hex_by_id(state['delegate_id']).get_unit().Unit.get_node(state['delegate_node']).targeting()
		var unit =get_hex_by_id(state['delegate_id']).get_unit().Unit
		unit.get_node(state['delegate_node']).targeting()

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
	setState({"action":"",'active_unit':null, 'frame_card':null, 'delegate_id':null,"delegate_node":null,'building_card':null})
	if $hex0.has_unit():
		$hex0.get_unit().queue_free()
		print("SHOULD I HAVE FREED THAT? (Game:330)")
	complete = true

func newAction(set={'action':""}):
	actionReady=true
	setState(set)

func cancelAction():
	
	if state['action']=='delegate' and get_hex_by_id(state['delegate_id']).get_unit().Unit.get_node(state['delegate_node']).has_method('cancel_action'):
		get_hex_by_id(state['delegate_id']).get_unit().Unit.get_node(state['delegate_node']).cancel_action()
	setState({"action":"",'active_unit':null, 'frame_card':null, 'delegate_id':null,'delegate_node':null})
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

func miscMove(target,set_state=null):
	var local = false
	var state = get_state()
	if set_state!=null:
		state=set_state
	
	var hex_target = get_hex_by_id(target)
	var unit = get_unit_by_hex(get_hex_by_id(state['active_unit']))
	unit.on_move(hex_target.get_node('hexEntity'))
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
		send_action('moveBase',45-target,{'active_unit':45-state['active_unit']})
		unit.setState({'active':false})
		setState({'active_unit':target})
	
	
	if check_valid_action(unit.Unit.get_action_name('Attack')) and unit.Unit.current_health>0:
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
	unit.use_energy(1)
	if local:
		send_action('moveAquatic',45-target,{'active_unit':45-state['active_unit']})
		unit.setState({'active':false})
		setState({'active_unit':target})
	
	
	if check_valid_action(unit.Unit.get_action_name('Attack')) and unit.Unit.current_health>0:
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
	unit.use_energy(1)
	if local:
		send_action('moveAir',45-target,{'active_unit':45-state['active_unit']})
		unit.setState({'active':false})
		setState({'active_unit':target})
	
	
	if check_valid_action(unit.Unit.get_action_name('Attack')) and unit.Unit.current_health>0: ## do this better?
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
		play_effect = entity.possess(child_card.board_entity,get_hex_by_id(cast_hex),state['current_turn'],self,child_card.card_name)
		entity.add_to_group('entities')
	if local:
		send_action('castAny', 45-cast_hex,{'current_turn':(state['current_turn']+1%2),'building_card':globals.get_id_by_name(state['building_card'])})
	
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
		entity.possess(child_card.board_entity,get_hex_by_id(target),state['current_turn'],self,child_card.card_name)
		entity.add_to_group('entities')
	if local:
		send_action('buildAny', 45-target,{'current_turn':(state['current_turn']+1%2),'building_card':globals.get_id_by_name(state['building_card'])})
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
		entity.possess(child_card.board_entity,get_hex_by_id(target),state['current_turn'],self,child_card.card_name)
		entity.add_to_group('entities')
	if local:
		send_action('buildLake', 45-target,{'current_turn':(state['current_turn']+1%2),'building_card':globals.get_id_by_name(state['building_card'])})
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
		entity.possess(child_card.board_entity,get_hex_by_id(target),state['current_turn'],self,child_card.card_name)
		entity.add_to_group('entities')
	if local:
		send_action('buildTree', 45-target,{'current_turn':(state['current_turn']+1%2),'building_card':globals.get_id_by_name(state['building_card'])})
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
		entity.possess(child_card.board_entity,get_hex_by_id(target),state['current_turn'],self,child_card.card_name)
		entity.add_to_group('entities')
	if local:
		send_action('buildHill', 45-target,{'current_turn':(state['current_turn']+1%2),'building_card':globals.get_id_by_name(state['building_card'])})
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
		entity.possess(child_card.board_entity,get_hex_by_id(target),state['current_turn'],self,child_card.card_name)
		entity.add_to_group('entities')
	if local:
		send_action('buildSand', 45-target,{'current_turn':(state['current_turn']+1%2),'building_card':globals.get_id_by_name(state['building_card'])})
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
		send_action('actionLand', 45-target,{'empty':true, 'current_turn':(state['current_turn']+1)%2})
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
		send_action('actionLake', 45-target,{'empty':true,'current_turn':(state['current_turn']+1)%2})
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
		send_action('actionTree', 45-target,{'empty':true, 'current_turn':(state['current_turn']+1)%2})
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
		send_action('actionHill', 45-target,{'empty':true, 'current_turn':(state['current_turn']+1)%2})
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
	if (get_hex_by_id(state['delegate_id']).get_unit().Unit.get_node(state['delegate_node']).complete(target, set_state)):
		actionDone()

###############
### MESSAGE FUNCTIONS

func send_action(type,target, loc_state, echo=false):
	var send = {'game_action':{
		'player':global_player_num,
		'type':type,
		'target':target,
		'state':loc_state
	}}
	print(send)
	#once sent actions are final
	if state['delegate_id']==0 and state['frame_card']:
		#players[state['current_turn']].discard_selected()
		players[state['current_turn']].play_selected()
		setState({'frame_card':null})
	
	globals.send_msg(send)
	emit_signal('on_action', send['game_action'].type, 45-int(send['game_action'].target), send['game_action'].state)
	if echo:
		game_action(send['game_action'])

func deck_cards(val):
	players[1].deck_init(val)

func game_action(val):
	print("TO ACTION")
	
	if val.state.keys().has('building_card'):
		val['state']['building_card'] = globals.get_card_by_id(val.state['building_card'])
		
	if val.state.keys().has('frame_card'):
		val.state['frame_card'] = globals.get_card_by_id(val.state['frame_card'])
		print(val.state)
		print(val['state'])
		
	if val.state.keys().has('active_unit'):
		setState({'preview_card':get_hex_by_id(val.state['active_unit']).get_unit().card_name})
	
	
	call(val.type, val.target, val.state)
	emit_signal('on_action', val.type, int(val.target), val.state)
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
	set_state({'building_Card':card_name})
	castAny(0)






#### VERFIFICATIONS

func check_valid_action(action):
	var targets = false
	for hex in get_tree().get_nodes_in_group('Hex'):
		if hex.id!=0 and hex.action(action,state['current_turn'],true):
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
