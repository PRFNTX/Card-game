extends Node

func start_action(Game):
	Game.start_unit_action('moveBase')

func get_action_type():
	return('moveBase')

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
