extends Node

var authentication_token

var scenes = {'game':"res://Game.tscn",'title':'res://Title.tscn', 'deck':'res://EditDeck.tscn','login':'res://Login.tscn'}
var card_resources = {}

var Deck = {}
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var currentScene

func _ready():
	load_cards()
	#get_tree().change_scene(scenes['login'])
	

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

func set_scene(scene):
	get_tree().change_scene(scenes[scene])

func authenticated_server_request(endpoint,method,body):
	var err = 0
	var http = HTTPClient.new()
	
	err = http.connect_to_host('localhost',8080)
	
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
	print(rb.get_string_from_utf8())
	return rb
