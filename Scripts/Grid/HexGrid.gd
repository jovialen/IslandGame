extends Node3D
class_name HexGrid

enum Orientation { FLAT, POINTY };

@export_category("Hex Grid")
@export var radius := 2
@export var orientation := Orientation.POINTY;
@export var tileSize := 2.0

var tiles = []

const HEX_TILE = preload("res://Scenes/Terrain/Tiles/HexTile.tscn")


func _ready():
	var size = radius * 2 + 1
	
	for x in range(size):
		tiles.append([])
		for y in range(size):
			tiles[x].append(null)
			if _in_radius(x, y):
				tiles[x][y] = _add_tile(x, y)


func _in_radius(xCoord, yCoord):
	var offset = _coord_to_position(xCoord - radius, yCoord - radius)
	print(offset)
	return offset.x ** 2 + offset.y ** 2 <= (radius * tileSize * 2) ** 2


func _add_tile(xCoord, yCoord):
	var instance = HEX_TILE.instantiate()
	
	var offset = _coord_to_position(xCoord - radius, yCoord - radius)
	instance.position = Vector3(offset.x, 0, offset.y)
	instance.scale *= tileSize
	instance.rotation.y = _rotation()
	
	instance.coords = Vector2(xCoord, yCoord)
	
	instance.name = "Tile " + String.num(xCoord) + " " + String.num(yCoord)
	add_child(instance, true)
	return instance


func _coord_to_position(xCoord, yCoord):
	if orientation == Orientation.FLAT:
		var x = tileSize * 3/2 * xCoord
		var y = tileSize * sqrt(3) * (yCoord + 0.5 * (xCoord&1))
	
		return Vector2(x, y)
	else:
		var x = tileSize * sqrt(3) * (xCoord + 0.5 * (yCoord&1))
		var y = tileSize * 3/2 * yCoord
		
		return Vector2(x, y)


func _rotation():
	if orientation == Orientation.FLAT:
		return deg_to_rad(90)
	else:
		return 0
