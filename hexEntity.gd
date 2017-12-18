extends Node2D

class state:
	var cardRef
	var health=3 #test value
	var attack=2 #test value
	var energy=0
	var me
	
	func _init(myself,card):
		me=myself
		cardRef=card
		
	func startTurn():
		energy=1 # or += 1 based on card

var currentState

func _ready():
	currentState=state.new(self,0)

func turnStart():
	currentState.startTurn()