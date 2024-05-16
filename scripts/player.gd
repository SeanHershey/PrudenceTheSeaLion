extends CharacterBody2D

const SPEED = 200.0
const SWIM_SPEED = 400.0
const SLIDE_SPEED = 400.0
const SLIDE_DUR = 85.0
const SWIM_FLOAT = 10.0
const WATER_CEIL = 460.0
const PUSH_FORCE = 10.0
const THROW_FORCE = 100.0
const SLIDE_PAUSE = 10.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var turn = true
var animating = 0
var sliding = 0
var slide_pause = 0
var walking = false
var swiming = false
var slide_dir = Vector2()
var water = false
var jump = true
var slide_sound_once = false

@onready var animated_sprite =  $AnimatedSprite2D
@onready var splash_sound =  $SplashPlayer
@onready var slide_sound =  $SlidePlayer
@onready var walk_sound =  $WalkPlayer
@onready var swim_sound =  $SwimPlayer

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider().name == "ConeBody" and Input.is_action_just_pressed("look"):
			$ConeSprite.visible = true
			c.get_collider().visible = false
			c.get_collider().set_collision_layer(2)
		elif c.get_collider() is RigidBody2D:
			if Input.is_action_pressed("look"):
				c.get_collider().apply_central_impulse(Vector2(0,-1) * THROW_FORCE)
			else:
				c.get_collider().apply_central_impulse(-c.get_normal() * PUSH_FORCE)
	
	if position.x > 5000 and position.x < 6000:
		if $ConeSprite.visible == false:
			get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	
	if position.x > 10000:
		get_tree().change_scene_to_file("res://scenes/win.tscn")

	if position.x < 2424 or (position.x > 3650 and position.x < 9000):
		if water == true:
			splash_sound.play()
			water = false
		land_movement(delta)
	else:
		if water == false:
			splash_sound.play()
			water = true
		if $ConeSprite.visible == true:
			$ConeSprite.visible = false
			self.get_parent().get_children()[5].get_children()[0].visible = true
			self.get_parent().get_children()[5].get_children()[0].set_collision_layer(17)
			self.get_parent().get_children()[5].get_children()[0].position = position
		water_movement(delta)
	
	
	
func land_movement(delta):
	swim_sound.stop()
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		self.get_parent().get_children()[11].visible = false
	if direction < 0:
		self.get_parent().get_children()[12].visible = false
	
	# Handle slide.
	if Input.is_action_just_pressed("slide") and is_on_floor():
		self.get_parent().get_children()[13].visible = false
		if slide_sound_once == false:
			slide_sound_once = true
			slide_sound.play()
		sliding = SLIDE_DUR
		slide_pause = SLIDE_PAUSE
		slide_dir = direction
		
		if $ConeSprite.visible == true:
			$ConeSprite.visible = false
			
			self.get_parent().get_children()[5].get_children()[0].visible = true
			self.get_parent().get_children()[5].get_children()[0].set_collision_layer(17)
			self.get_parent().get_children()[5].get_children()[0].position = position

	if Input.is_action_just_released("slide"):
		slide_sound_once = false
	
	# Turning
	if direction > 0:
		if turn == true:
			animating = 55
			turn = false
	elif direction < 0:
		if turn == false:
			animating = 55
			turn = true
	
	# Animate
	if sliding > 0:
		animated_sprite.play("slide")
		sliding -= 1
		slide_pause -= 1
	elif animating > 0:
		animated_sprite.play("turn")
		animating -= 1
		if animating == 1:
			if direction > 0:
				$ConeSprite.flip_h = true
				animated_sprite.flip_h = true
			elif direction < 0:
				$ConeSprite.flip_h = false
				animated_sprite.flip_h = false
	else:
		if direction == 0:
			if Input.is_action_pressed("look") and is_on_floor():
				self.get_parent().get_children()[10].visible = false
				animated_sprite.play("look")
				if $ConeSprite.visible == true:
					$ConeSprite.visible = false
					
					self.get_parent().get_children()[5].get_children()[0].visible = true
					self.get_parent().get_children()[5].get_children()[0].set_collision_layer(17)
					self.get_parent().get_children()[5].get_children()[0].position = position
			else:
				animated_sprite.play("idle")
		else:
			if position.x > 4250 and position.x < 4330 and direction > 0:
				if jump == true:
					animated_sprite.play("jump")
					jump = false
			else:
				jump = true
				animated_sprite.play("run")
	
	if direction:
		if walking == false and animating == 0:
			walk_sound.play()
			walking = true
		
		if sliding > 20 and sliding < SLIDE_DUR - 35:
			velocity.x = direction * SPEED
		elif sliding > 20 and sliding < SLIDE_DUR:
			velocity.x = slide_dir * (SLIDE_SPEED + SPEED) / 2
		elif animating == 0:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		walk_sound.stop()
		walking = false
		if animating == 0 and sliding == 0:
			if Input.is_action_pressed("look") and is_on_floor():
				animated_sprite.play("look")
			else:
				animated_sprite.play("idle")
		if sliding > 0:
			velocity.x = slide_dir * SLIDE_SPEED
		
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func water_movement(delta):
	walk_sound.stop()
	# Get the input direction and handle the movement/deceleration.
	var horizontal = Input.get_axis("move_left", "move_right")
	var vertical = Input.get_axis("swim_up", "swim_down")
	
	if horizontal > 0:
		if turn == true:
			animating = 15
			turn = false
	elif horizontal < 0:
		if turn == false:
			animating = 15
			turn = true
	
	if animating > 0:
		animated_sprite.play("swim_turn")
		animating -= 1
		if position.y < WATER_CEIL:
			position.y -= 2
		if animating == 1:
			if horizontal < 0:
				animated_sprite.flip_h = false
				$ConeSprite.flip_h = false
			elif horizontal > 0:
				animated_sprite.flip_h = true
				$ConeSprite.flip_h = true
	elif vertical < 0:
		animated_sprite.play("swim_up")
	elif vertical > 0:
		animated_sprite.play("swim_down")
	elif horizontal == 0:
		animated_sprite.play("swim")
	else:
		animated_sprite.play("swim_side")
	
	if horizontal:
		velocity.x = horizontal * SWIM_SPEED
		if swiming == false:
			swim_sound.play()
			swiming = true
	else:
		velocity.x = move_toward(velocity.x, 0, SWIM_FLOAT)
	
	if vertical and position.y > WATER_CEIL:
		if swiming == false:
			swim_sound.play()
			swiming = true
		velocity.y = vertical * SWIM_SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SWIM_SPEED)
		if position.y < WATER_CEIL + 60:
			velocity.y += gravity * 5 * delta
			
	if vertical == 0 and horizontal == 0:
		swiming = false
		swim_sound.stop()
	
	move_and_slide()
	
	
	
	
