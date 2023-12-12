extends Node3D
class_name Tile

var coords : Vector2
var biome : Biome

@onready var mesh_instance_3d = $MeshInstance3D


func _ready():
	update_mesh()


func set_biome(newBiome):
	biome = newBiome
	update_mesh()


func update_mesh():
	mesh_instance_3d.set_surface_override_material(0, biome.material)
