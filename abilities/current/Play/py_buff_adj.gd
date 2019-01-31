extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(int) var health = 1
export(int) var energy = 0
export(bool) var adjacent_only = true
export(int, "friendly", "enemy", "any") var target_player = 0
export(int, "unit", "creature", "building") var target_type = 1

var Game
var entity
func init(_entity):
	entity = _entity
	Game = entity.Game

func activate(_game, _entity, _unused):
	Game.delegate_action(entity.Hex.id,get_relative_path())

func get_relative_path():
	return get_parent().get_name()+'/'+get_name()

func conditions(hex):
	if not hex.has_unit():
		return false
	if (
		(hex.has_friendly_unit(entity.Owner) and target_player == 0) 
		or (hex.has_opposing_unit(entity.Owner) and target_player == 1)
	):
		if (
			target_type == 0
			or (target_type == 1 and hex.unit_is_creature())
			or (target_type == 2 and hex.unit_is_building())
		):
			return true
	return false

func targeting():
	if adjacent_only:
		for hex in entity.Hex.adjacent:
			if condition(hex):
				hex.setState({'cover':hex.summon, 'target':true})
			else:
				hex.setState({'cover':Color(0,0,0,0) , 'target' :false})

func complete(target, set_state=null):
	pay_costs()
	var local = true
	var state = Game.get_state()
	if not set_state==null:
		state=set_state
		local= false
	var entity_target = Game.get_hex_by_id(target).get_unit()
	entity_target.life_change(health)
	for point in range(0, energy):
		entity_target.add_one_energy()
	if local:
		Game.send_action('delegate',45-target,{'delegate_id':entity.Hex.id,'delegate_node':get_relative_path()})
	Game.actionDone()



