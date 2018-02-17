extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_action('click'):
		get_parent().complete_action_click()
	elif event is InputEventMouseMotion and not get_parent().gameNode.stateLocal['hovered']:
		get_parent().gameNode.setState({'hovered':get_parent().id})