extends Node2D

var current_card
export(bool) var activatable = true
var card_entity
var board_entity
var base_entity
var actions = {}

onready var globals = get_node('/root/master')


func set_card(card_name, from='hand'):
	pass
		

func get_abilities():
	pass

func on_cast():
	pass
	

func empty():
	for child in get_children():
		child.queue_free()

func _ready():
	
	pass


