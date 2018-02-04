extends Node

func start_action(Game):
	if get_parent().get_parent().collect:
		Game.start_unit_action('AttackAdjOrCollect')
	else:
		Game.start_unit_action('AttackAdj')

func get_action_type():
	if get_parent().get_parent().collect:
		return('AttackAdjOrCollect')
	else:
		return('AttackAdj')

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
