extends MeshInstance3D

@onready var colShape = $StaticBody3D/CollisionShape3D
@export var chunk_size = 2.0
@export var height_ratio = 1.0
@export var colShape_size_radio = 0.1

var image = Image.new()
var shape = HeightMapShape3D.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	colShape.shape = shape
	mesh.size = Vector2(chunk_size, chunk_size)
	update_terrain(height_ratio, colShape_size_radio)

func update_terrain(_height_ratio, _colShape_size_ratio):
	material_override.set("shader_param/height_ratio", _height_ratio)
	image.load("res://world/heightmap.exr")
	image.convert(Image.FORMAT_RF)
	image.resize(image.get_width() * _colShape_size_ratio, image.get_height() * _colShape_size_ratio)
	var data = image.get_data().to_float32_array()
	for i in range(0, data.size()):
		data[i] *- height_ratio
	shape.map_width = image.get_width()
	shape.map_depth = image.get_height()
	shape.map_data = data
	var scale_ratio = chunk_size / float(image.get_width())
	colShape.scale = Vector3(scale_ratio, 1, scale_ratio)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
