extends Node

export(int) var mod = 2
export(String) var identifier = "misc"

var entity
var Game

func init(_entity):
	entity=_entity
	Game = entity.Game

func activate(type,target,set_state=null):
	entity.Unit.set_mod_att({'identifier':identifier,'mod':mod})

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

