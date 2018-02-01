extends Node
var scenes = {'game':"res://Game.tscn",'title':'res://Title.tscn', 'deck':'res://EditDeck.tscn'}

var Deck = {}
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var currentScene

func _ready():
	get_tree().change_scene(scenes['title'])
	pass
	

func set_scene(scene):
	get_tree().change_scene(scenes[scene])

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
