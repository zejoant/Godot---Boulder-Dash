extends Node2D

var player = preload("res://Misc Objects/Player.tscn")
const gemAmount = 60
var collectedGems = 0
const lvlHeight = 21*16
const lvlWidth = 43*16
onready var palettes = {"interactive": [3, 1, 0, 0, 0, 0], "ground": [1, 0], "solid": [10, 1, 0]}

func _ready():
	VisualServer.set_default_clear_color(Color8(35, 38, 47, 255))
	assignPalette()
	
	yield(get_tree().create_timer(1/60), "timeout")
	var loadedPlayer = player.instance()
	loadedPlayer.position = Vector2(8*16, 10*16)
	loadedPlayer.get_node("Camera2D/CanvasLayer/Control/GemAmount").text = "0/" + str(gemAmount)
	loadedPlayer.get_node("Camera2D").limit_bottom = lvlHeight
	loadedPlayer.get_node("Camera2D").limit_right = lvlWidth
	add_child(loadedPlayer)

func addGem():
	collectedGems += 1
	if collectedGems >= gemAmount:
		get_node("Exit").open()

func assignPalette():
	get_node("DirtTiles").material.set_shader_param("tile1", palettes["ground"][0])
	get_node("SolidTiles").material.set_shader_param("tile1", palettes["solid"][0])
	get_node("SolidTiles").material.set_shader_param("tile2", palettes["solid"][1])
