extends KinematicBody2D

const tileSize = 16
const inputs = {"move_right": Vector2.RIGHT,
			"move_left": Vector2.LEFT,
			"move_up": Vector2.UP,
			"move_down": Vector2.DOWN}
var firstInput = "none"
onready var ray = $RayCast2D
var dirtTiles
var solidTiles
var moveDelay = 0
var dying = false

var digSound = preload("res://Audio/dig2.mp3")
var diamondSound = preload("res://Audio/collectDiamond.mp3")
var dieSound = preload("res://Audio/explosion.mp3")

func _ready():
	position = position.snapped(Vector2.ONE * tileSize)
	dirtTiles = get_parent().get_node("DirtTiles")
	solidTiles = get_parent().get_node("SolidTiles")
		
func _unhandled_input(event):
	if !dying:
		if event.is_action_pressed("reset"):
			die()

		for dir in inputs.keys():
			if event.is_action_pressed(dir):
				moveCheck(dir)
	

#func _physics_process(_delta):
#	if !dying:
#		if Input.is_action_just_pressed("reset"):
#			die()
#
#		if moveDelay == 0 and firstInput != "none":
#			moveDelay = 10
#			move(firstInput)
#			print(firstInput)
#
#		if Input.is_action_just_pressed("move_right"):
#			firstInput = "move_right"
#		elif Input.is_action_just_pressed("move_left"):
#			firstInput = "move_left"
#		elif Input.is_action_just_pressed("move_up"):
#			firstInput = "move_up"
#		elif Input.is_action_just_pressed("move_down"):
#			firstInput = "move_down"
#
#		if Input.is_action_just_released("move_right"):
#			if Input.is_action_pressed("move_up"):
#				firstInput = "move_up"
#			elif Input.is_action_pressed("move_down"):
#				firstInput = "move_down"
#			elif Input.is_action_pressed("move_left"):
#				firstInput = "move_left"
#			else:
#				firstInput = "none"
#				moveDelay = 0
#
#		if Input.is_action_just_released("move_left"):
#			if Input.is_action_pressed("move_up"):
#				firstInput = "move_up"
#			elif Input.is_action_pressed("move_down"):
#				firstInput = "move_down"
#			elif Input.is_action_pressed("move_right"):
#				firstInput = "move_right"
#			else:
#				firstInput = "none"
#				moveDelay = 0
#
#		if Input.is_action_just_released("move_up"):
#			if Input.is_action_pressed("move_right"):
#				firstInput = "move_right"
#			elif Input.is_action_pressed("move_down"):
#				firstInput = "move_down"
#			elif Input.is_action_pressed("move_left"):
#				firstInput = "move_left"
#			else:
#				firstInput = "none"
#				moveDelay = 0
#
#		if Input.is_action_just_released("move_down"):
#			if Input.is_action_pressed("move_up"):
#				firstInput = "move_up"
#			elif Input.is_action_pressed("move_right"):
#				firstInput = "move_right"
#			elif Input.is_action_pressed("move_left"):
#				firstInput = "move_left"
#			else:
#				firstInput = "none"
#				moveDelay = 0
#
#		if moveDelay != 0:
#			moveDelay -= 1
#
#		#if Input.is_action_just_released("move_down") and Input.is_action_just_released("move_up") and Input.is_action_just_released("move_right") and Input.is_action_just_released("move_left"):
#		#	moveDelay = 0
		
		
		
#	for dir in inputs.keys():
#		if Input.is_action_pressed(dir):
#			if moveDelay == 0:
#				move(dir)
#				moveDelay += 10
#			moveDelay -= 1
#		if Input.is_action_just_released(dir):
#			moveDelay = 0
	
func moveCheck(dir):
	var moveAfterPush = false
	ray.cast_to = inputs[dir] * tileSize
	ray.force_raycast_update()
	
	if ray.is_colliding():
		if ray.get_collider().has_method("win") and get_parent().collectedGems >= get_parent().gemAmount:
			ray.get_collider().win()
			
		elif ray.get_collider().has_method("pushed"):
			moveAfterPush = ray.get_collider().pushed(dir)
			if ray.get_collider().is_in_group("Collectible"):
				playSound(diamondSound)
				get_parent().addGem()
				get_node("Camera2D/CanvasLayer/Control/GemAmount").text = str(get_parent().collectedGems) + "/"+ str(get_parent().gemAmount)
	
	if moveAfterPush or !ray.is_colliding():
		move(dir)
	
func move(dir):
	position += inputs[dir] * tileSize
	if dirtTiles.get_cell(position.x/tileSize, position.y/tileSize) != -1:
		playSound(digSound)
		dirtTiles.set_cell(position.x/tileSize, position.y/tileSize, -1)
		dirtTiles.update_bitmask_area(position/16)
	
func die():
	dying = true
	playSound(dieSound)
	for i in range(-1, 2):
		for j in range(-1, 2):
			ray.cast_to = Vector2(i, j) * tileSize
			ray.force_raycast_update()
			if ray.is_colliding() and ray.get_collider().is_in_group("FallingBlock"):
				ray.get_collider().queue_free()
			dirtTiles.set_cell(position.x/tileSize + i, position.y/tileSize + j, -1)
			solidTiles.set_cell(position.x/tileSize + i, position.y/tileSize + j, -1)
			visible = false
	dirtTiles.update_bitmask_region(Vector2(position.x/16-1, position.y/16-1), Vector2(position.x/16+1, position.y/16+1))
	yield(get_tree().create_timer(1), "timeout")
	get_node("/root/World").unloadLevel(0)
	return false

func playSound(sound):
	if !$AudioStreamPlayer2D.stream == diamondSound or !$AudioStreamPlayer2D.playing or sound == diamondSound or sound == dieSound:
		$AudioStreamPlayer2D.stream = sound
		$AudioStreamPlayer2D.play()
