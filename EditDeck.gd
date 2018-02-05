extends Node2D

onready var globals = get_node('/root/master')

export(PackedScene) var DeckListEdit

var resources = {}
var cards = {}
var deck_list_local

var deck_nodes={}
var deck_lists={}

var state = {'current_deck':null}

func setState(newState):
	for key in newState.keys():
		call(key, newState[key])

func current_deck(deck):
	state['current_deck'] = deck
	

func cards_array_to_dict(arr):
	var dict_ret={}
	for card in arr:
		if dict_ret.keys().has(card):
			dict_ret[card]+=1
		else:
			dict_ret[card]=1
	return dict_ret

func initialize_decks():
	deck_list_local = globals.deck_list
	for deck in deck_list_local.keys():
		setState({'current_deck':deck})
		var new_deck_tab = DeckListEdit.instance()
		deck_nodes[deck] = new_deck_tab
		deck_lists[deck] = cards_array_to_dict(deck_list_local[deck])
		$Tabs.add_child(new_deck_tab)
		new_deck_tab.set_name(deck)
		new_deck_tab.top_level = self
		for card in deck_lists[deck]:
			update(card, deck)

func add_card(card_name,in_deck=null):
	var deck_name = in_deck
	if in_deck==null:
		deck_name =state['current_deck']
	
	if deck_lists[deck_name].keys().has(card_name):
		deck_lists[deck_name][card_name]+=1
		if deck_lists[deck_name][card_name]>3:
			deck_lists[deck_name][card_name]=3
	else:
		deck_lists[deck_name][card_name]=1

func remove_card(card_name,in_deck=null):
	var deck_name = in_deck
	if in_deck==null:
		deck_name =state['current_deck']
	
	if deck_lists[deck_name].keys().has(card_name):
		if deck_lists[deck_name][card_name]>1:
			deck_lists[deck_name][card_name]-=1
		else:
			deck_lists[deck_name].erase(card_name)

func update(card, t_deck=null):
	var deck = t_deck
	if t_deck==null:
		deck = state['current_deck']
	
	deck_nodes[deck].update(card, deck)
	$Collection.update(card, deck)


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
		$Collection.top_level=self
	initialize_decks()
	

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Done_pressed():
	globals.Deck = $Tabs.get_current_tab_control().get_name()
	globals.set_scene('game')
	#save deck to globals
	#change scene
	


func _on_Save_pressed():
	var deck_name = $Name.text
	var list = []
	for key in deck_lists[state['current_deck']].keys():
		for i in deck_lists[state['current_deck']][key]:
			list.append(key)
	globals.deck_list[state['current_deck']] = list
	globals.authenticated_server_request("/decks/"+deck_name,HTTPClient.METHOD_POST,{'cards':list})
