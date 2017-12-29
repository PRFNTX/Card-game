extends Sprite

export(int,"empty","orb","land","lake","tree","hill","sand","well") var type

export(bool) var moveWater=false
export(bool) var moveLand=false
export(bool) var moveAir=false
export(bool) var spawnsFaeria=false
export(bool) var buildAny=false
export(bool) var actionLand=false
export(bool) var buildSand=false
export(bool) var actionSand=false
export(bool) var buildTree=false
export(bool) var actionTree=false
export(bool) var buildHill=false
export(bool) var actionHill=false
export(bool) var buildLake=false
export(bool) var actionLake=false

func ActionLand(hex):
	if !actionLand:
		return false
	else:
		var ret = false
		for oneHex in hex.adjacent:
			print(oneHex.hexType.child.type)
			if oneHex.hexType.child.type>=1 and oneHex.hexType.child.type<=6:
				ret=true
		return ret

func _ready():
	print(type)
