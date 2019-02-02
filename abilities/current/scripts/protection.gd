extends Node

export(int) var reduction = 1

export(String) var ab_name = ""
export(String) var ab_description = ""

func activate(Game,entity,damage):
	var newDamage = damage - reduction
	if newDamage < 0:
		return 0
	return newDamage
