extends Node2D

var currentLvl = 11
var lvl
onready var viewport = get_viewport()
var viewMode = 4
const viewSmall = Vector2(19*16, 19*16*9/16)
const viewMedium = Vector2(25*16, 25*16*9/16)
const viewLarge = Vector2(30*16, 30*16*9/16)

func _ready():
	yield(get_tree(), "idle_frame")
	get_tree().connect("screen_resized", self, "_screen_resized")
	#loadLevel()
	add_child(load("res://Menu Scenes/Home Menu.tscn").instance())

func loadLevel():
	lvl = load("res://Levels/Level" + str(currentLvl) + ".tscn").instance()
	add_child(lvl)
	yield(get_tree(), "idle_frame")
	_screen_resized()

func unloadLevel(levelChange):
	get_node("Level" + str(currentLvl)).queue_free()
	yield(get_tree(), "idle_frame")
	currentLvl += levelChange
	if currentLvl != 6:
		loadLevel()

func _screen_resized():
	if get_node_or_null("Level" + str(currentLvl)) != null:
		var level = get_node("Level" + str(currentLvl))
		if viewMode == 1 and sizeCheck(level, viewSmall):
			viewport.size = viewSmall
		elif viewMode == 2 and sizeCheck(level, viewMedium):
			viewport.size = viewMedium
		elif viewMode == 3 and sizeCheck(level, viewLarge):
			viewport.size = viewLarge
		elif viewMode == 4 or !sizeCheck(level, viewSmall) or !sizeCheck(level, viewMedium) or !sizeCheck(level, viewLarge):
			if level.lvlHeight < level.lvlWidth and level.lvlWidth >= level.lvlHeight*16/9:
				viewport.size = Vector2(level.lvlHeight*16/9, level.lvlHeight)
			else:
				viewport.size = Vector2(level.lvlWidth, level.lvlWidth*9/16)

func sizeCheck(l, mode):
	if mode.x <= l.lvlWidth and mode.y <= l.lvlHeight:
		return true
	return false
