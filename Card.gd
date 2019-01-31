extends Node2D

export(int) var card_number = 0

export(String) var card_name =""
export(String) var card_description = ""
export(int) var base_health = 1
export(int) var base_attack = 1
export(int) var cost_gold = 1
export(int) var cost_faeria = 1
export(int) var lands_num = 1
export(int,'null','lake','tree','hill','sand') var lands_type = 0

export(bool) var play_morning = true
export(bool) var play_evening = true
export(bool) var play_night = true

export(bool) var is_event = false

export(Texture) var art
export(Texture) var base

var costIcons=["", load('res://Assets/Icon_lake.png'),load('res://Assets/Icon_tree.png'),load('res://Assets/Icon_hill.png'),load('res://Assets/Icon_sand.png')]

export(PackedScene) var board_entity

func _ready():
	$Base.texture = base
	$Art.texture = art
	
	$Health.text = str(base_health)
	$Attack.text = str(base_attack)
	$Faeria.text = str(cost_faeria)
	$Gold.text = str(cost_gold)
	$Name.text = card_name
	
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
