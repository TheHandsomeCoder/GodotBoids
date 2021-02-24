extends KinematicBody2D
const SPEED = 100
const COLLISION_RADIUS = 50
var _turn_speed = 100
var _target = Vector2()
var velocity = Vector2()
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var _screen_size = get_viewport_rect().size
	var x = rand_range(10, _screen_size.x - 10)
	var y = rand_range(10, _screen_size.y - 10)
	rotation += rand_range(-PI, PI)
	position = Vector2(x, y)	
	
func _process(delta: float) -> void:	
	position = _calcAcceleration(delta);
	position = wrapBorders(position)
	
func _calcAcceleration(delta: float) -> Vector2:
	var flock = getFlock()
	var coh = _calculateCohesion(flock)
	var sep = _calculateSeparation(flock)
	var ali = _calculateAlignment(flock)
	velocity = (Vector2.ZERO+coh+sep+ali).normalized()		
	look_at(velocity * 1000)
#	velocity += Vector2(SPEED, 0).rotated(rotation)
	return position + velocity * delta * SPEED
	
func wrapBorders(postion: Vector2) -> Vector2:
	var _screen_size = get_viewport_rect().size
	if(position.x > _screen_size.x):
		position.x = 0
	if(position.x < 0):
		position.x = _screen_size.x
	if(position.y > _screen_size.y):
		position.y = 0
	if(position.y < 0):
		position.y = _screen_size.y
	return position
	
func getFlock() -> Array:
	var flock = self.get_parent().get_children()
	var neighbors = []
	
	for boid in flock:
		var dist = position.distance_to(boid.position)
		if (boid != self && dist > 0 && dist <= COLLISION_RADIUS):
			neighbors.append(boid)
	return neighbors

func _calculateCohesion(flock: Array) -> Vector2:
	var coh = Vector2.ZERO
	
	if (flock.size() == 0):
		return 	coh
	
	for boid in flock:
		coh += boid.position

	coh = coh / flock.size()
	coh = coh - position
	
	return coh.normalized()

func _calculateSeparation(flock: Array) -> Vector2:
	var sep = Vector2.ZERO
	
	if (flock.size() == 0):
		return 	sep

	var count = 0;
	for boid in flock:
		var towardsMe: Vector2 = position - boid.position
		if towardsMe.length() > 0:
			sep += (towardsMe.normalized() / towardsMe.length())
			
	return sep.normalized()

func _calculateAlignment(flock: Array) -> Vector2:
	var ali = Vector2.ZERO
	
	if (flock.size() == 0):
		return 	ali
	
	for boid in flock:
		ali += boid.velocity
			
	return ali.normalized()
