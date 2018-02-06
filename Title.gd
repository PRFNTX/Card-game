extends Node2D

var globals

func _ready():
	globals = get_node('/root/master')
	globals.set_deck_list(HTTP.authenticated_server_request("/decks",HTTPClient.METHOD_GET,{}))
	globals.socket_start()
	

func _on_game_pressed():
	globals.set_scene('browse_games')


func _on_deck_pressed():
	globals.set_scene('deck')
