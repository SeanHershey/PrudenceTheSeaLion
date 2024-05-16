extends RigidBody2D

const WATER_CEIL = 110
const FLOAT = 500.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ((position.x > -460 and position.x < 1300) or global_position.x > 7000) and position.y > WATER_CEIL:
		apply_force(Vector2(0, -FLOAT))
	
