extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(int) var mod = 2
export(String) var identifier = "misc"
export(int, "orb", "building") var target_type = 0

var Game
var entity

func activate(_Game,_entity,target):
	entity=_entity
	Game=entity.Game
	
	if (
		target_type == 0 and (target.Hex.id==1 or target.Hex.id ==44)
		or target_type == 1 and (target.Hex.get_unit().Unit.is_building and not target.Hex.get_unit().Unit.is_orb)
	):
		entity.Unit.current_attack+=2
		up = true

var up =false
func end():
	if up:
		entity.Unit.current_attack-=2
		up = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

