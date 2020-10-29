extends KinematicBody2D
var random = RandomNumberGenerator.new()
var _speed = 100
var _target = Vector2()
var _velocity = Vector2()
# Called when the node enters the scene tree for the first time.
func _ready():
	random.randomize()
	var _screen_size = get_viewport_rect().size
	var x = random.randf_range(10, _screen_size.x - 10)
	var y = random.randf_range(10, _screen_size.y - 10)
	position = Vector2(x, y)
	_velocity = position
	
func _process(delta: float) -> void:
	_target = get_global_mouse_position()
	if position.distance_to(_target) > 10:
		look_at(get_global_mouse_position())
		_velocity = (_target - position).normalized() * _speed
	else:
		_velocity = Vector2()
	pass
	position += _velocity * delta
