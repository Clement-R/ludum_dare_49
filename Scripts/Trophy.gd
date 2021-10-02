extends RigidBody2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

export (Array, NodePath) var _left_fallen_nodes_paths
export (Array, NodePath) var _right_fallen_nodes_paths

var _bot_left: RayCast2D
var _bot_right : RayCast2D

var _left_fallen_raycasts
var _right_fallen_raycasts

var _space_state: Physics2DDirectSpaceState

var _in_zone = false
var _timer: Timer

func _ready() -> void:
	set_process(true)
	_bot_left = $BotLeft
	_bot_right = $BotRight
	_timer= $StableTimer
	
	_left_fallen_raycasts = Array()
	
	for node_path in _left_fallen_nodes_paths:
		var node = get_node(node_path) as RayCast2D
		_left_fallen_raycasts.append(node)
	
	_right_fallen_raycasts = Array()
	
	for node_path in _right_fallen_nodes_paths:
		var node = get_node(node_path) as RayCast2D
		_right_fallen_raycasts.append(node)
		
	_space_state = get_world_2d().direct_space_state

func _process(delta):
	update()
	
	if Input.is_key_pressed(KEY_E):
		get_tree().reload_current_scene()

func _physics_process(delta: float) -> void:
	if _timer.is_stopped() and _in_zone and is_stable():
		_timer.start()
	
	#TODO: send signal
	if is_fallen():
		print("lose")
		breakpoint

func is_fallen() -> bool:
	for raycast in _left_fallen_raycasts:
		if raycast.is_colliding():
			return true
		
	for raycast in _right_fallen_raycasts:
		if raycast.is_colliding():
			return true
		
	return false

func is_stable() -> bool:
	print(linear_velocity)
	var is_moving = linear_velocity.x > 0.01 or linear_velocity.x < -0.01 or linear_velocity.y > 0.01 or linear_velocity.y < -0.01
	return _bot_left.is_colliding() and _bot_right.is_colliding() and not is_moving

func _on_TrophyZone_body_entered(body: Node) -> void:
	_in_zone = true

func _on_TrophyZone_body_exited(body: Node) -> void:
	_in_zone = false

func _on_StableTimer_timeout() -> void:
	#TODO: send signal
	print("win")
	breakpoint