tool
extends EditorScript

func _run():
	load_cards()


var dirPath='res://Cards/'
func load_cards():
	var dir = Directory.new()
	dir.open(dirPath)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	var new_script = File.new()
	new_script.open('res://card_loader.gd',File.WRITE)
	new_script.store_line('extends Node')
	new_script.store_line('var cards = {}')
	new_script.store_line('func _ready():')
	
	while(file_name!=""):
		if dir.current_is_dir():
			pass
		else:
			new_script.store_line('	cards["'+file_name.split('.')[0]+'"] = preload("'+dirPath+file_name.c_escape()+'")')
			new_script.store_line('	print("'+file_name.split('.')[0]+', loaded")')
		file_name = dir.get_next()

