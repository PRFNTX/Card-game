
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

signal UpdateState
signal TurnStart
signal ActionPhase
signal TurnEnd
var players = [null, null]
var state={"action":"", 'current_turn':players[0]}

func _init(initial_state={}):
	pass

func setState(obj):
	print(state)
	for key in obj.keys():
		state[key]=obj[key]
		#call 'setters' instead?
	emit_signal("UpdateState",state)



func _ready():
	set_process_input(true)
	var res_playerObject = load('res://PlayerObject.tscn')
	var p1 = res_playerObject.instance()
	p1.onCreate(self)
	var p2 = res_playerObject.instance()
	p2.onCreate(self)
	players[0]=p1
	players[1]=p2
	setState({'current_turn':players[0]})

func _input(event):
	if state['current_turn'].actions>0:
		if event.is_action("card"):
			pass
		if event.is_action("land"):
			setState({"action":"actionLand"})
		if event.is_action("tree"):
			setState({"action":"actionTree"})
		if event.is_action("lake"):
			setState({"action":"actionLake"})
		if event.is_action("hill"):
			setState({"action":"actionHill"})
		if event.is_action("sand"):
			setState({"action":"actionSand"})
		if event.is_action("coin"):
			pass
		if event.is_action("cancel"):
			cancelAction()

func completeAction(target):
	call(state["action"],target)
	setState({"action":""})

func cancelAction():
	setState({"action":""})

##ACTIONS

func actionLand(target):
	if (state['current_turn'].useAction(1)):
		target.hexType.setState(2)

func actionLake(target):
	if (state['current_turn'].useAction(1)):
		target.hexType.setState(3)

func actionTree(target):
	if (state['current_turn'].useAction(1)):
		target.hexType.setState(4)

func actionHill(target):
	if (state['current_turn'].useAction(1)):
		target.hexType.setState(5)

func actionSand(target):
	if (state['current_turn'].useAction(1)):
		target.hexType.setState(6)

func actionCoin():
	if (state['current_turn'].useAction(1)):
		state['current_turn'].addCoin(1)

func actionCard():
	if (state['current_turn'].useAction(1)):
		state['current_turn'].addCard()