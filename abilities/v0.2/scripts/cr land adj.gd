extends Node

export(int,'empty','null','land','lake','tree','hill','sand') var type = 2

var Game
var entity
func init(_entity):
	entity=_entity
	Game=entity.Game

func activate(Game,entity,loc):
	var try = false
	for hex in entity.Hex.adjacent:
		if hex.stateLocal['hex_type']==0:
			try=true
	if try and entity.Owner==0:
		Game.delegate_action(loc,get_parent().get_name()+'/'+get_name())
	return true

func remote_convert(hex_id):
	if hex_id==0:
		return 0
	else:
		return 45-hex_id

func targeting():
	for hex in entity.Hex.adjacent:
		if hex.stateLocal['hex_type']==0:
			hex.setState({'cover':hex.targetOther , 'target' :true})
		else: 
			hex.setState({'cover':Color(0,0,0,0) , 'target' :false})

func complete(target, set_state=null):
	var local= true
	var state=Game.get_state()
	if set_state!=null:
		local=false
		state=set_state
	
	Game.get_hex_by_id(target).setState({'hex_type':type})
	if local:
		Game.send_action('buildLand',remote_convert(target),{'current_turn':(state['current_turn']+1)%2})
		
	Game.actionDone()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
