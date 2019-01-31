extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

func activate(Game,entity,unused):
	print ("PLAYER "+ str(entity.Owner) +" LOSES")
	get_node("/root/master").set_scene('title')

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
