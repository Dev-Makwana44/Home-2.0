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
	
	var modified_time: int
	
	func _ready() -> void:
		self.pressed.connect(self.custom_button_pressed)
	
	func custom_button_pressed():
		self.custom_pressed.emit(self)
	
	#func set_path(path: String):
		#self.text = text.get_basename()
		#self.modified_time = FileAccess.get_modified_time(text)

func _ready() -> void:
	#var save_files: PackedStringArray = DirAccess.get_files_at("user://saves")
	var save_files: Array[String] = []
	save_files.assign(DirAccess.get_files_at("user://saves"))
	var buttons: Array[CustomButton] = []
	
	for file_name: String in save_files:
		var button: CustomButton = CustomButton.new()
		button.modified_time = FileAccess.get_modified_time(file_name)
		button.text = file_name.get_basename()
		button.custom_pressed.connect(self._button_pressed)
		button.focus_mode = Control.FOCUS_NONE
		button.custom_minimum_size = Vector2(0, 50)
		buttons.append(button)
	
	buttons.sort_custom(self.button_custom_sort)
	
	for button: CustomButton in buttons:
		self.saves_container.add_child(button)
		
func _button_pressed(button: CustomButton) -> void:
	print(button.modified_time)

func button_custom_sort(a: CustomButton, b: CustomButton) -> bool:
	return a.modified_time < b.modified_time
