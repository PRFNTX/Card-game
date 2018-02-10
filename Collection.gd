extends Control
export(bool) var deck = false
var dy = 18
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var top_level

func set_name(val):
	.set_name(val)
	$Rename.text=val

func init_deck():
	pass	

func add_item(card_node):
	var card = card_node.get_node('Card')
	$Gold.add_item(str(card.cost_gold))
	$Faeria.add_item(str(card.cost_faeria))
	$Name.add_item(card_node.get_name())
	$Attack.add_item(str(card.base_attack))
	$Health.add_item(str(card.base_health))
	$Type.add_item(str(card.lands_type))
	$Num.add_item(str(card.lands_num))
	$Deck.add_item(str(0))
	$Quant.add_item(str(3))
	

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func update(mod_card, in_deck=null):
	var node_name =get_name()
	var par_deck = top_level.deck_lists[top_level.state['current_deck']]
	
	if !in_deck==null:
		par_deck = top_level.deck_lists[in_deck]
	
	if (deck):
		$Gold.clear()
		$Faeria.clear()
		$Name.clear()
		$Attack.clear()
		$Health.clear()
		$Type.clear()
		$Num.clear()
		$Deck.clear()
		$Quant.clear()
		var line = 0
		for card in par_deck.keys():
			add_item(top_level.cards[card])
			$Deck.set_item_text(line, str(par_deck[card]))
			line+=1
		if active!=null and active<$Name.get_item_count():
			matchSelect(active)
		else:
			$add.hide()
			$remove.hide()
	else:
		for item in $Name.get_item_count():
			if $Name.get_item_text(item)==mod_card:
				if par_deck.keys().has(mod_card):
					$Deck.set_item_text(item, str(par_deck[mod_card]))
				else:
					$Deck.set_item_text(item, '0')
		
		


var shown_card = null
func show_card(card):
	var par=top_level
	if (shown_card!=null):
		shown_card.queue_free()
	shown_card = par.resources[card].instance()
	add_child(shown_card)
	shown_card.rect_scale=Vector2(2,2)
	shown_card.rect_position = $Display.position
	

var active = null
func matchSelect(num):
	active=num
	$Gold.select(num)
	$Faeria.select(num)
	$Name.select(num)
	$Attack.select(num)
	$Health.select(num)
	$Type.select(num)
	$Num.select(num)
	$Deck.select(num)
	$Quant.select(num)
	$add.show()
	$remove.show()
	$add.rect_position.y = $top.position.y+num*dy
	$remove.rect_position.y = $top.position.y+num*dy
	
	show_card($Name.get_item_text(num))
	


func _on_Gold_item_selected( index ):
	matchSelect(index)


func _on_Faeria_item_selected( index ):
	matchSelect(index)


func _on_Name_item_selected( index ):
	matchSelect(index)


func _on_Attack_item_selected( index ):
	matchSelect(index)


func _on_Health_item_selected( index ):
	matchSelect(index)


func _on_Type_item_selected( index ):
	matchSelect(index)


func _on_Num_item_selected( index ):
	matchSelect(index)


func _on_Deck_item_selected( index ):
	matchSelect(index)


func _on_Quant_item_selected( index ):
	matchSelect(index)


func _on_add_pressed():
	var card = $Name.get_item_text(active)
	top_level.add_card(card)
	top_level.update(card)


func _on_remove_pressed():
	var card = $Name.get_item_text(active)
	top_level.remove_card(card)
	top_level.update(card)


func _on_Save_Deck_pressed():
	var list = []
	for key in top_level.deck_lists[top_level.state['current_deck']].keys():
		for i in top_level.deck_lists[top_level.state['current_deck']][key]:
			list.append(key)
	print("/decks/"+top_level.state['current_deck'])
	top_level.HTTP.authenticated_server_request("/decks/"+top_level.state['current_deck'],HTTPClient.METHOD_PUT,{'cards':list,'deck_name':$Rename.text})
	set_name($Rename.text)
	top_level.globals.set_deck_list(top_level.HTTP.authenticated_server_request("/decks",HTTPClient.METHOD_GET,{}))
	top_level.initialize_decks(false)
