extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(int) var health = 0
export(int) var attack = 1
export(int) var energy = 0
export(int,"All","Creature","Building") var type = 1
export(int,"All","Owner","Opponent") var player = 1
export(PackedScene) var unbuffer = null


var entity
var Game
func init(_entity):
	entity = _entity
	Game = entity.Game

func activate(_Game, _entity, unused):
	Game = _Game
	entity = _entity
	for ent in  get_tree().get_nodes_in_group("entities"):
		if conditions(ent):
			ent.life_change(health)
			var modName = ent.Unit.set_mod_att('kingsPraise', attack, true)
			if unbuffer != null:
				var attach_unbuffer = unbuffer.instance()
				attach_unbuffer.set_name(modName)
				attach_unbuffer.init(ent)
				ent.Unit.get_node("on_end_turn").add_child(attach_unbuffer)
				ent.Unit.on_end_turn = true
			for i in range(0, energy):
				ent.Unit.add_one_energy()
	return null

func conditions(ent):
	if player==0:
		if type==0:
			return true
		elif type==1 and ent.Unit.is_unit:
			return true
		elif type==2 and ent.Unit.is_building:
			return true
	elif (player==1 and ent.Owner==entity.Owner) or (player==2 and ent.Owner!=entity.Owner):
		if type==0:
			return true
		elif type==1 and ent.Unit.is_unit:
			return true
		elif type==2 and ent.Unit.is_building:
			return true
	return false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
