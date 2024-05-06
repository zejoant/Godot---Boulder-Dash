extends Node2D

var player = preload("res://Misc Objects/Player.tscn")
const gemAmount = 6
var collectedGems = 0
const lvlHeight = 16*22
const lvlWidth = 16*40
onready var palettes = {"interactive": [1, 1, 0, 0, 0, 0], "ground": [1, 1], "solid": [0, 0, 2]}

func _ready():
	VisualServer.set_default_clear_color(Color8(45, 56, 78, 255))
	assignPalette()
	
	yield(get_tree(), "idle_frame")
	var loadedPlayer = player.instance()
	loadedPlayer.position = Vector2(20*16, 18*16)
	loadedPlayer.get_node("Camera2D/CanvasLayer/Control/GemAmount").text = "0/" + str(gemAmount)
	loadedPlayer.get_node("Camera2D").limit_bottom = lvlHeight
	loadedPlayer.get_node("Camera2D").limit_right = lvlWidth
	add_child(loadedPlayer)

func addGem():
	collectedGems += 1
	if collectedGems >= gemAmount:
		get_node("Exit").open()
	
func assignPalette():
	get_node("DirtTiles").material.set_shader_param("tile2", palettes["ground"][1])
	get_node("DirtTiles").material.set_shader_param("tile1", palettes["ground"][0])
	get_node("SolidTiles").material.set_shader_param("tile3", palettes["solid"][2])
