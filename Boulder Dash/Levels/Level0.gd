extends Node2D

var player = preload("res://Misc Objects/Player.tscn")
const gemAmount = 1
var collectedGems = 0
const lvlHeight = 13*16
const lvlWidth = 30*16
onready var palettes = {"interactive": [0, 0, 0, 0, 0, 0], "ground": [0, 0], "solid": [9, 0, 0]}

func _ready():
	VisualServer.set_default_clear_color(Color8(69, 48, 73, 255))
	assignPalette()
	
	yield(get_tree(), "idle_frame")
	var loadedPlayer = player.instance()
	loadedPlayer.position = Vector2(6*16, 6*16)
	loadedPlayer.get_node("Camera2D/CanvasLayer/Control/GemAmount").text = "0/" + str(gemAmount)
	loadedPlayer.get_node("Camera2D").limit_bottom = lvlHeight
	loadedPlayer.get_node("Camera2D").limit_right = lvlWidth
	add_child(loadedPlayer)

func addGem():
	collectedGems += 1
	if collectedGems >= gemAmount:
		get_node("Exit").open()

func assignPalette():
	get_node("SolidTiles").material.set_shader_param("tile1", palettes["solid"][0])
