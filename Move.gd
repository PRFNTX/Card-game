extends Node

export(int,'None','Aquatic','Flying') var method = 0


func start_action(Game):
	if method == 0:
		Game.start_unit_action('moveBase')
	elif method == 1:
		Game.start_unit_action('moveAquatic')
	elif method == 2:
		Game.start_unit_action('moveFlying')

func get_action_type():
	if method == 0:
		return('moveBase')
	elif method == 1:
		return('moveAquatic')
	elif method == 2:
		return('moveFlying')
	

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
