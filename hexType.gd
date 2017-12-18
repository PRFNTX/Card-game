extends Node2D

class state:
	var me
	var state
	
	func _init(myself,i):
		me=myself
		state=i
		for child in me.get_children():
			child.hide()
		if i>0:
			me.get_child(i-1).show()
		

var currentState

func _ready():
	setState(0)
	

func setState(newState):
	currentState=state.new(self,newState)
