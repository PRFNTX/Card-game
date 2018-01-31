extends Node2D

export(String,"null","land","coin","card","lake","tree","sand","hill") var actionType


# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_process_input(true)


func _input(event):
	
	if (event.is_action("click")) and mouseover:
		#Input.action_press(actionType)
		pass


var mouseover=false

func _on_Area2D_mouse_entered():
	mouseover=true


func _on_Area2D_mouse_exited():
	mouseover=false
