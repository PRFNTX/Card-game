extends Node

export(int) var health_max = 5
export(bool) var max_inclusive = true
export(int) var health_min = 0
export(bool) var min_inclusive = true

func activate(Game, entity, target):
	var ret = true
	var hp = entity.Unit.current_health
	if not (hp < health_max or (max_inclusive and hp <= health_max)):
		return false
	if not (hp > health_min or (min_inclusive and hp >= health_min)):
		return false

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
