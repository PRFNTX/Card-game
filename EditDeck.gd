extends Node2D

onready var globals = get_node('/root/master')

var resources = {}
var cards = {}


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


func populate_collection():
	resources.forEach

var shown_card = null
func show_card(card):
	remove_child(shown_card)
	add_child(cards[card])
	cards[card].position = $Display.position
	shown_card = card
	

func _ready():
	resources= globals.card_resources
	
	for card in resources.keys():
		var newCard = resources[card].instance()
		cards[card] = newCard
		$Collection.add_item(cards[card])

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Done_pressed():
	globals.Deck = Deck
	globals.set_scene('game')
	#save deck to globals
	#change scene
	


func _on_Save_pressed():
	var deck_name = $Name.text
	var list = []
	for key in Deck.keys():
		for i in Deck[key]:
			list.append(key)
	globals.authenticated_server_request("/decks/"+deck_name,HTTPClient.METHOD_POST,{'cards':list})
