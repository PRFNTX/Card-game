extends Node2D

export(int,"empty","orb","land","lake","tree","hill","sand","well") var initial_state=0
onready var sprite=get_node("sprite")
export(int) var id
export(int) var initial_owner = -1

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


func activePlayerCanAffect(by, strict=false):
	if stateLocal['hex_owner']==by:
		print('here')
	return( (stateLocal['hex_owner']==-1 and !strict) or stateLocal['hex_owner']==by)

func action(type,by):
	if type=="":
		setState({'cover':Color(0,0,0,0)})
	##make lands
	elif type=="actionLand":
		if hexType.child.ActionLand(self, by):
			setState({'cover':land, 'target':true, 'hex_owner':by})
		else:
			setState({'cover':Color(0,0,0,0), 'target':false})
	elif type=="actionSand":
		if hexType.child.actionSand and activePlayerCanAffect(by):
			setState({'cover':move, 'target':true})
		else:
			setState({'cover':Color(0,0,0,0), 'target':false})
	elif type=="actionLake":
		if hexType.child.actionLake and activePlayerCanAffect(by):
			setState({'cover':summon, 'target':true})
		else:
			setState({'cover':Color(0,0,0,0), 'target':false})
	elif type=="actionTree":
		if hexType.child.actionTree and activePlayerCanAffect(by):
			setState({'cover':gather, 'target':true})
		else:
			setState({'cover':Color(0,0,0,0), 'target':false})
	elif type=="actionHill":
		if hexType.child.actionHill and activePlayerCanAffect(by):
			setState({'cover':targetOther, 'target':true})
		else:
			setState({'cover':Color(0,0,0,0), 'target':false})
	#make things
	elif type=="buildAny":
		if hexType.child.buildAny and activePlayerCanAffect(by):
			setState({'cover':summon, 'target':true})
		else:
			setState({'cover':Color(0,0,0,0), 'target':false})
	elif type=="buildSand":
		if hexType.child.buildSand and activePlayerCanAffect(by):
			setState({'cover':summon, 'target':true})
		else:
			setState({'cover':Color(0,0,0,0), 'target':false})
	elif type=="buildLake":
		if hexType.child.buildLake and activePlayerCanAffect(by):
			setState({'cover':summon, 'target':true})
		else:
			setState({'cover':Color(0,0,0,0), 'target':false})
	elif type=="buildTree":
		if hexType.child.buildTree and activePlayerCanAffect(by):
			setState({'cover':summon, 'target':true})
		else:
			setState({'cover':Color(0,0,0,0), 'target':false})
	elif type=="buildHill":
		if hexType.child.buildHill and activePlayerCanAffect(by):
			setState({'cover':summon, 'target':true})
		else:
			setState({'cover':Color(0,0,0,0), 'target':false})

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
	stateLocal['hex_owner']=initial_owner



var gameNode

#### LOCAL STATE

var stateLocal={"cover":null,"target":false, "hex_type":initial_state}

###LOCAL STATE UPDATE FUNCTIONS

func setState(newState):
	for key in newState.keys():
		call(key, newState[key])

func affectState(newState,by):
	if activePlayerCanAffect(by):
		setState(newState)

func cover(val):
	setModulate(val)
	stateLocal['cover']=val

func target(val):
	stateLocal['target']=val

func hex_owner(val):
	stateLocal['hex_owner']=val

func hex_type(val):
	hexType.setState(val)
	stateLocal['hex_type']=val

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
			call(stateCopyMethods[check], state[check], state['current_turn'])
			stateCopy[check]=state[check]

####UPDATE FUNCTIONS
func update_Action(val, by):
	action(val, by)



### INPUT SECTION

func _input(event):
	if mouseover and stateCopy["action"]!="" and event is InputEventMouseButton and stateLocal["target"]:
		gameNode.completeAction(self)
		stateLocal["target"]=false


var mouseover=false


func _on_Area2D_mouse_entered():
	mouseover=true
	if stateLocal["cover"]!=null:
		setModulate(mouseover_color)


func _on_Area2D_mouse_exited():
	mouseover=false
	if stateLocal["cover"]!=null:
		setModulate(stateLocal["cover"])
