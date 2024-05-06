extends Node2D

var player = preload("res://Misc Objects/Player.tscn")
const gemAmount = 8
var collectedGems = 0
const lvlHeight = 16*21
const lvlWidth = 16*39
onready var palettes = {"interactive": [0, 2, 0, 0, 0, 0], "ground": [3, 0], "solid": [0, -5, 0]}

func _ready():
	VisualServer.set_default_clear_color(Color8(69, 48, 73, 255))
	assignPalette()
	
	yield(get_tree(), "idle_frame")
	var loadedPlayer = player.instance()
	loadedPlayer.position = Vector2(19*16, 10*16)
	loadedPlayer.get_node("Camera2D/CanvasLayer/Control/GemAmount").text = "0/" + str(gemAmount)
	loadedPlayer.get_node("Camera2D").limit_bottom = lvlHeight
	loadedPlayer.get_node("Camera2D").limit_right = lvlWidth
	add_child(loadedPlayer)

func addGem():
	collectedGems += 1
	if collectedGems >= gemAmount:
		get_node("Exit").open()

func assignPalette():
	get_node("SolidTiles").material.set_shader_param("tile2", palettes["solid"][1])
	get_node("SolidTiles").material.set_shader_param("tile3", palettes["solid"][2])
	get_node("DirtTiles").material.set_shader_param("tile1", palettes["ground"][0])
