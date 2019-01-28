extends Node

export(bool) var require_valid_placement = true
export(bool) var require_plain_for_special = false
export(int,"Owner","Opponent") var targ_owner = 0
export(int,"Plains","Lake","Tree","Hill", "Sand") var type = 0

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
	return true


func conditions(hex):
	
	if hex.hexType.child.ActionLand(self, entity.Owner):
		return true
	if hex.hexType.child.actionTree and activePlayerCanAffect(entity.Owner):
		return true

func targeting():
	for hex in get_tree().get_nodes_in_group("Hex"):
		if conditions(hex):
			hex.setState({'cover':hex.gather , 'target' :true})
		else:
			hex.setState({'cover':Color(0,0,0,0) , 'target' :false})

func complete(target, set_state=null):
	
	var local = true
	var state = Game.get_state()
	setState({'cover': entity.Hex.gather, 'target':true, 'hex_owner':entity.Owner})
	Game.update_lands_owned()
	if local:
		Game.send_action('delegate',remote_convert(target),{'delegate_id':remote_convert(entity.Hex.id), 'delegate_node':get_parent().get_name()+'/'+get_name()})
	
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

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
