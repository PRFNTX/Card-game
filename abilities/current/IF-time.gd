extends Node

export(bool) var night = 0
export(bool) var evening = 0
export(bool) var morning = 0

var Game
var entity
func init(_entity):
	entity = _entity
	Game = entity.Game

const MORNING = 0
const EVENING = 1
const NIGHT = 2

func activate(Game, entity, targ):
	var children = get_children()
	if condition():
		children[0].activate(Game, entity, targ)
	else:
		children[1].activate(Game, entity, targ)

func condition():
	var time = Game.state.clock_time
	return (
		time==MORNING and morning
		or time==EVENING and evening
		or time==NIGHT and night
	)