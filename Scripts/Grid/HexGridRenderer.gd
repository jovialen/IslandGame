extends Node3D
class_name HexGridRenderer

@export_category("Hex Grid Renderer")
@export var hexGrid : HexGrid
@export var tileSize : float = 1

enum Orientation { FLAT, POINTY }
@export var orientation := Orientation.POINTY

const HEX_TILE := preload("res://Scenes/Terrain/Tiles/HexTile.tscn")

func _ready():
	var tileRotation = _get_rotation()
	var size = hexGrid.radius * 2 + 1
	for x in range(size):
		var xCoord = x - hexGrid.radius
		for y in range(size):
			var yCoord = y - hexGrid.radius
			var instance = HEX_TILE.instantiate()
			var offset = _get_position(xCoord, yCoord)
			instance.position = Vector3(offset.x, 0.0, offset.y)
			instance.scale *= tileSize
			instance.rotation.y = tileRotation
			add_child(instance)


func _get_position(xCoord, yCoord):
	if orientation == Orientation.FLAT:
		var x = tileSize * 3/2 * xCoord
		var y = tileSize * sqrt(3) * (yCoord + 0.5 * (xCoord&1))
	
		return Vector2(x, y)
	else:
		var x = tileSize * sqrt(3) * (xCoord + 0.5 * (yCoord&1))
		var y = tileSize * 3/2 * yCoord
		
		return Vector2(x, y)


func _get_rotation():
	if orientation == Orientation.FLAT:
		return deg_to_rad(90)
	else:
		return 0
