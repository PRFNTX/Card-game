extends Node2D

export(int,"land","coin","card","lake","tree","sand","hill") var actionType


# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_process_input(true)


func _input(event):
	if event.is_action("click"):
		Input.action_press(actionType)
		Input.action_release(actionType)

var mouseover=false

func _on_Area2D_mouse_enter():
	mouseover=true


func _on_Area2D_mouse_exit():
	mouseover=false
