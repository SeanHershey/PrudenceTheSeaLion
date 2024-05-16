extends Control

@onready var soundtrack =  $SoundtrackPlayer

func _ready():
	soundtrack.play()
	
func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_credits_pressed():
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
