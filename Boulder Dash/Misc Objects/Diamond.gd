extends KinematicBody2D

var delay = 12

var tileSize = 16
onready var ray = $RayCast2D
var isFalling = false

func _ready():
	position = position.snapped(Vector2.ONE * tileSize)
	position += Vector2.ONE * tileSize/2
	position = Vector2(0, 0)
	
func _physics_process(_delta):
	delay -= 1
	if delay == 0:
		delay = 12
		fall_check()
		
func ray_update(dir, pos): #change ray cast or pos
	ray.cast_to = dir * (tileSize)
	ray.position = pos * tileSize
	ray.force_raycast_update()

func fall_check():
	ray_update(Vector2.DOWN, Vector2.ZERO)
	if ray.is_colliding():
		if isFalling and ray.get_collider().has_method("die"): #check if it it should kill what it falls on
			ray.get_collider().die()
		else: #if what is falls on is not killable then it has found ground
			if isFalling:
				$AudioStreamPlayer2D.play()
			isFalling = false
	
	if !ray.is_colliding(): #if there is no block below
		fall_down()
		return
	elif ray.get_collider().is_in_group("UnstableGround"): #if there is an unstable block below
		ray_update(Vector2.LEFT, Vector2.ZERO)
		if !ray.is_colliding(): #if there is no block to the left
			ray_update(Vector2.DOWN, Vector2.LEFT)
			if !ray.is_colliding(): #if there is no block down to the left
				fall_left()
				return
		ray_update(Vector2.RIGHT, Vector2.ZERO)
		if !ray.is_colliding(): #if there is no block to the right
			ray_update(Vector2.DOWN, Vector2.RIGHT)
			if !ray.is_colliding(): #if there is no block down to the right
				fall_right()
				return
	
func fall_left():
	ray_update(Vector2.UP, Vector2.LEFT)
	if ray.is_colliding() and ray.get_collider().is_in_group("FallingBlock"): #if obj tries to fall down into that spot
		return false
	move(Vector2.LEFT)
	return true
	
func fall_right():
	ray_update(Vector2.RIGHT, Vector2.RIGHT)
	if ray.is_colliding() and ray.get_collider().is_in_group("FallingBlock"): #if obj tries to fall left into that spot
		ray_update(Vector2.DOWN, Vector2.RIGHT)
		if	!ray.is_colliding():
			return false

	ray_update(Vector2.UP, Vector2.RIGHT)
	if ray.is_colliding() and ray.get_collider().is_in_group("FallingBlock"): #if obj tries to fall down into that spot
		return false
	move(Vector2.RIGHT)
	return true

func fall_down():
	isFalling = true
	move(Vector2.DOWN)

func move(dir):
	position += dir * tileSize
					
func pushed(_unused):
	queue_free()
	return true
	
