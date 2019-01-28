extends Node

export(int) var health = 2
export(int) var max_target_health = 2
export(int,"All","Creature","Building") var target_type = 1
export(int,"All","Owner","Opponent") var player = 1


var entity
var Game
func init(_entity):
	entity = _entity
	Game = entity.Game

func activate(_Game, _entity, unused):
	Game = _Game
	entity = _entity
	Game.delegate_action(entity.Hex.id,get_parent().get_name()+'/'+get_name())

func condition_health(hex):
	if hex.unit_is_creature() and hex.get_unit().Unit.current_health > max_target_health:
		return false
	elif hex.unit_is_building() and hex.get_unit().Unit.current_val > max_target_health:
		return false
	return true

func condition_unit_type(hex):
	return (
		target_type==0
		or (target_type==1 and hex.unit_is_creature())
		or (target_type==2 and hex.unit_is_building())
	)

func targeting():
	for hex in get_tree().get_nodes_in_group("Hex"):
		if target_player==0:
			if hex.has_friendly_unit() and condition_unit_type(hex) and condition_health(hex):
				hex.setState({'cover':hex.targetOther , 'target' :true})
			else:
				hex.setState({'cover':Color(0,0,0,0) , 'target' :false})
		elif target_player==1:
			if hex.has_opposing_unit() and condition_unit_type(hex) and condition_health(hex):
				hex.setState({'cover':hex.targetOther , 'target' :true})
			else:
				hex.setState({'cover':Color(0,0,0,0) , 'target' :false})
		elif target_player==2:
			if hex.has_unit() and  condition_unit_type(hex) and condition_health(hex):
				hex.setState({'cover':hex.targetOther , 'target' :true})
			else:
				hex.setState({'cover':Color(0,0,0,0) , 'target' :false})

func complete(target, set_state=null):
	var local = true
	var state = Game.get_state()
	if not set_state==null:
		state=set_state
		local= false
	var unit = Game.get_hex_by_id(target).get_unit()
	unit.life_change(health)
	if local:
		Game.send_action('delegate',45-target,{'delegate_id':entity.Hex.id,'delegate_node':get_name()+'/'+get_name()})
	Game.actionDone()
