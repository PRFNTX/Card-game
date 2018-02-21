extends Node


export(int, "Any","Opponent","Owner") var player = 1 #unused
export(int,"Hex") var type = 0 #unused
export(int, "land",'lake','tree','hill','sand') var change_to = 0



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
	if entity.Owner==0:
		Game.delegate_action(entity.Hex.id,get_parent().get_parent().get_name()+'/'+get_parent().get_name()+'/'+get_name())
	return true


func conditions(hex):
	if hex.stateLocal['hex_type']>2 and hex.stateLocal['hex_type']<7 and hex.id>0:
		return true
	return false

func targeting():
	for hex in get_tree().get_nodes_in_group('Hex'):
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
		
	Game.get_hex_by_id(target).setState({'hex_type':2+change_to})
	if local:
		Game.send_action('delegate',remote_convert(target),{'delegate_id':remote_convert(state['delegate_id']),'delegate_node':get_parent().get_parent().get_name()+'/'+get_parent().get_name()+'/'+get_name()})
		if get_parent().repeat():
			return false
		else:
			entity.queue_free()
			return true

func remote_convert(hex_id):
	if hex_id==0:
		return 0
	else:
		return 45-hex_id

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
