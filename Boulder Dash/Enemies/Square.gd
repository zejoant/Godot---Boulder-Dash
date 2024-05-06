extends KinematicBody2D

const tileSize = 16
onready var ray = $RayCast2D
var dir = Vector2.LEFT
var delay = 11
var choices = [Vector2.DOWN, Vector2.UP]
var dirtTiles
var solidTiles
var dying = false
var touchingWall = true

onready var particles = get_node("ParticleNode")
var explodeSound = preload("res://Audio/explosion.mp3")

func _ready():
	yield(get_tree(), "idle_frame")
	dirtTiles = get_parent().get_node("DirtTiles")
	solidTiles = get_parent().get_node("SolidTiles")

func _process(_delta):
	if !dying:
		if dir == Vector2.LEFT:
			choices = [Vector2.DOWN, Vector2.UP]
		elif dir == Vector2.DOWN:
			choices = [Vector2.RIGHT, Vector2.LEFT]
		elif dir == Vector2.RIGHT:
			choices = [Vector2.UP, Vector2.DOWN]
		elif dir == Vector2.UP:
			choices = [Vector2.LEFT, Vector2.RIGHT]
		
		ray_update(choices[0], Vector2.ZERO)
		if ray.is_colliding() and ray.get_collider().is_in_group("Player"): #kills player if its planning on going into it next move
			ray.get_collider().die()
			die()
				
		if delay == 0:
			delay = 12
				
			ray_update(choices[0], Vector2.ZERO)
			if !ray.is_colliding() and touchingWall: #check if it leaves a wall and should change direction
				dir = choices[0]
				particleDir()
				touchingWall = false
				return
				
			ray_update(dir, Vector2.ZERO)
			if ray.is_colliding() and !ray.get_collider().is_in_group("Player"): #checks if it hits a wall and should change direction
				dir = choices[1]
				particleDir()
				return
			
			ray_update(dir, Vector2.ZERO)
			if !ray.is_colliding() or ray.get_collider().is_in_group("Player"): #moves towards its direction if it doesnt hit a wall
				position += dir * tileSize
				touchingWall = true
				
			if ray.is_colliding() and ray.get_collider().is_in_group("Player"): #kills player if it hits it
				ray.get_collider().die()
				die()
		delay -= 1
	
func die():
	if !dying:
		playSound(explodeSound)
		dying = true
		delay = 999999
		var world = get_world_2d().get_direct_space_state()
		var collider
		visible = false
		
		for i in range(-1, 2):
			for j in range(-1, 2):
				dirtTiles.set_cell(position.x/tileSize + i, position.y/tileSize + j, -1)
				dirtTiles.update_bitmask_region(Vector2(position.x/16-1, position.y/16-1), Vector2(position.x/16+1, position.y/16+1))
				solidTiles.set_cell(position.x/tileSize + i, position.y/tileSize + j, -1)
				var intersectingTile = world.intersect_point(Vector2(position.x+i*tileSize, position.y+j*tileSize), 1)
				if intersectingTile != []:
					collider = intersectingTile[0]["collider"]
					if collider.is_in_group("Player") and !collider.dying:
						collider.die()
					if collider.is_in_group("Enemy"):
						collider.die()
					elif collider.is_in_group("FallingBlock"):
						collider.queue_free()

func ray_update(direction, pos): #change ray cast or pos
	ray.cast_to = direction * (tileSize)
	ray.position = pos * tileSize
	ray.force_raycast_update()

func _on_AudioStreamPlayer2D_finished():
	if dying:
		queue_free()

func playSound(sound):
	if $AudioStreamPlayer2D.stream != sound:
		$AudioStreamPlayer2D.stream = sound
	$AudioStreamPlayer2D.play()
	
func particleDir():
	if dir != Vector2.ZERO:
		if dir == Vector2.LEFT:
			particles.rotation_degrees = 0
		if dir == Vector2.DOWN:
			particles.rotation_degrees = -90
		if dir == Vector2.RIGHT:
			particles.rotation_degrees = 180
		if dir == Vector2.UP:
			particles.rotation_degrees = 90
