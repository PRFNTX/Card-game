extends Node

var Game
var entity
func init(_entity):
	entity=_entity
	Game = entity.Game

func activate(_game, _entity, target):
	if entity.Owner == 0:
		Game.delegate_action(entity.Hex.id, get_parent().get_name()+'/'+get_name())
		return true

func targeting():
	for hex in get_tree().get_nodes_in_group('Hex'):
		hex.setState({'cover':Color(0,0,0,0) , 'target':false})
	for hex in entity.Hex.adjacent:
		if hex.stateLocal.hex_type == hex.STATE_EMPTY:
			hex.setState({'cover':hex.targetOther , 'target':true})
		else:
			hex.setState({'cover':Color(0,0,0,0) , 'target':false})

func complete(target, set_state=null):
	var local = true
	var state = Game.get_state()
	if not set_state==null:
		state=set_state
		local= false
	var from_hex = entity.Hex
	var to_hex = Game.get_hex_by_id(target)
	to_hex.setState({'hex_type':from_hex.stateLocal['hex_type'],'hex_owner':from_hex.stateLocal['hex_owner']})
	from_hex.setState({'hex_type':0,'hex_owner':-1})
	entity.on_move(to_hex.get_node('hexEntity'))
	if local:
		Game.send_action('moveHex',45-target,{'active_unit':45-state['delegate_id']},true)