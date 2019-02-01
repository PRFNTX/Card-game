extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _input_event(viewport, event, shape_idx):
	var parent = get_parent()
	if event is InputEventMouseButton and event.is_action('click'):
		parent.complete_action_click(event)
	elif event is InputEventMouseMotion and not parent.stateLocal['hovered']:
		parent.gameNode.setState({'hovered':parent.id})