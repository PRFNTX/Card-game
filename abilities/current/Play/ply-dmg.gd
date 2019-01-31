extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(int) var damage =-1

export(int, 'Unit', 'Creature', 'Building') var target_type = 0
export(int, 'Owner', 'Opponent', "any") var target_player = 1 
export(bool) var adjacent_only = false

var entity
var Game
func init(_entity):
	entity = _entity
	Game = _entity.Game

func activate(_Game, _entity, val):
	Game = _Game
	entity = _entity
	Game.delegate_action(entity.Hex.id,get_parent().get_name()+'/'+get_name())


func targeting():
	for hex in get_tree().get_nodes_in_group("Hex"):
		if target_player==0:
			if hex.has_friendly_unit() and (target_type==0 or (target_type==1 and hex.unit_is_creature()) or (target_type==1 and hex.unit_is_building())) and (entity.Hex.adjacent.has(hex) or adjacent_only==false):
				hex.setState({'cover':hex.targetOther , 'target' :true})
			else:
				hex.setState({'cover':Color(0,0,0,0) , 'target' :false})
		elif target_player==1:
			if hex.has_opposing_unit() and (target_type==0 or (target_type==1 and hex.unit_is_creature()) or (target_type==1 and hex.unit_is_building())) and (entity.Hex.adjacent.has(hex) or adjacent_only==false):
				hex.setState({'cover':hex.targetOther , 'target' :true})
			else:
				hex.setState({'cover':Color(0,0,0,0) , 'target' :false})
		elif target_player==2:
			if hex.has_unit() and (target_type==0 or (target_type==1 and hex.unit_is_creature()) or (target_type==1 and hex.unit_is_building())) and (entity.Hex.adjacent.has(hex) or adjacent_only==false):
				hex.setState({'cover':hex.targetOther , 'target' :true})
			else:
				hex.setState({'cover':Color(0,0,0,0) , 'target' :false})

func complete(target, set_state=null):
	pay_costs()
	var local = true
	var state = Game.get_state()
	if not set_state==null:
		state=set_state
		local= false
	var unit = Game.get_hex_by_id(target).get_unit()
	unit.life_change(damage)
	if local:
		Game.send_action('delegate',45-target,{'delegate_id':entity.Hex.id,'delegate_node':get_name()+'/'+get_name()})
	Game.actionDone()
	

func cancel_action():
	pass
