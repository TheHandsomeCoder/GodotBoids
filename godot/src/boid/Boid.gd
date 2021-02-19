extends KinematicBody2D
var _speed = 100
var _turn_speed = 100
var _target = Vector2()
var _velocity = Vector2()
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var _screen_size = get_viewport_rect().size
	var x = rand_range(10, _screen_size.x - 10)
	var y = rand_range(10, _screen_size.y - 10)
	rotation += rand_range(-PI, PI)
	position = Vector2(x, y)
	_velocity = Vector2.ZERO
	
func _process(delta: float) -> void:	
	position = _updatePosition(position, _velocity, delta);
	

func _updatePosition(position: Vector2, velocity: Vector2, delta: float) -> Vector2:
	_velocity = Vector2.ZERO;
	var coh = _calculateCohesion()
	var sep = _calculateSeparation()
	print(coh, sep)
	_velocity = coh+sep
	_velocity = (_velocity - position).normalized() * _speed

	return position + _velocity * delta


func _updatePositionToFollowMouse(position: Vector2, velocity: Vector2, rotation: float, delta: float) -> Vector2:
	_target = get_global_mouse_position()
	if position.distance_to(_target) > 10:
		look_at(get_global_mouse_position())
		_velocity = (_target - position).normalized() * _speed
	else:
		_velocity = Vector2()
	pass
	return position + _velocity * delta

func _calculateCohesion() -> Vector2:
	var flock = self.get_parent().get_children()
	var targetPos = Vector2.ZERO
	for boid in flock:
		targetPos += boid.position
	
	return targetPos / flock.size()


# if ((d > 0) && (d < desiredseparation)) {
#        // Calculate vector pointing away from neighbor
#        PVector diff = PVector.sub(position, other.position);
#        diff.normalize();
#        diff.div(d);        // Weight by distance
#        steer.add(diff);
#        count++;            // Keep track of how many
#      }

func _calculateSeparation() -> Vector2:
	var minDistance = 25.0;
	var flock = self.get_parent().get_children()
	var targetPos = Vector2.ZERO
	var count = 0;
	for boid in flock:
		var distance = position.distance_to(boid.position)		
		if(distance > 0 && distance < minDistance):
			var differance: Vector2 = position - boid.position
			differance = differance.normalized()
			differance =  differance/distance
			targetPos += differance
			count += 1

	if(count > 0):
		 targetPos /= count;
	
	return targetPos.normalized() * _speed
		
