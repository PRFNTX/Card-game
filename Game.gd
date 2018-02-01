
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

func setState(obj):
	for key in obj.keys():
		state[key]=obj[key]
		#call 'setters' instead?
	emit_signal("UpdateState",state)

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

func completeAction(target):
	call(state["action"],target)
	setState({"action":""})
	complete = true

func cancelAction():
	setState({"action":""})
	complete = true


##ACTIONS

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
		players[state['current_turn']].addCoin(1)
		complete=true

func actionCard():
	if (players[state['current_turn']].useAction(1)):
		players[state['current_turn']].drawCard()
		complete=true

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
