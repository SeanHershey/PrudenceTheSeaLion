extends Control

@onready var soundtrack =  $SoundtrackPlayer

func _ready():
	soundtrack.play()
	

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
