extends Node2D

var player = preload("res://Misc Objects/Player.tscn")
const gemAmount = 14
var collectedGems = 0
const lvlHeight = 19*16
const lvlWidth = 40*16
onready var palettes = {"interactive": [0, 1, 0, 0, 0, 0], "ground": [6, 0], "solid": [6, -7, -9]}

func _ready():
	VisualServer.set_default_clear_color(Color8(69, 48, 73, 255))
	assignPalette()
	
	yield(get_tree(), "idle_frame")
	var loadedPlayer = player.instance()
	loadedPlayer.position = Vector2(10*16, 1*16)
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
	get_node("SolidTiles").material.set_shader_param("tile3", palettes["solid"][2])
