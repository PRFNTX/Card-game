
extends Node2D

var GameNode

var watch_state=[
	'current_turn'
]

var local_state={'active':null}

var actions = 3
var gold = 0
var faeria = 0

onready var lbl_cards = $box.get_node('cards')
onready var lbl_actions = $box.get_node('actions')
onready var lbl_gold = $box.get_node('gold')
onready var lbl_faeria = $box.get_node('faeria')

func _ready():
	
	pass

func onCreate(node):
	GameNode=node
	node.connect("TurnStart",self,"sig_TurnStart")
	node.connect("ActionPhase",self,"sig_ActionPhase")
	node.connect("TurnEnd",self,"sig_TurnEnd")
	node.connect("UpdateState",self,"state_update")
	

func sig_TurnStart():
	pass

func sig_ActionPhase():
	pass

func sig_TurnEnd():
	pass

func state_update(newState):
	print(newState)
	for check in watch_state:
		self.call(check, newState[check])

func current_turn(newVal):
	local_state['active']= (newVal==self)

func useAction(num):
	
	if actions>0:
		actions-=1
		return true
	else:
		return false

func addCoin(num):
	gold+=num
	#set displayed gold

func addFaeria(num):
	faeria+=num
	#set display

func drawCard():
	pass
