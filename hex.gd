extends Node2D

export(int,"empty","orb","land","lake","tree","hill","sand","well") var initial_state=0
onready var sprite=get_node("sprite")
export(int) var id

export(Color,RGBA) var move
export(Color,RGBA) var land
export(Color,RGBA) var attack
export(Color,RGBA) var summon
export(Color,RGBA) var targetOther
export(Color,RGBA) var mouseover_color
export(Color,RGBA) var gather


#this fills at runtime
var adjacent =[]

var me

func action(type):

	if type=="":
		setModulate(Color(0,0,0,0))
		stateLocal["cover"]=Color(0,0,0,0)

	##make lands
	elif type=="actionLand":
		if hexType.child.ActionLand(self):
			setModulate(land)
			stateLocal["cover"]=land
			stateLocal["target"]=true
		else:
			setModulate(Color(0,0,0,0))
			stateLocal["cover"]=Color(0,0,0,0)
			stateLocal["target"]=false
	elif type=="actionSand":
		if hexType.child.actionSand:
			setModulate(move)
			stateLocal["cover"]=move
			stateLocal["target"]=true
		else:
			setModulate(Color(0,0,0,0))
			stateLocal["cover"]=Color(0,0,0,0)
			stateLocal["target"]=false
	elif type=="actionLake":
		if hexType.child.actionLake:
			setModulate(summon)
			stateLocal["cover"]=summon
			stateLocal["target"]=true
		else:
			setModulate(Color(0,0,0,0))
			stateLocal["cover"]=Color(0,0,0,0)
			stateLocal["target"]=false
	elif type=="actionTree":
		if hexType.child.actionTree:
			setModulate(gather)
			stateLocal["cover"]=gather
			stateLocal["target"]=true
		else:
			setModulate(Color(0,0,0,0))
			stateLocal["cover"]=Color(0,0,0,0)
			stateLocal["target"]=false
	elif type=="actionHill":
		if hexType.child.actionHill:
			setModulate(targetOther)
			stateLocal["cover"]=targetOther
			stateLocal["target"]=true
		else:
			setModulate(Color(0,0,0,0))
			stateLocal["cover"]=Color(0,0,0,0)
			stateLocal["target"]=false
	#make things
	elif type=="buildAny":
		if hexType.child.buildAny:
			setModulate(summon)
			stateLocal["cover"]=summon
			stateLocal["target"]=true
		else:
			setModulate(Color(0,0,0,0))
			stateLocal["cover"]=Color(0,0,0,0)
			stateLocal["target"]=false
	elif type=="buildSand":
		if hexType.child.buildSand:
			setModulate(summon)
			stateLocal["cover"]=summon
			stateLocal["target"]=true
		else:
			setModulate(Color(0,0,0,0))
			stateLocal["cover"]=Color(0,0,0,0)
			stateLocal["target"]=false
	elif type=="buildLake":
		if hexType.child.buildLake:
			setModulate(summon)
			stateLocal["cover"]=summon
			stateLocal["target"]=true
		else:
			setModulate(Color(0,0,0,0))
			stateLocal["cover"]=Color(0,0,0,0)
			stateLocal["target"]=false
	elif type=="buildTree":
		if hexType.child.buildTree:
			setModulate(summon)
			stateLocal["cover"]=summon
			stateLocal["target"]=true
		else:
			setModulate(Color(0,0,0,0))
			stateLocal["cover"]=Color(0,0,0,0)
			stateLocal["target"]=false
	elif type=="buildHill":
		if hexType.child.buildHill:
			setModulate(summon)
			stateLocal["cover"]=summon
			stateLocal["target"]=true
		else:
			setModulate(Color(0,0,0,0))
			stateLocal["cover"]=Color(0,0,0,0)
			stateLocal["target"]=false

func setModulate(color):
	sprite.set_modulate(color)
	#move things
	#attack things
		#gather things
		#targetThings

#
const STATE_EMPTY=0
const STATE_ORB=1
const STATE_LAND=2
const STATE_LAKE=3
const STATE_TREE=4
const STATE_HILL=5
const STATE_SAND=6
const STATE_WELL=7
#
var currentState
#'''


var hexType

func _ready():
	hexType=find_node("hexType")
	hexType.setState(initial_state)
	set_process_input(true)


#func setState(newState):
	#if (newState==STATE_EMPTY):
		#currentState=empty.new(self)
	#elif (newState==STATE_ORB):
		#currentState=orb.new(self)
	#elif (newState==STATE_LAND):
		#currentState=land.new(self)
	#elif (newState==STATE_TREE):
		#currentState=land.new(self)
	#elif (newState==STATE_LAKE):
		#currentState=land.new(self)
	#elif (newState==STATE_HILL):
		#currentState=land.new(self)
	#elif (newState==STATE_SAND):
		#currentState=land.new(self)
	#elif (newState==STATE_WELL):
		#currentState=well.new(self)

var gameNode

var stateLocal={"cover":null,"target":false}

#watchState: components of state to track and respond to
var watchState=["action"]
var stateCopy={"action":""}
var stateCopyMethods={"action":"update_Action"}

func connect(game):
	gameNode=game
	game.connect("UpdateState",self,"state_update")

func state_update(state):
	for check in watchState:
		if stateCopy[check]!=state[check]:
			call(stateCopyMethods[check],state[check])
			stateCopy[check]=state[check]

####UPDATE FUNCTIONS
func update_Action(val):
	action(val)



### INPUT SECTION

func _input(event):
	if mouseover and stateCopy["action"]!="" and event.type==3 and stateLocal["target"]:
		gameNode.completeAction(self)
		stateLocal["target"]=false

var mouseover=false

func _on_Area2D_mouse_enter():
	mouseover=true
	if stateLocal["cover"]!=null:
		setModulate(mouseover_color)


func _on_Area2D_mouse_exit():
	mouseover=false
	if stateLocal["cover"]!=null:
		setModulate(stateLocal["cover"])
