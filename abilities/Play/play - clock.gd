extends Node

export(int, "Morning", "Evening", "Night") var set_time = 0

func activate(Game, entity, unused):
	Game.setState({'current_time':0})
	entity.queue_free()
	return null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
