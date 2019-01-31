extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(int, "Any","Opponent","Owner") var player = 0
export(int, "Unit", "Creature", "Building") var target_type = 1
export(bool) var then_free = false

export(PackedScene) var unbuffer = null


var entity
var Game
func init(_entity):
	entity = _entity
	Game = entity.Game

var val

func activate(_Game, _entity, _val):
	Game = _Game
	entity = _entity
	val=_val
	if entity.Owner==0:
		Game.delegate_action(entity.Hex.id,get_parent().get_name()+'/'+get_name())
	return true


func conditions(hex):
	if hex.has_unit():
		var unit = hex.get_unit()
		if (target_type == 0 or (target_type == 1 and unit.Unit.is_creature) or (target_type == 2 and unit.Unit.is_building)):
			if player == 0:
				return true
			elif unit.Owner==player%2:
				return true
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
	var target_entity = Game.get_hex_by_id(target).get_unit()
	target_entity.Unit.add_one_energy()
	var modName = target_entity.Unit.set_mod_att('mightAndGuts', 1, true)
	if unbuffer != null:
		var attach_unbuffer = unbuffer.instance()
		attach_unbuffer.set_name(modName)
		attach_unbuffer.init(target_entity)
		target_entity.Unit.get_node("on_end_turn").add_child(attach_unbuffer)
		target_entity.Unit.on_end_turn = true
	return false
