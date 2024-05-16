extends Node2D
@onready var soundtrack =  $SoundtrackPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	soundtrack.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
