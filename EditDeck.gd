extends Node2D

onready var singleton = get_node('/root/master')

var resources = {}
var cards = {}
const dirPath='res://cards/'

var Deck={}

func add_card(name):
	if Deck.keys().has(name):
		Deck[name]+=1
		if Deck[name]>3:
			Deck[name]=3
	else:
		Deck[name]=1

func remove_card(name):
	if Deck.keys().has(name):
		if Deck[name]>1:
			Deck[name]-=1
		else:
			Deck.erase(name)

func update(card):
	$Deck.update(card)
	$Collection.update(card)

func load_cards():
	var dir = Directory.new()
	dir.open(dirPath)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while(file_name!=""):
		if dir.current_is_dir():
			pass
		else:
			resources[file_name.split('.')[0]]=load(dirPath+file_name)
		file_name = dir.get_next()

func populate_collection():
	resources.forEach

var shown_card = null
func show_card(card):
	remove_child(shown_card)
	add_child(cards[card])
	cards[card].position = $Display.position
	shown_card = card
	

func _ready():
	load_cards()
	for card in resources.keys():
		var newCard = resources[card].instance()
		cards[card] = newCard
		$Collection.add_item(cards[card])

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Done_pressed():
	singleton.Deck = Deck
	singleton.set_scene('game')
	#save deck to globals
	#change scene
	
