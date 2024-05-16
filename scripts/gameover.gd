extends Control

@onready var soundtrack =  $SoundtrackPlayer
@onready var death =  $DeathPlayer

func _ready():
	death.play()
	soundtrack.play()
	

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
