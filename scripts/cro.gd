extends CharacterBody2D

@export var speed := 200
var random_point: Vector2
var can_move := false
var is_moving := false

var animals := ["penguin", "cat", "racoon"]
var animal : String
var sprite : AnimatedSprite2D

var waiting := false

func _ready() -> void:
	randomize()
	random_point = get_random_point()

	animal = animals.pick_random()
	for s in $sprites.get_children():
		if s.name == animal:
			sprite = s
			s.visible = true
		else:
			s.visible = false
			
	can_move = true


func _physics_process(_delta: float) -> void:
	if is_moving:
		sprite.play("run")
	else:
		sprite.play("idle")

	if global_position.distance_to(random_point) < 10 and not waiting:
		start_wait()
		return
		
	if not can_move:
		velocity = Vector2.ZERO
		return
		
	is_moving = true
	var dir := (random_point - global_position).normalized()
	velocity = dir * speed
	move_and_slide()
	
func start_wait() -> void:
	waiting = true
	can_move = false
	is_moving = false

	await get_tree().create_timer(randf_range(1.0, 2.5)).timeout

	random_point = get_random_point()
	can_move = true
	waiting = false

func get_random_point() -> Vector2:
	var viewport_size := get_viewport_rect().size
	var margin := 100

	return Vector2(
		randi_range(margin, viewport_size.x - margin),
		randi_range(margin, viewport_size.y - margin)
	)
