extends Node
var scenes = {'game':"res://Game.tscn",'title':'res://Title.tscn', 'deck':'res://EditDeck.tscn'}
var card_resources = {}

var Deck = {}
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var currentScene

func _ready():
	load_cards()
	get_tree().change_scene(scenes['title'])
	
	pass

const dirPath='res://cards/'
func load_cards():
	var dir = Directory.new()
	dir.open(dirPath)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while(file_name!=""):
		if dir.current_is_dir():
			pass
		else:
			card_resources[file_name.split('.')[0]]=load(dirPath+file_name)
		file_name = dir.get_next()

func set_scene(scene):
	get_tree().change_scene(scenes[scene])

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
