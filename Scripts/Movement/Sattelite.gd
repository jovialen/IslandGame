extends Node3D

@export_category("Sattelite")
@export var anchor : Node3D
@export var distance := 1.0
@export_range(0, 360) var angle := 0.0
@export_range(1, 89) var tilt := 45.0


func _ready():
	if !anchor:
		anchor = get_parent_node_3d()


func _process(delta):
	var angle_r = deg_to_rad(angle)
	var tilt_r = deg_to_rad(tilt)
	
	var dv = distance * sin(tilt_r)
	var dh = distance * cos(tilt_r)
	
	var dx = dh * sin(angle_r)
	var dz = dh * cos(angle_r)
	
	var offset = Vector3(dx, dv, dz)
	look_at_from_position(anchor.position + offset, anchor.position)
