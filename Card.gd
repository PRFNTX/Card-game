extends Node2D

export(int) var card_number = 0

export(int) var base_health = 1
export(int) var base_attack = 1
export(int) var cost_gold = 1
export(int) var cost_faeria = 1
export(int) var lands_num = 1
export(int,'null','lake','tree','hill','sand') var lands_type = 0

export(Texture) var art
export(Texture) var base

var costIcons=["", load('res://icon.png'),load('res://icon.png'),load('res://icon.png'),load('res://icon.png')]

func _ready():
	$Base.texture = base
	$Art.texture = art
	
	$Health.text = str(base_health)
	$Attack.text = str(base_attack)
	$Faeria.text = str(cost_faeria)
	$Gold.text = str(cost_gold)
	
	var land_children = $Lands.get_children()
	var ith = 0
	for landIcon in land_children:
		if ith<lands_num and lands_type>0:
			landIcon.texture = costIcons[lands_type]
			landIcon.show()
		else:
			landIcon.hide()
		ith+=1

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
