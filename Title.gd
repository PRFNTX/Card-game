extends Node2D

onready var globals = get_node("/root/master")

func _ready():
	pass

func _on_game_pressed():
	globals.set_scene('browse_games')


func _on_deck_pressed():
	globals.set_scene('deck')
