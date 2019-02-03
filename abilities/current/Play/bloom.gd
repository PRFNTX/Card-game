extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(bool) var require_valid_placement = true
export(bool) var require_plain_for_special = false
export(int,"Owner","Opponent") var targ_owner = 0
export(int, "empty", "orb","Plains","Lake","Tree","Hill", "Sand") var type = 0

export(int,"Gold","Faeria","Actions","Cards") var resource_type = 3
export(int) var value = 1

var type_convert = [2,3,4,5,6]

var entity
var Game
func init(_entity):
	entity = _entity
	Game = entity.Game

var val

func activate(_Game, _entity,_val):
	Game = _Game
	entity = _entity
	val=_val
	if entity.Owner==0:
		Game.delegate_action(entity.Hex.id,get_parent().get_name()+'/'+get_name())
	return false


func conditions(hex):
	if hex.hexType.child.ActionLand(hex, entity.Owner):
		return true
	if hex.hexType.child.actionTree and hex.activePlayerCanAffect(entity.Owner):
		return true

func targeting():
	for hex in get_tree().get_nodes_in_group("Hex"):
		if conditions(hex):
			hex.setState({'cover':hex.gather , 'target' :true})
		else:
			hex.setState({'cover':Color(0,0,0,0) , 'target' :false})

func gain_resource():
	if resource_type == 0:
		Game.players[entity.Owner].modCoin(value)
	elif resource_type==1:
		Game.players[entity.Owner].modFaeria(value)
	elif resource_type==2:
		Game.players[entity.Owner].modActions(value)
	elif resource_type==3:
		for i in value:
			Game.players[entity.Owner].drawCard()

func complete(target, set_state=null):
	var local = true
	var state = Game.get_state()
	if set_state!=null:
		local=false
		state=set_state
	var target_hex = Game.get_hex_by_id(target)
	target_hex.setState({'hex_type': type, 'hex_owner':entity.Owner})
	gain_resource()
	Game.update_lands_owned()
	if local:
		Game.send_action('delegate',remote_convert(target),{'delegate_id':remote_convert(entity.Hex.id), 'delegate_node':get_parent().get_name()+'/'+get_name(), 'frame_card':'Bloom'})
	
	entity.queue_free()
	Game.actionDone()
	return true

func remote_convert(hex_id):
	if hex_id==0:
		return 0
	else:
		return 45-hex_id

func cancel_action():
	pass
