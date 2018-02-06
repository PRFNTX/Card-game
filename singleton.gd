extends Node

var authentication_token

var scenes = {'game':"res://Game.tscn",'title':'res://Title.tscn', 'deck':'res://EditDeck.tscn','login':'res://Login.tscn','browse_games':'res://GameBrowser.tscn'}
var card_resources = {}

var Deck = {}
var deck_list=null

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
	

func socket_start():
	websocket.start('54.244.61.234',443)
	websocket.set_reciever(self,'_on_message_recieved')
	websocket.send({'greeting':'prfntx'})


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


var open_games
func get_games():
	open_games = authenticated_server_request('/games',HTTPClient.METHOD_GET,{})


func set_scene(scene):
	get_tree().change_scene(scenes[scene])

func authenticated_server_request(endpoint,method,body):
	var err = 0
	var http = HTTPClient.new()
	
	err = http.connect_to_host('54.244.61.234',80)
	
	while( http.get_status()==HTTPClient.STATUS_CONNECTING or http.get_status()==HTTPClient.STATUS_RESOLVING):
		http.poll()
		print("Connecting..")
		OS.delay_msec(500)

	assert( http.get_status() == HTTPClient.STATUS_CONNECTED ) # Could not connect
	
	var headers=[
		"User-Agent: Pirulo/1.0 (Godot)",
		"Accept: */*",
		"Content-Type: application/json; charset=utf-8",
		"authenticate: "+authentication_token
	]
	
	
	err = http.request(method,endpoint,headers, to_json(body)) 

	assert( err == OK ) # Make sure all is OK

	while (http.get_status() == HTTPClient.STATUS_REQUESTING):
		# Keep polling until the request is going on
		http.poll()
		print("Requesting..")
		OS.delay_msec(500)


	assert( http.get_status() == HTTPClient.STATUS_BODY or http.get_status() == HTTPClient.STATUS_CONNECTED ) # Make sure request finished well.

	print("response? ",http.has_response()) # Site might not have a response.
	
	var rb = PoolByteArray()
	
	if (http.has_response()):
		headers = http.get_response_headers_as_dictionary()
		print("code: ", http.get_response_code())
		#print("**headers:\\n", headers)
		
		if (http.is_response_chunked()):
			print('response is chunked')
		else:
			var b1 = http.get_response_body_length()
			print("response length: ",b1)
		
		
		while (http.get_status()==HTTPClient.STATUS_BODY):
			http.poll()
			var chunk = http.read_response_body_chunk()
			if (chunk.size()==0):
				OS.delay_usec(1000)
			else:
				rb = rb+chunk
	var tryreturn = parse_json(str((rb.get_string_from_utf8())))
	
	#arrays of objects are arrays of dictionaries
	return parse_json(str((rb.get_string_from_utf8())))

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

func open(val):
	pass

func collision(val):
	pass


