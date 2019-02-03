extends Node


onready var HTTP = get_node('/root/HTTP')

onready var frame = load('res://Assets/Round.png')
onready var card_img_ld = load('res://Assets/TownBasic.png')
onready var farmermer = load('res://Cards/Farmer.tscn')

var scenes = {'game':"res://Game.tscn",'title':'res://Title.tscn', 'deck':'res://EditDeck.tscn','login':'res://Login.tscn','browse_games':'res://GameBrowser.tscn'}
var card_resources = {}
var card_instances = {}

var Deck = {}
var deck_list=null
var user
var websocket

var socket_on = true

func set_deck_list(parsedjson):
	deck_list={}
	for deck in parsedjson:
		deck_list[deck['deck_name']] = deck['cards']

func get_card_by_id(id):
	for card in card_instances.keys():
		var cn = card_instances[card].get_node('Card')
		if cn.card_number==int(id):
			return cn.card_name

func get_id_by_name(name):
	return card_instances[name].get_node('Card').card_number

var currentScene

##TESTING
func start_solo_game():
	var scene = set_scene('game', true)
	

func _ready():
	var cards_script = get_node('/root/card_loader')
	card_resources = cards_script.cards
	for card in card_resources.keys():
		card_instances[card]= card_resources[card].instance()
	websocket = WebSocketClient.new()
	websocket.transfer_mode = websocket.TRANSFER_MODE_RELIABLE


func init_user():
	set_deck_list(HTTP.authenticated_server_request("/decks",HTTPClient.METHOD_GET,{}))
	socket_start()

var socket_active = false
###
func send_data(data):
	websocket.get_peer(1).set_write_mode(0)
	var data_to_write = data.to_utf8()
	websocket.get_peer(1).put_packet(data_to_write)

func _get_data():
	var data = ""
	while websocket.get_peer(1).get_available_packet_count()>0:
		data+= websocket.get_peer(1).get_packet().get_string_from_utf8()
	_on_message_recieved(data)
##
func socket_start():
	print('starting socket')
	if !socket_active:
		set_process(true)
		websocket.connect_to_url('34.217.125.226:443')
		websocket.connect('data_received', self, '_get_data')
		websocket.connect('connection_established', self, '_on_socket_ready')
		websocket.connect('connection_error', self, '_on_error')

func on_error():
	print('there was an error!')

func _on_socket_ready(protocol):
	print(protocol)
	print('connected')
	send_msg({'greeting':user.username})
	socket_active=true

func _process(delta):
	if websocket.get_connection_status() == WebSocketClient.CONNECTION_DISCONNECTED:
		return
	websocket.poll()



###NEVER RUNS
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
####


#### GET GAME LIST
var open_games
func get_games():
	send_msg({"game_list":""})

### SCENES
"""
func change_scene(scene_path, solo=false):
	call_deferred("change_scene_deferred", scene_path, solo) # waits until an idle period when nodes can be removed safely


onready var current_scene = get_tree().get_root().get_node("Login")
func change_scene_deferred(scene_path, solo=false):
	# remove current scene
	current_scene.free()

	# instance new scene
	var s = load(scene_path)
	current_scene = s.instance()

	# add new scene to main node
	get_tree().get_root().add_child(current_scene)
	if solo:
		current_scene.testing_solo = true
	return current_scene
"""
func set_scene(scene, solo=false):
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
#activations
func send_msg(value):
	var json_value = JSON.print(value)
	if socket_on:
		send_data(json_value)
	pass

func _on_message_recieved(msg):
	var event = parse_json(msg)
	print(event)
	if event:
		var action = event.keys()[0]
		call(action,event[action])
		print(get_tree().get_current_scene())
		if get_tree().get_current_scene().has_method(action):
			get_tree().get_current_scene().call(action,event[action])

###OTHER

func hello(val):
	print('hello')

func invalid(val):
	print("UNRECOGNIZED MESSAGE ID")

func game_list(val):
	open_games = val

func game_action(val):
	pass

func game_cast(val):
	pass

func game_activation(val):
	pass

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

var player_num
func start(val):
	player_num = int(val)
	set_scene('game')


func create(val):
	pass

func collision(val):
	pass

func ready(val):
	pass

func deck(val):
	pass


