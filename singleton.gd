extends Node


onready var HTTP = get_node('/root/HTTP')

var scenes = {'game':"res://Game.tscn",'title':'res://Title.tscn', 'deck':'res://EditDeck.tscn','login':'res://Login.tscn','browse_games':'res://GameBrowser.tscn'}
var card_resources = {}

var Deck = {}
var deck_list=null
var user
var websocket

func set_deck_list(parsedjson):
	deck_list={}
	for deck in parsedjson:
		deck_list[deck['deck_name']] = deck['cards']
	print(deck_list)

var currentScene

func _ready():
	load_cards()
	websocket = preload('res://Godot-Websocket/websocket.gd').new(self)
	#get_tree().change_scene(scenes['login'])
	

var socket_active = false
func socket_start():
	if !socket_active:
		websocket.start('54.244.61.234',443)
		websocket.set_reciever(self,'_on_message_recieved')
		websocket.send({'greeting':user.username})
		socket_active=true


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


#### GET GAME LIST
var open_games
func get_games():
	send_msg({"game_list":""})

### SCENES
func set_scene(scene):
	get_tree().change_scene(scenes[scene])




#CHAT CHANNELS
#join_chat
#leave_chat
#msg_channel

#GAMES
#join
#leave
#close
#start
#open
#collision

#ACTIONS
#actions
func send_msg(value):
	websocket.send(value)

func _on_message_recieved(msg):
	print(msg)
	var event = parse_json(msg)
	var action = event.keys()[0]
	call(action,event[action])
	if get_tree().get_current_scene().has_method(action):
		get_tree().get_current_scene().call(action,event[action])

###OTHER

func hello(val):
	print('hello')

func invalid(val):
	print("UNRECOGNIZED MESSAGE ID")

func game_list(val):
	open_games = val

##CHATS
func join_chat(val):
	pass

func leave_chat(val):
	pass

func msg_channel(val):
	pass


var Game_player_num = null
### GAMES
func join(val):
	pass

func leave(val):
	pass

func close(val):
	pass

func start(val):
	pass

func create(val):
	pass

func collision(val):
	pass


