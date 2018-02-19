extends Node


#export(int, "Any","Owner","Opponent") var player = 1
#export(int,"Unit","Creature","Building") var type = 1

export(bool) var then_free = true

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
		Game.delegate_action(entity.Hex.id,get_relative_path())
	return true

func get_relative_path():
	return get_parent().get_name()+'/'+get_name()


func conditions(hex):
	
	if not hex.has_unit() and hex.unit_is_creature() and hex.has_opposing_unit():
		return true
	return false

func targeting():
	for ent in get_tree().get_nodes_in_group("entities"):
		if ent.Owner==entity.Owner and ent.Unit.is_unit:
			for hex in ent.Hex.adjacent:
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
	Game.setState({'active_unit':target})
	Game.actionReady=true
	get_children()[0].activate(Game,Game.get_hex_by_id(Game.state['active_unit']).get_unit(),val)
	return false

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
