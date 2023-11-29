extends Node3D

@export_category("Camera Movement")
@export var movementTime : float = 1
@export var movementSpeed : float = 1
@export var rotationTime : float = 1
@export var rotationSpeed : float = 1
@export var mouseSpeed : float = 1
@export var zoomSpeed : float = 1
@export var zoomTime : float = 1

@onready var camera_3d = $Camera3D

var newPosition : Vector3
var newAngle : float
var newTilt : float
var newDistance : float

var dragging := false
var dragStartPos : Vector3
var dragPos : Vector3

var rotating := false
var lastMousePos : Vector2


func _ready():
	newPosition = position
	newAngle = camera_3d.angle
	newTilt = camera_3d.tilt
	newDistance = camera_3d.distance


func _physics_process(delta):
	_handle_mouse_movement()
	_handle_movement()
	_update_position(delta)


func _handle_mouse_movement():
	var zoomDirection = 0
	if Input.is_action_just_released("zoom_in"): zoomDirection = -1
	elif Input.is_action_just_released("zoom_out"): zoomDirection = 1
	
	newDistance = maxf(newDistance + zoomDirection * zoomSpeed, 0.0)
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and !dragging:
		dragStartPos = cast_ray_to_terrain()
		dragging = true
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		dragPos = cast_ray_to_terrain()
		newPosition = position + dragStartPos - dragPos
	else:
		dragging = false
	
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and !rotating:
		var mousePos = get_viewport().get_mouse_position()
		lastMousePos = mousePos
		rotating = true
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		var mousePos = get_viewport().get_mouse_position()
		var offset = mousePos - lastMousePos
		lastMousePos = mousePos
		
		var angleDirection = -offset.x * mouseSpeed
		var tiltDirection = offset.y * mouseSpeed

		newAngle += angleDirection * rotationSpeed
		newTilt = clampf(newTilt + tiltDirection * rotationSpeed, 1, 89)
	else:
		rotating = false


func _handle_movement():
	var movementDirection = Input.get_vector("left", "right", "up", "down")
	var angleDirection = Input.get_axis("rotate_anticlockwise", "rotate_clockwise")
	var tiltDirection = Input.get_axis("tilt_down", "tilt_up")
	
	var angle = camera_3d.angle
	newAngle += angleDirection * rotationSpeed
	
	newTilt = clampf(newTilt + tiltDirection * rotationSpeed, 1, 89)
	
	movementDirection = movementDirection.rotated(-deg_to_rad(angle)) * newDistance
	newPosition.x += movementDirection.x * movementSpeed
	newPosition.z += movementDirection.y * movementSpeed


func _update_position(delta):
	position = lerp(position, newPosition, delta * movementTime)
	camera_3d.angle = lerp(camera_3d.angle, newAngle, delta * rotationTime)
	camera_3d.tilt = lerp(camera_3d.tilt, newTilt, delta * rotationTime)
	camera_3d.distance = lerp(camera_3d.distance, newDistance, delta * zoomTime)


func cast_ray_to_terrain():
	var mousePos = get_viewport().get_mouse_position()
	var origin = camera_3d.project_ray_origin(mousePos)
	var direction = camera_3d.project_ray_normal(mousePos)
	
	if direction.y == 0:
		direction.y = 0.0001
	
	var distance = -origin.y / direction.y
	var result = origin + direction * distance
	
	return result
