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

export(Color, RGBA) var enemy_modulate = Color(0,0,0,0)


#this fills at runtime
var adjacent =[]

var me

### HELPERS

func get_unit():
	if $hexEntity.get_children().size()>1:
		return $hexEntity.get_children()[1]

func activePlayerCanAffect(by, strict=false, allow_convoke=false):
	if stateLocal['hex_owner']==int(by):
		#print('here')
		pass
	if allow_convoke and has_friendly_unit(by):
		if get_unit().Unit.convoke:
			return true
	return (
		(stateLocal['hex_owner']==-1 and !strict)
		or stateLocal['hex_owner']==0
	)

func buildableByConvoke(by):
	for hex in adjacent:
		if hex.has_unit():
			if hex.get_unit().Unit.convoke and hex.get_unit().Owner == by:
				return true
	return false

func hex_is_empty():
	return !($hexEntity.has_node('BoardEntity'))

func hex_is_empty_or_self(loc=null):
	if loc!=null:
		return (!has_unit() or loc==id)
	else:
		return (!has_unit() or get_unit()==stateLocal['active_unit'])
	

func has_opposing_unit(friendly=0):
	if $hexEntity.get_children().size()>1:
		if $hexEntity.get_children()[1].Owner>=0:
			if $hexEntity.get_children()[1].Owner!=friendly:
				return true
			else:
				return false

func has_attackable_opposing_unit(friendly=0):
	if $hexEntity.get_children().size()>1:
		var hexUnit = $hexEntity.get_children()[1]
		if hexUnit.Owner>=0:
			if hexUnit.Owner!=friendly and hexUnit.Unit.is_attackable:
				return true
			else:
				return false

func has_friendly_unit(friendly=0):
	if $hexEntity.get_children().size()>1:
		if $hexEntity.get_children()[1].Owner>=0:
			if $hexEntity.get_children()[1].Owner==friendly:
				return true
			else:
				return false

func has_unit():
	if $hexEntity.get_children().size()>1:
		return true
	else:
		return false

func unit_is_creature():
	if has_unit():
		if $hexEntity.get_children()[1].Unit.is_unit:
			return true
	return false

func unit_is_building():
	if has_unit():
		if $hexEntity.get_children()[1].Unit.is_building and not $hexEntity.get_children()[1].Unit.is_orb:
			return true
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
	if id==0:
		return false 
	if type=="":
		setState({'cover':Color(0,0,0,0)})
	##make lands
	elif type=="actionLand":
		if hexType.child.ActionLand(self, by) and hex_is_empty():
			if !test:
				setState({'cover':land, 'target':true})
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
		if (hexType.child.buildAny or (stateLocal.hex_type==0 and buildableByConvoke(by))) and (activePlayerCanAffect(by) or buildableByConvoke(by)) and hex_is_empty():
			if !test:
				setState({'cover':summon, 'target':true})
			else:
				return true
		else:
			setState({'cover':Color(0,0,0,0), 'target':false})
			if test:
				return false
	elif type=="buildSand":
		if hexType.child.buildSand and (activePlayerCanAffect(by) or buildableByConvoke(by)) and hex_is_empty():
			if !test:
				setState({'cover':summon, 'target':true})
			else:
				return true
		else:
			setState({'cover':Color(0,0,0,0), 'target':false})
			if test:
				return false
	elif type=="buildLake":
		if hexType.child.buildLake and (activePlayerCanAffect(by) or buildableByConvoke(by)) and hex_is_empty():
			if !test:
				setState({'cover':summon, 'target':true})
			else:
				return true
		else:
			setState({'cover':Color(0,0,0,0), 'target':false})
			if test:
				return false
	elif type=="buildTree":
		if hexType.child.buildTree and (activePlayerCanAffect(by) or buildableByConvoke(by)) and hex_is_empty():
			if !test:
				setState({'cover':summon, 'target':true})
			else:
				return true
		else:
			setState({'cover':Color(0,0,0,0), 'target':false})
			if test:
				return false
	elif type=="buildHill":
		if hexType.child.buildHill and (activePlayerCanAffect(by) or buildableByConvoke(by)) and hex_is_empty():
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
		if hexType.child.moveAir and hex_is_empty_or_self() and is_adjacent_or_equal_to(stateLocal['active_unit'].Hex):
			if !test:
				setState({'cover':move,'target':true})
			else:
				return true
		else:
			setState({'cover':Color(0,0,0,0), 'target':false})
			if test:
				return false
	elif type=="moveWater":
		if hexType.child.moveWater and hex_is_empty_or_self() and is_adjacent_or_equal_to(stateLocal['active_unit'].Hex):
			if !test:
				setState({'cover':move,'target':true})
			else:
				return true
		else:
			setState({'cover':Color(0,0,0,0), 'target':false})
			if test:
				return false
	elif type=="AttackAdj":
		if is_adjacent_to(stateLocal['active_unit'].Hex) and (has_attackable_opposing_unit(by)):
			if !test:
				setState({'cover':attack,'target':true})
			else:
				return true
		else:
			setState({'cover':Color(0,0,0,0), 'target':false})
			if test:
				return false
	elif type=="AttackAdjOrCollect":
		if is_adjacent_to(stateLocal['active_unit'].Hex) and has_attackable_opposing_unit(by):
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

