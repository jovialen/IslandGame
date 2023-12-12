extends Node3D
class_name HexGrid

enum Orientation { FLAT, POINTY };

@export_category("Hex Grid")
@export var radius := 2
@export var orientation := Orientation.POINTY;
@export var tileSize := 2.0
@export var biomes : Array[Biome] = []

const DESERT_BIOME : Biome = preload("res://Scenes/Terrain/Tiles/Desert.tres")

var tiles = []

const HEX_TILE = preload("res://Scenes/Terrain/Tiles/HexTile.tscn")


func _ready():
	var size = radius * 2 + 1
	var remainingBiomes = biomes.duplicate()
	
	for x in range(size):
		tiles.append([])
		for y in range(size):
			tiles[x].append(null)
			if _in_radius(x, y):
				var biome = _choose_biome(remainingBiomes)
				tiles[x][y] = _add_tile(x, y, biome)


func _choose_biome(remainingBiomes: Array[Biome]):
	if len(remainingBiomes) == 0:
		print("Not enough biomes to fill map; Defaulting to desert")
		return DESERT_BIOME
	
	var i = randi() % len(remainingBiomes)
	var biome = remainingBiomes[i]
	remainingBiomes[i].frequency -= 1
	if remainingBiomes[i].frequency == 0:
		remainingBiomes.pop_at(i)
	return biome


func _in_radius(xCoord, yCoord):
	var root = _coord_to_position(0, 0)
	var offset = _coord_to_position(xCoord - radius, yCoord - radius)
	return root.distance_to(offset) <= (radius * tileSize * 2) - 0.1


func _add_tile(xCoord, yCoord, biome):
	var instance = HEX_TILE.instantiate()
	
	# Position tile in the world
	var offset = _coord_to_position(xCoord - radius, yCoord - radius)
	instance.position = Vector3(offset.x, 0, offset.y)
	instance.scale *= tileSize
	instance.rotation.y = _rotation()
	
	# Prepare the tile for use
	instance.coords = Vector2(xCoord, yCoord)
	instance.biome = biome
	
	# Add the tile
	instance.name = "Tile " + String.num(xCoord) + "x" + String.num(yCoord)
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
