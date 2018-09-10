extends Node


export(int,'empty','null','Land','Lake','Tree','Hill','Sand') var type = 4

var Game
var entity
func init(_entity):
	entity=_entity
	Game=entity.Game

func activate(_Game, _entity, _val):
	Game = _Game
	entity = _entity
	
	if entity.Owner==0:
		Game.delegate_action(entity.Hex.id,get_parent().get_name()+"/"+get_name())
	return true

func targeting():
	for ent in get_tree().get_nodes_in_group('entities'):
		if ent.Owner==entity.Owner and ent.Unit.move and targ_move(ent.Unit.get_node('Movement').get_children()[0].get_action_type(),true):
			ent.Hex.setState({'cover':ent.Hex.targetOther , 'target' :true})
		else:
			ent.Hex.setState({'cover':Color(0,0,0,0) , 'target' :false})

func targ_move(type,test=false):
	for hex in get_tree().get_nodes_in_group('Hex'):
		if type=="moveBase":
			if hex.hexType.child.moveLand and hex.hex_is_empty_or_self() and hex.is_adjacent_or_equal_to(hex.stateLocal['active_unit'].Hex):
				if !test:
					hex.setState({'cover':hex.move,'target':true})
				else:
					return true
			else:
				hex.setState({'cover':Color(0,0,0,0), 'target':false})
				if test:
					return false
		elif type=="moveAir":
			if hex.hexType.child.moveAir and hex.hex_is_empty_or_self() and hex.is_adjacent_or_equal_to(hex.stateLocal['active_unit'].Hex):
				if !test:
					hex.setState({'cover':hex.move,'target':true})
				else:
					return true
			else:
				hex.setState({'cover':Color(0,0,0,0), 'target':false})
				if test:
					return false
		elif type=="moveWater":
			if hex.hexType.child.moveWater and hex.hex_is_empty_or_self() and hex.is_adjacent_or_equal_to(hex.stateLocal['active_unit'].Hex):
				if !test:
					hex.setState({'cover':hex.move,'target':true})
				else:
					return true
			else:
				hex.setState({'cover':Color(0,0,0,0), 'target':false})
				if test:
					return false

func hex_targ():
	for hex in Game.get_hex_by_id(Game.state['active_unit']).adjacent:
		if hex.stateLocal['hex_type']==2 or hex.stateLocal['hex_type']==0:
			hex.setState({'cover':hex.targetOther , 'target' :true})
		else:
			setState({'cover':Color(0,0,0,0), 'target':false})

var moved = false
func complete(target,set_state=null):
	var local=true
	var state = Game.get_state()
	if set_state!=null:
		state=set_state
		local=false

	if Game.state['active_unit']==null and local:
		Game.setState({'active_unit':target})
		var mov = Game.get_hex_by_id(Game.state['active_unit']).get_unit().Unit.get_node('Movement').get_children()[0].get_action_type()
		targ_move(mov)
	elif not moved and local:
		var hex_target = Game.get_hex_by_id(target)
		startBasictimeout()
		var unit = get_hex_by_id(state['active_unit']).get_unit()
		
		if local:
			Game.send_action('hardMove', remote_convert(target),{'active_unit':remote_convert(state['active_unit'])})
		unit.on_move(hex_target.get_node('hexEntity'))
		unit.Hex=hex_target
		moved=true
		hex_targ()
	else:
		Game.get_hex_by_id(target).setState({'hex_type':4})
		if local:
			Game.send_action('actionTree', remote_convert(target),{'current_turn':(state['current_turn']+1)%2,'active_unit':remote_convert(state['active_unit'])})
		Game.actionDone()

func remote_convert(hex_id):
	if hex_id==0:
		return 0
	else:
		return 45-hex_id

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
