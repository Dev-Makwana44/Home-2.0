class_name MainMenu
extends Control

@onready var singleplayer_menu = preload("res://UI/singleplayer_menu.tscn") as PackedScene

func _ready() -> void:
	if not DirAccess.dir_exists_absolute("user://saves"):
		DirAccess.make_dir_absolute("user://saves")

func _on_play_button_button_up() -> void:
	self.get_tree().change_scene_to_packed(singleplayer_menu)

func _on_settings_button_button_up() -> void:
	print("Entering settings")

func _on_quit_button_button_up() -> void:
	self.get_tree().quit()
