extends Node2D

var singleton

func _ready():
	singleton = get_node('/root/master')
	

func _on_game_pressed():
	singleton.set_scene('game')


func _on_deck_pressed():
	singleton.set_scene('deck')
