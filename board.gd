extends Node2D

onready var parent=get_parent()
onready var grid=get_child(0).get_children()
onready var adj = fill_adj(grid)



func _ready():
	set_process_input(true)
	pass

func _input(event):
	if event.is_action("click"):
		pass
		

##UTILITIES


###SETUP FUNCTIONS
func fill_adj(grid):
	var ret={}
	
	var rowSizes=[5,6,7,8,7,6,5]
	for i in range(0,grid.size()):
		var iSet=[]
		
		
		var pos=get_pos(i)
		#one row up if exists
		if pos[0]<=3:
			iSet.append(grid[get_i([pos[0]-1,pos[1]-1])]) if (pos[0]>0) and (pos[1]>0) else 0 
			iSet.append(grid[get_i([pos[0]-1,pos[1]])]) if (pos[0]>0) and (pos[1]<rowSizes[pos[0]]-1) else 0
		else:
			iSet.append(grid[get_i([pos[0]-1,pos[1]])]) if (pos[0]>0) else 0 
			iSet.append(grid[get_i([pos[0]-1,pos[1]+1])]) if (pos[0]>0) else 0
		
		#same row if exists
		iSet.append(grid[get_i(pos)-1]) if (get_i(pos)-1>=0) and (pos[1]>0) else 0
		iSet.append(grid[get_i(pos)+1]) if (get_i(pos)+1<grid.size()) and (pos[1]<rowSizes[pos[0]]-1) else 0
		
		#row below if exists
		if pos[0]>=3:
			iSet.append(grid[get_i([pos[0]+1,pos[1]-1])]) if (pos[0]<6) and (pos[1]>0) else 0 
			iSet.append(grid[get_i([pos[0]+1,pos[1]])]) if (pos[0]<6) and (pos[1]<rowSizes[pos[0]]-1) else 0
		else:
			iSet.append(grid[get_i([pos[0]+1,pos[1]])]) if (pos[0]<6) else 0 
			iSet.append(grid[get_i([pos[0]+1,pos[1]+1])]) if (pos[0]<6) else 0
		ret[i]=iSet
		grid[i].adjacent=iSet
		grid[i].call('connect',parent)
	
	return ret

#[row,col]=>i
func get_i(pos):
	var rowSizes=[5,6,7,8,7,6,5]
	var x=pos[0]
	var y=pos[1]
	while x>0:
		x-=1
		y+=rowSizes[x]
	return y

#i=>[row,col]
func get_pos(i):
	var rowSizes=[5,6,7,8,7,6,5]
	var x=0
	var t_i=i
	while t_i>=rowSizes[x]:
		t_i-=rowSizes[x]
		x+=1
	return [x,t_i]
