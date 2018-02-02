
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"
onready var globals = get_node('/root/master')
signal UpdateState
signal GameStart
signal TurnStart
signal ActionPhase
signal TurnEnd

var players = [null, null]
var state={"action":"", 'current_turn':0}

var actionTimer

func _init(initial_state={}):
	pass


#STATE 
func setState(obj):
	for key in obj.keys():
		call(key, obj[key])
		#call 'setters' instead?
	emit_signal("UpdateState",state)

######## STATE FUNCTIONS
func action(val):
	state['action'] = val

func current_turn(val):
	state['current_turn'] = val
	$Hand.assign_player(players[val])
	players[val].hand_object=$Hand



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
	p.Deck = globals.Deck
	return p

func _ready():
	set_process_input(true)
	
	players[0]=create_player(0)
	players[1]=create_player(1)
	
	$Hand.assign_player(players[0])
	players[0].hand_object=$Hand
	
	setState({'current_turn':0})
	actionTimer = $actionTimer
	emit_signal('GameStart')
	emit_signal('TurnStart', state['current_turn'])
	emit_signal('ActionPhase', state['current_turn'])

func change_turns():
	emit_signal("TurnEnd", state['current_turn'])
	setState({'current_turn':(state['current_turn']+1)%2})
	emit_signal("TurnStart", state['current_turn'])
	emit_signal("ActionPhase", state['current_turn'])
	

var actionReady = true
var complete = true
func _input(event):
	
	if players[state['current_turn']].actions>0 and actionReady:
		if event.is_action("card"):
			actionReady=false
			complete = false
			startTimer()
			actionCard()
		if event.is_action("land"):
			actionReady=false
			complete = false
			startTimer()
			setState({"action":"actionLand"})
		if event.is_action("tree"):
			actionReady=false
			complete = false
			startTimer()
			setState({"action":"actionTree"})
		if event.is_action("lake"):
			actionReady=false
			complete = false
			startTimer()
			setState({"action":"actionLake"})
		if event.is_action("hill"):
			actionReady=false
			complete = false
			startTimer()
			setState({"action":"actionHill"})
		if event.is_action("sand"):
			actionReady=false
			complete = false
			startTimer()
			setState({"action":"actionSand"})
		if event.is_action("coin"):
			actionReady=false
			complete = false
			startTimer()
			actionCoin()
	elif event.is_action("cancel"):
		cancelAction()
		startTimer()

var building_card_ind
var building_card

#func get_hand_card(ind):
#	return players[state['current_turn']].Hand[ind]

func start_build_action(gold, faeria, lands,card_num, card, buildType):
	if actionReady and players[state['current_turn']].has_resource(gold,faeria,lands):
		building_card = card
		building_card_ind = card_num
		actionReady=false
		complete=false
		startTimer()
		setState({'action':buildType})

func completeAction(target):
	call(state["action"],target)
	setState({"action":""})
	complete = true

func cancelAction():
	setState({"action":""})
	complete = true


##ACTIONS

func buildAny(target):
	
	var costs = {
		'gold':building_card.get_node('Card').cost_gold,
		'faeria':building_card.get_node('Card').cost_faeria
	}
	
	if players[state['current_turn']].pay_costs(costs['gold'],costs['faeria']):
		## replcae with actual board entity
		var child_card = building_card.get_node('Card')
		building_card.remove_child(child_card)
		building_card.queue_free()
		players[state['current_turn']].discard_hand(building_card_ind)
		target.get_node('hexEntity').add_child(child_card)
		target.get_node('hexEntity').show()
		child_card.position = target.get_node('hexEntity/pos').position
		child_card.scale = Vector2(0.15,0.15)

func actionLand(target):
	if (players[state['current_turn']].useAction(1)):
		target.affectState({'hex_type':2}, state['current_turn'])

func actionLake(target):
	if (players[state['current_turn']].useAction(1)):
		target.affectState({'hex_type':3}, state['current_turn'])

func actionTree(target):
	if (players[state['current_turn']].useAction(1)):
		target.affectState({'hex_type':4}, state['current_turn'])

func actionHill(target):
	if (players[state['current_turn']].useAction(1)):
		target.affectState({'hex_type':5}, state['current_turn'])

func actionSand(target):
	if (players[state['current_turn']].useAction(1)):
		target.affectState({'hex_type':6}, state['current_turn'])

func actionCoin():
	print('coin')
	if (players[state['current_turn']].useAction(1)):
		print('coin 2')
		players[state['current_turn']].modCoin(1)
		complete=true

func actionCard():
	if players[state['current_turn']].cards>0:
		if (players[state['current_turn']].useAction(1)):
			players[state['current_turn']].drawCard()
			complete=true

func actionPlayCard(gold,faeria):
	#change hex entity
	pass

func startTimer():
	#actionTimer.wait_time=0.4
	actionTimer.start()

func _on_Timer_timeout():
	print('TIMER')
	if complete:
		actionReady=true
	else:
		startTimer()


func _on_endturn_pressed():
	change_turns()
