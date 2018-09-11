extends Node


export(int, "Any","Opponent","Owner") var player = 1
export(int,"Hex") var type = 0


export(bool) var then_free = false

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
	Game.newAction()
	if entity.Owner==0:
		Game.delegate_action(entity.Hex.id,get_parent().get_parent().get_name()+'/'+get_parent().get_name()+'/'+get_name())
	return true


func conditions(hex):
	if hex.stateLocal['hex_type']==0 and not hex.has_unit():
		return true
	return false

func targeting():
	for hex in Game.get_hex_by_id(Game.state['active_unit']).adjacent:
		if conditions(hex):
			hex.setState({'cover':hex.targetOther , 'target' :true})
		else:
			hex.setState({'cover':Color(0,0,0,0) , 'target' :false})



func complete(target, set_state=null):
	if get_parent().has_method('pay_costs'):
		get_parent().pay_costs()
	var local = true
	var state = Game.get_state()
	if not set_state==null:
		state=set_state
		local= false
	var from_hex = Game.get_hex_by_id(state['active_unit'])
	var to_hex = Game.get_hex_by_id(target)
	to_hex.setState({'hex_type':from_hex.stateLocal['hex_type'],'hex_owner':from_hex.stateLocal['hex_owner']})
	from_hex.setState({'hex_type':0,'hex_owner':-1})
	if from_hex.has_unit():
		from_hex.get_unit().on_move(to_hex.get_node('hexEntity'))
	if local:
		Game.send_action('moveHex',45-target,{'active_unit':45-state['active_unit']},true)
		if get_parent().repeat():
			return false
		elif then_free:
			entity.queue_free()
			return true
		else:
			return true


func cancel_action():
	Game.newAction()
	get_parent().iter-=1
	get_parent().activate(Game,entity,val)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
