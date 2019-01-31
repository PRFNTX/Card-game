extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(int) var lifeloss = 1

func activate(Game,entity,unused):
	entity.life_change(-1*lifeloss)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


