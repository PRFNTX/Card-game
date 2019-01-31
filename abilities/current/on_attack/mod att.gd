extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(int) var mod = 2
export(int,"Structure") var type = 0
export(String) var identifier = "misc"

var Game
var entity

func activate(_Game,_entity,target):
	entity=_entity
	Game=entity.Game
	
	if target.Unit.is_building and type == 0:
		entity.Unit.current_attack+=mod
		up = true

var up =false
func end():
	if up:
		entity.Unit.current_attack-=mod
		up = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

