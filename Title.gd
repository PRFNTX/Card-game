extends Node2D

var globals

func _ready():
	globals = get_node('/root/master')
	globals.set_deck_list(globals.authenticated_server_request("/decks",HTTPClient.METHOD_GET,{}))
	globals.socket_start()
	

func _on_game_pressed():
	globals.set_scene('game')


func _on_deck_pressed():
	globals.set_scene('deck')
