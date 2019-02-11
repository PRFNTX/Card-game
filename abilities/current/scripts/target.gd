extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(int, "Any","Owner","Opponent") var player = 1
export(int,"Unit","Creature","Building") var type = 1
export(bool) var on_empty = true
export(bool) var on_plain = true
export(bool) var on_lake = true
export(bool) var on_tree = true
export(bool) var on_hill = true
export(bool) var on_sand = true

export(bool) var then_free = true

var targ_array
var entity
var Game
func init(_entity):
	entity = _entity
	Game = entity.Game
	targ_array = [
		on_empty,
		on_plain,
		on_lake,
		on_tree,
		on_hill,
		on_sand,
		false
	]

var val

func activate(_Game, _entity, _val):
	Game = _Game
	entity = _entity
	val=_val
	if entity.Owner==0:
		Game.delegate_action(entity.Hex.id,'on_play/target unit')
	return true

var conv_type = [0,6,1,2,3,4,5,6]
func conditions(hex):
	if not hex.has_unit():
		return false
	if not targ_array[conv_type[hex.stateLocal.hex_type]]:
		return false
	if player==0:
		if type == 0:
			return true
		elif type==1 and hex.unit_is_creature():
			return true
		elif type==2 and hex.unit_is_building():
			return true
	else:
		if type == 0:
			return (player==1 and hex.has_friendly_unit(entity.Owner)) or (player==2 and hex.has_opposing_unit(entity.Owner))
		elif type==1 and hex.unit_is_creature():
			return (player==1 and hex.has_friendly_unit(entity.Owner)) or (player==2 and hex.has_opposing_unit(entity.Owner))
		elif type==2 and hex.unit_is_building():
			return (player==1 and hex.has_friendly_unit(entity.Owner)) or (player==2 and hex.has_opposing_unit(entity.Owner))
	return false

func targeting():
	for hex in get_tree().get_nodes_in_group("Hex"):
		if conditions(hex):
			hex.setState({'cover':hex.targetOther , 'target' :true})
		else:
			hex.setState({'cover':Color(0,0,0,0) , 'target' :false})

func complete(target, set_state=null):
	var local = true
	var state = Game.get_state()
	if not set_state==null:
		state=set_state
		local= false
	Game.setState({'active_unit':target})
	Game.actionReady=true
	var is_done = get_children()[0].activate(Game,Game.get_hex_by_id(Game.state['active_unit']).get_unit(),val)
	if is_done == null and local:
		Game.send_action('delegate',remote_convert(target),{'delegate_id':remote_convert(entity.Hex.id),'delegate_node':get_parent().get_name()+"/"+get_name()})

func cancel_action():
	pass

func remote_convert(hex_id):
	if hex_id==0:
		return 0
	else:
		return 45-hex_id