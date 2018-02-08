extends Node2D

export(int,"empty","orb","land","lake","tree","hill","sand","well") var initial_state=0
onready var sprite=get_node("sprite")
export(int) var id = 0
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

### HELPERS

func activePlayerCanAffect(by, strict=false):
	if stateLocal['hex_owner']==int(by):
		print('here')
	return( (stateLocal['hex_owner']==-1 and !strict) or stateLocal['hex_owner']==by)

func hex_is_empty():
	return !($hexEntity.has_node('BoardEntity'))

func hex_is_empty_or_self():
	return !($hexEntity.has_node('BoardEntity')) or $hexEntity.get_node('BoardEntity')==stateLocal['active_unit']
	

func has_opposing_unit():
	if $hexEntity.get_children().size()>1:
		if $hexEntity.get_children()[1].Owner>=0:
			if $hexEntity.get_children()[1].Owner!=stateLocal['active_unit'].Owner:
				return true
			else:
				return false

func is_harvestable():
	if hexType.child.spawnsFaeria:
		if $hexEntity.get_node("BoardEntity").Unit.current_faeria>0:
			return true
	
	return false

func is_adjacent_to(hex):
	return adjacent.has(hex)

func is_adjacent_or_equal_to(hex):
	return adjacent.has(hex) or hex==self

### ACTION HIGHLIGHTING AND TARGET VERIFICATION

func action(type,by,test=false):
	if type=="":
		setState({'cover':Color(0,0,0,0)})
	##make lands
	elif type=="actionLand":
		if hexType.child.ActionLand(self, by):
			if !test:
				setState({'cover':land, 'target':true, 'hex_owner':by})
			else:
				return true
		else:
			setState({'cover':Color(0,0,0,0), 'target':false})
			if test:
				return false
	elif type=="actionSand":
		if hexType.child.actionSand and activePlayerCanAffect(by):
			if !test:
				setState({'cover':move, 'target':true})
			else:
				return true
		else:
			setState({'cover':Color(0,0,0,0), 'target':false})
			if test:
				return false
	elif type=="actionLake":
		if hexType.child.actionLake and activePlayerCanAffect(by):
			if !test:
				setState({'cover':summon, 'target':true})
			else:
				return true
		else:
			setState({'cover':Color(0,0,0,0), 'target':false})
			if test:
				return false
	elif type=="actionTree":
		if hexType.child.actionTree and activePlayerCanAffect(by):
			if !test:
				setState({'cover':gather, 'target':true})
			else:
				return true
		else:
			setState({'cover':Color(0,0,0,0), 'target':false})
			if test:
				return false
	elif type=="actionHill":
		if hexType.child.actionHill and activePlayerCanAffect(by):
			if !test:
				setState({'cover':targetOther, 'target':true})
			else:
				return true
		else:
			setState({'cover':Color(0,0,0,0), 'target':false})
			if test:
				return false
	#make things
	elif type=="buildAny":
		if hexType.child.buildAny and activePlayerCanAffect(by) and hex_is_empty():
			if !test:
				setState({'cover':summon, 'target':true})
			else:
				return true
		else:
			setState({'cover':Color(0,0,0,0), 'target':false})
			if test:
				return false
	elif type=="buildSand":
		if hexType.child.buildSand and activePlayerCanAffect(by) and hex_is_empty():
			if !test:
				setState({'cover':summon, 'target':true})
			else:
				return true
		else:
			setState({'cover':Color(0,0,0,0), 'target':false})
			if test:
				return false
	elif type=="buildLake":
		if hexType.child.buildLake and activePlayerCanAffect(by) and hex_is_empty():
			if !test:
				setState({'cover':summon, 'target':true})
			else:
				return true
		else:
			setState({'cover':Color(0,0,0,0), 'target':false})
			if test:
				return false
	elif type=="buildTree":
		if hexType.child.buildTree and activePlayerCanAffect(by) and hex_is_empty():
			if !test:
				setState({'cover':summon, 'target':true})
			else:
				return true
		else:
			setState({'cover':Color(0,0,0,0), 'target':false})
			if test:
				return false
	elif type=="buildHill":
		if hexType.child.buildHill and activePlayerCanAffect(by) and hex_is_empty():
			if !test:
				setState({'cover':summon, 'target':true})
			else:
				return true
		else:
			setState({'cover':Color(0,0,0,0), 'target':false})
			if test:
				return false
	elif type=="moveBase":
		if hexType.child.moveLand and hex_is_empty_or_self() and is_adjacent_or_equal_to(stateLocal['active_unit'].Hex):
			if !test:
				setState({'cover':move,'target':true})
			else:
				return true
		else:
			setState({'cover':Color(0,0,0,0), 'target':false})
			if test:
				return false
	elif type=="moveAir":
		if hexType.child.moveAir and hex_is_empty():
			if !test:
				setState({'cover':move,'target':true})
			else:
				return true
		else:
			setState({'cover':Color(0,0,0,0), 'target':false})
			if test:
				return false
	elif type=="moveLand":
		if hexType.child.moveWater and hex_is_empty():
			if !test:
				setState({'cover':move,'target':true})
			else:
				return true
		else:
			setState({'cover':Color(0,0,0,0), 'target':false})
			if test:
				return false
	elif type=="AttackAdj":
		if is_adjacent_to(stateLocal['active_unit'].Hex) and (has_opposing_unit()):
			if !test:
				setState({'cover':attack,'target':true})
			else:
				return true
		else:
			setState({'cover':Color(0,0,0,0), 'target':false})
			if test:
				return false
	elif type=="AttackAdjOrCollect":
		if is_adjacent_to(stateLocal['active_unit'].Hex) and has_opposing_unit():
			if !test:
				setState({'cover':attack,'target':true})
			else:
				return true
		elif is_adjacent_to(stateLocal['active_unit'].Hex) and is_harvestable():
			if !test:
				setState({'cover':gather,'target':true})
			else:
				return true
		else:
			setState({'cover':Color(0,0,0,0), 'target':false})
			if test:
				return false
	elif type=='Collect':
		if is_adjacent_to(stateLocal['active_unit'].Hex) and is_harvestable():
			if !test:
				setState({'cover':attack,'target':true})
			else:
				return true
		else:
			setState({'cover':Color(0,0,0,0), 'target':false})
			if test:
				return false

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

