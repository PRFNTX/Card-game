extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

var Game
var entity
func init(_entity):
	entity=_entity
	Game=entity.Game

const TYPE_WELL = 7
func activate(type,target,set_state=null):
	if (
		(type=="AttackAdjOrCollect" and Game.get_hex_by_id(target).stateLocal.hex_type!=TYPE_WELL)
		or (type=="AttackAdj")
	):
		var state = Game.get_state()
		if set_state!=null:
			state=set_state
		var active = state.active_unit
		var target_unit = Game.get_hex_by_id(active).get_unit()
		if entity.get_energy()>=2 and entity.Owner == target_unit.Owner:
			entity.user_energy(2)
			target_unit.Unit.add_one_energy()
			


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
