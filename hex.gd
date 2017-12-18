extends Node2D

export(int,"empty","orb","land","lake","tree","hill","sand","well") var initial_state


#this fills at runtime
var adjacent =[]


class empty:
	var me
	var hover
	var move="water"
	var stateID
	
	func _init(myself,val):
		me=myself
		stateID=val
		#me.hexType.call("setState",stateID)
	
	func onMouseOver(action):
		#this will highlight when an action is possible
		#if action=="land" or action=="water":
		#me.show()
		me.get_child(0).set_modulate(Color(50,200,120,0.4))
	
	func onMouseExit(action):
		me.get_child(0).set_modulate(Color(0,0,0,0))
	
	func handleClick(action):
		#this will do things when clicked if the action is possible or a new action can start
		pass
	
	func verifyTarget(pos,method):
		#this will check if this space is a valid target for an action 
		pass

class land:
	var me
	var hover
	var move="water"
	var stateID
	
	func _init(myself,val):
		me=myself
		stateID=val
		#me.hexType.call("setState",stateID)
	
	func onMouseOver(action):
		if action=="land" or action=="water":
			me.get_child(0).show()
			me.get_child(0).set_modulate(Color(50,200,120,0.4))
	
	func handleClick(action):
		pass
	
	func verifyTarget(pos,method):
		#this will check if this space is a valid target for an action 
		pass

class orb:
	var me
	var hover
	var move="water"
	var stateID
	
	func _init(myself,val):
		me=myself
		stateID=val
		#me.hexType.call("setState",stateID)
	
	func onMouseOver(action):
		if action=="land" or action=="water":
			me.show()
			me.set_modulate(Color(50,200,120,0.4))
	
	func handleClick(action):
		pass
	
	func verifyTarget(pos,method):
		#this will check if this space is a valid target for an action 
		pass

class well:
	var me
	var hover
	var move="water"
	var stateID
	
	func _init(myself,val):
		me=myself
		stateID=val
		#me.hexType.call("setState",stateID)
	
	func onMouseOver(action):
		if action=="land" or action=="water":
			me.show()
			me.set_modulate(Color(50,200,120,0.4))
	
	func handleClick(action):
		pass
	
	func verifyTarget(pos,method):
		#this will check if this space is a valid target for an action 
		pass

var mouseover=false


const STATE_EMPTY=0
const STATE_ORB=1
const STATE_LAND=2
const STATE_LAKE=3
const STATE_TREE=4
const STATE_HILL=5
const STATE_SAND=6
const STATE_WELL=7

var currentState

onready var hexType=find_node("hexType")

func _ready():
	setState(initial_state)
	print(hexType)

func setState(newState):
	if (newState==STATE_EMPTY):
		currentState=empty.new(self,newState)
	elif (newState==STATE_ORB):
		currentState=orb.new(self,newState)
	elif (newState==STATE_LAND):
		currentState=land.new(self,newState)
	elif (newState==STATE_TREE):
		currentState=land.new(self,newState)
	elif (newState==STATE_HILL):
		currentState=land.new(self,newState)
	elif (newState==STATE_SAND):
		currentState=land.new(self,newState)
	elif (newState==STATE_WELL):
		currentState=well.new(self,newState)
	


func _on_Area2D_mouse_enter():
	print("entered")
	print(currentState)
	mouseover=true
	if currentState.has_method("onMouseOver"):
		currentState.call("onMouseOver",true)


func _on_Area2D_mouse_exit():
	print("exited")
	mouseover=false
	if currentState.has_method("onMouseExit"):
		currentState.call("onMouseExit",true)