var stateLocal={"cover":Color(0,0,0,0),"target":false, "hex_type":initial_state,"active_unit":null,'hovered':false}

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

func active_unit(unit):
	if unit==null:
		stateLocal['active_unit']
	else:
		stateLocal['active_unit']=gameNode.get_unit_by_hex(gameNode.get_hex_by_id(unit))

func hovered(val):
	if val and stateLocal['cover']!=Color(0,0,0,0):
		$sprite.modulate =mouseover_color
	else:
		$sprite.modulate= stateLocal['cover']

#watchState: components of state to track and respond to
var watchState=["action",'active_unit','hovered']
var stateCopy={"action":"",'active_unit':null,'hovered':null}
var stateCopyMethods={"action":"update_Action",'active_unit':'update_active_unit','hovered':'update_hovered'}

func connect(game):
	gameNode=game
	game.connect("UpdateState",self,"state_update")

func state_update(state,keys):
	for check in keys:
		if watchState.has(check):
			if stateCopy[check]!=state[check]:
				call(stateCopyMethods[check], state[check], state['current_turn'])
				stateCopy[check]=state[check]

####UPDATE FUNCTIONS
func update_Action(val, by):
	action(val, by)

func update_active_unit(val, by):
	active_unit(val)

func update_hovered(val,by):
	hovered(val==self.id)


### INPUT SECTION

func _input(event):
	if stateCopy["action"]!="" and event.is_action('click') and stateLocal["target"] and false:
		gameNode.completeAction(self)
		stateLocal["target"]=false

func complete_action_click():
	if stateLocal["target"] and stateCopy["action"]!="":
		gameNode.completeAction(self)
		stateLocal["target"]=false



func _on_Area2D_mouse_exited():
	gameNode.setState({'hovered':null})
