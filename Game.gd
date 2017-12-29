
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

signal UpdateState

var state={"action":""}
func _init(initial_state={}):
	state=initial_state
	pass;

func setState(obj):
	for key in obj.keys():
		state[key]=obj[key]
	emit_signal("UpdateState",state)



func _ready():
	set_process_input(true)

func _input(event):
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

func completeAction(target):
	call(state["action"],target)
	setState({"action":""})

##ACTIONS

func actionLand(target):
	target.hexType.setState(2)

func actionLake(target):
	target.hexType.setState(3)

func actionTree(target):
	target.hexType.setState(4)

func actionHill(target):
	target.hexType.setState(5)

func actionSand(target):
	target.hexType.setState(6)

