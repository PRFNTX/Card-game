extends Node2D

onready var globals = get_node('/root/master')
onready var HTTP = get_node('/root/HTTP')

var method_login = true
func _ready():
	set_process_input(true)
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func request(endpoint):
	var err = 0
	var http = HTTPClient.new()
	http.set_blocking_mode(true)
	
	err = http.connect_to_host('34.217.125.226', 80)
	
	while( http.get_status()==HTTPClient.STATUS_CONNECTING or http.get_status()==HTTPClient.STATUS_RESOLVING):
		http.poll()
		print("Connecting..")
		OS.delay_msec(500)
	print(http.get_status())
	if not ( http.get_status() == HTTPClient.STATUS_CONNECTED ): # Could not connect
		return display_error("Could not connect...")
	var headers=[
		"User-Agent: Pirulo/1.0 (Godot)",
		"Accept: */*",
		"Content-Type: application/json; charset=utf-8"
	]
	var body = {'username':$username.text,'password':$password.text}
	print(to_json(body))
	err = http.request(HTTPClient.METHOD_POST,"/"+endpoint,headers, to_json(body)) 

	if not ( err == OK ): # Make sure all is OK
		return display_error("Not OK")
	while (http.get_status() == HTTPClient.STATUS_REQUESTING):
		# Keep polling until the request is going on
		http.poll()
		print("Requesting..")
		OS.delay_msec(500)


	if not (http.get_status() == HTTPClient.STATUS_BODY or http.get_status() == HTTPClient.STATUS_CONNECTED ): # Make sure request finished well.
		return display_error("Request Failure. No Response?")
		
	print("response? ",http.has_response()) # Site might not have a response.
	
	
	
	if (http.has_response()):
		headers = http.get_response_headers_as_dictionary()
		print("code: ", http.get_response_code())
		print("**headers:\\n", headers)
		if (headers.keys().has('authenticate')):
			HTTP.authentication_token = headers['authenticate']
	
			globals.set_scene('title')

	
			if (http.is_response_chunked()):
				print('response is chunked')
			else:
				var b1 = http.get_response_body_length()
				print("response length: ",b1)
		
			var rb = PoolByteArray()
		
			while (http.get_status()==HTTPClient.STATUS_BODY):
				http.poll()
				var chunk = http.read_response_body_chunk()
				if (chunk.size()==0):
					OS.delay_usec(1000)
				else:
					rb = rb+chunk
				
			globals.user = parse_json(str((rb.get_string_from_utf8())))
		
			globals.init_user()
		
		
		

func display_error(err):
	$Message.text = err

func _on_Button_pressed():
	if $username.text.length()>0 and $password.text.length()>0:
		if method_login:
			request('login')
		else:
			request('register')


func _on_Register_pressed():
	method_login = false
	$Exiting.show()
	$Register.hide()
	$lbl_confirm.show()
	$confirm.show()




func _on_Exiting_pressed():
	method_login = false
	$Exiting.hide()
	$Register.show()
	$lbl_confirm.hide()
	$confirm.hide()

func _input(event):
	if event.is_action("ui_accept"):
		_on_Button_pressed()