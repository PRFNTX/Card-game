extends Node2D

var current_card

var card_entity
var actions = {}


func set_card(card, from='hand'):
	if from == 'hand':
		card_entity = card.duplicate(true)
		add_child(card_entity)
		card_entity.position = self.position
		actions['cast'] = Button.new()
		actions['cast'].connect('pressed', self, 'on_cast')

func on_cast():
	get_parent().delegate()
	

func _ready():
	
	pass


