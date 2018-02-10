extends Node

export(int) var mod = 2
export(String) var identifier = "misc"

func activate(Game,entity,unused):
	entity.Unit.set_mod_Add({identifier:mod})

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

