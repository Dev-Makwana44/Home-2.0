class_name SinglePlayerMenu
extends Control

@onready var saves_container = $"ScrollContainer/Saves Container"

#func _ready() -> void:
	#var save_file = FileAccess.open("user://temp.save", FileAccess.WRITE)
	#var string = JSON.stringify({"a": 10, "b": 11, "c": 12})
	#var string2 = JSON.stringify({"a": 11, "b": 12, "c": 13})
	#save_file.store_line(string)
	#save_file.store_line(string2)
	#print("saved")

class CustomButton extends Button:
	signal custom_pressed(button: CustomButton)
	
	func _ready() -> void:
		self.pressed.connect(self.custom_button_pressed)
	
	func custom_button_pressed():
		self.custom_pressed.emit(self)

func _ready() -> void:
	#var save_files: PackedStringArray = DirAccess.get_files_at("user://saves")
	var save_files: Array[String] = []
	save_files.assign(DirAccess.get_files_at("user://saves"))
	for file_name: String in save_files:
		var button: CustomButton = CustomButton.new()
		button.text = file_name.get_basename()
		button.custom_pressed.connect(self._button_pressed)
		button.focus_mode = Control.FOCUS_NONE
		button.custom_minimum_size = Vector2(0, 50)
		self.saves_container.add_child(button)
		
func _button_pressed(button: Button) -> void:
	
	print(button.text)
