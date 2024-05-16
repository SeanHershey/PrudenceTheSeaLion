extends RigidBody2D

const WATER_CEIL = 100.0
const FLOAT = 450.0

func _id1 ():
	pass

func _id2 ():
	pass

func _id3 ():
	pass

func _id4 ():
	pass
	
func _id5 ():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.x > 1500 and position.x < 3300 and position.y > WATER_CEIL:
		apply_force(Vector2(0, -FLOAT))
	
