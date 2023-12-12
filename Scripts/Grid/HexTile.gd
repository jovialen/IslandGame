extends Node3D
class_name Tile

var coords : Vector2
var biome : Biome

@onready var mesh_instance_3d = $MeshInstance3D


func _ready():
	mesh_instance_3d.set_surface_override_material(0, biome.material)
