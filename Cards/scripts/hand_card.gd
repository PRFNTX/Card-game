extends Control

var me

signal mouse_button


func in_hand(boo, num):
	set_process_input(boo)
	me = num

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _gui_input(event):
	if event is InputEventMouseMotion:
		emit_signal('mouse_entered', me)
	if event is InputEventMouseButton:
		emit_signal('mouse_button', me)