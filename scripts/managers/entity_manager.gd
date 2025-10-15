extends Node

var player: PlayerEntity
func create_player():
	player = Const.Entities.player.instantiate() as PlayerEntity

func create_entity(template):
	return template.instantiate()
