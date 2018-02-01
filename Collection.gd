extends Node
export(bool) var deck = false
var dy = 18
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
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

func update(mod_card):
	var par_deck = get_parent().Deck
	print(deck)
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
			add_item(get_parent().cards[card])
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
	var par=get_parent()
	if (shown_card!=null):
		shown_card.queue_free()
	shown_card = par.resources[card].instance()
	add_child(shown_card)
	shown_card.scale=Vector2(0.7,0.7)
	shown_card.position = $Display.position
	

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
	get_parent().add_card(card)
	get_parent().update(card)


func _on_remove_pressed():
	var card = $Name.get_item_text(active)
	get_parent().remove_card(card)
	get_parent().update(card)
