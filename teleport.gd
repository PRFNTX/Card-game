extends Node


# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export(int, 'empty', 'orb', 'land','lake','tree','hill','sand','well') var target_type = 3
export(int, 'Any', 'Owner', 'Opponent') var target_player = 0

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
	Game.delegate_action(entity.Hex.id,'on_play/target/teleport')



func targeting():
	for hex in get_tree().get_nodes_in_group("Hex"):
		if target_player==0:
			if hex.stateLocal['hex_type']==target_type and not hex.has_unit():
				hex.setState({'cover':hex.targetOther , 'target' :true})
			else:
				hex.setState({'cover':Color(0,0,0,0) , 'target' :false})
		elif (target_player==1 and hex.stateLocal['hex_owner']==entity.Owner) or (target_player==2 and hex.stateLocal['hex_owner']!=entity.Owner) and hex.stateLocal['hex_type']==target_type and not hex.has_unit():
			hex.setState({'cover':hex.targetOther , 'target' :true})
		else:
			hex.setState({'cover':Color(0,0,0,0) , 'target' :false})


func complete(target, set_state=null):
	
	var local = true
	var state = Game.get_state()
	if not set_state==null:
		state=set_state
		local= false
		
	var hex_target = get_hex_by_id(target)
	entity.on_move(hex_target.get_node('hexEntity'))
	if local:
		Game.send_action('hardMove',45-target,{'active_unit':entity.Hex.id})
	
	if get_parent().then_free:
		get_parent().queue_free()
	return true
	


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
