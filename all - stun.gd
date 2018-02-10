extends Node

func activate(Game, entity, unused):
	for ent in get_tree().get_nodes_in_group("entities"):
		if ent.Owner==(Game['current_turn']+1)%2:
			ent.stunned = true
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
