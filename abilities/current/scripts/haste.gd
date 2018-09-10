extends Node

func activate(Game,entity,unused):
	entity.Unit.add_one_energy()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