var stateLocal={"cover":Color(0,0,0,0),"target":false, "hex_type":initial_state,"active_unit":null,'hovered':false, 'hex_owner':-1}

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



const land_types = ["empty","orb","land","lake","tree","hill","sand","well"]
func hex_owner(val):
	if stateLocal['hex_owner']>=0:
		gameNode.players[stateLocal['hex_owner']].modLands(land_types[stateLocal['hex_type']],-1)
	stateLocal['hex_owner']=val
	gameNode.players[val].modLands(land_types[stateLocal['hex_type']],1)
	if val == 1 and $hexType.child.darkened!=null:
		$hexType.child.texture = $hexType.child.darkened 
	elif val==0 and $hexType.child.light!=null:
		$hexType.child.texture = $hexType.child.light
	

func hex_type(val):
	hexType.setState(val)
	stateLocal['hex_type']=val
	if has_unit():
		destroy_aquatic_on_land()
		destroy_land_on_aquatic()

func active_unit(unit):
	if unit==null:
		stateLocal['active_unit']=null
	else:
		stateLocal['active_unit']=gameNode.get_unit_by_hex(gameNode.get_hex_by_id(unit))


func hovered(val):
	if val and stateLocal['cover']!=Color(0,0,0,0):
		$sprite.modulate =mouseover_color
	else:
		$sprite.modulate= stateLocal['cover']

#watchState: components of state to track and respond to
var watchState=["action",'active_unit', 'hovered']
var stateCopy={"action":"",'active_unit':null,'hovered':null}
var stateCopyMethods={"action":"update_Action",'active_unit':'update_active_unit', 'hovered':'update_hovered'}

func do_connect(game):
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


# CLEANERS

func destroy_aquatic_on_land():
	if stateLocal.hex_type!=STATE_EMPTY and stateLocal.hex_type!=STATE_LAKE:
		var unit = get_unit()
		if unit.Unit.aquatic:
			unit.kill()

func destroy_land_on_aquatic():
	if stateLocal.hex_type==STATE_EMPTY and stateLocal.hex_type==STATE_LAKE:
		var unit = get_unit()
		if !unit.Unit.aquatic and !unit.Unit.flying:
			unit.kill()


### INPUT SECTION

func _input(event):
	if stateCopy["action"]!="" and event.is_action('click') and stateLocal["target"] and false:
		gameNode.completeAction(self)

func complete_action_click(event):
	if stateLocal["target"] and stateCopy["action"]!="" and event.is_pressed():
		gameNode.completeAction(self)

func _on_Area2D_mouse_exited():
	gameNode.setState({'hovered':null})
