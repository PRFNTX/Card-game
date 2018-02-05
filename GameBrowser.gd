extends Node2D

onready var globals = get_node('/root/master')

var socket_events = ['join','close','leave','start','open','collision']
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var state= {'show_owner':null,'show_challenger':null,'is_owner':false}

func setState(newState):
	for key in newState.keys():
		call(key,newState[key])

###STATE FUNCTIONS

func show_owner(val):
	state['show_owner']=val
	if not val==nul:
		$Owner/lbl_Name.text=val
		$Owner.show()
	else:
		$Owner.hide()

func show_challenger(val):
	state['show_challenger']=val
	if not val==nul:
		$Challenger/lbl_Name.text=val
		$Challenger.show()
		$Games.hide()
	else:
		$Challenger.hide()

func is_owner(boo):
	state['is_owner']=boo
	if boo:
		$Games.hide()
	else:
		$Games.show()




########
func _ready():
	globals.get_games()
	for game in globals.open_games.keys():
		$Games/Games.add_item(game)
		


###EVENTS

func join(value):
	if not is_owner:
		$Games.hide()
		$Challenger/lbl_Name.text = "THIS IS YOU"
		$Challenger.show()
		$Owner/lblName.text = event[value]
	else:
		$Challenger/lbl_Name.text = value
		$Challenger.show()

func collision(val):
	$Games/GameName.text = ""
	$Games/GameName.placeholder_text = "Game: "+val+", name taken"

func create(val):
	setState({'show_owner':"This is you",'is_owner':true})

func leave(val):
	setState({'show_challenger':null})

func close(val):
	setState({'show_owner':null,'show_challenger':null,'is_owner':false})

func start(val):
	globals.set_scene('Game')



func _on_Join_pressed():
	var game
	if $Games/Games.get_selected_items().size()>0:
		game = $Games/Games.get_selected_items()[0].get
		globals.send_msg(to_json({'join':game}))


func _on_Create_pressed():
	var game
	if $Games/GameName.text.length()>0:
		game = $Games/Games.get_selected_items()[0].get
		globals.send_msg(to_json({'create':game}))


func _on_Games_item_selected( index ):
	var game = $Games/Games.get_item_text(index)
	var game_owner = globals.open_games[game]
