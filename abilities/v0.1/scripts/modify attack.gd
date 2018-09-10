extends Node

export(int) var mod = 2
export(String) var identifier = "misc"

var Game
var entity

func activate(_Game,_entity,target):
	entity=_entity
	Game=entity.Game
	
#	if target.Hex.id==1 or target.Hex.id ==44:
		#entity.Unit.current_attack+=2
		#up = true

var up =false
func end():
	if up:
		entity.Unit.current_attack-=2
		up = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

