extends Node

@export var rock_scene : PackedScene

var screensize = Vector2.ZERO

func _ready():
	screensize = get_viewport().get_visible_rect().size
	for i in 3:
		spawn_rocks(3)
		
func spawn_rocks(size, pos=null, vel=null):
	if pos == null: 
		$RockPath/RockSpawn.progress = randi()
		pos = $RockPath/RockSpawn.position
	if vel == null:
		vel = Vector2.RIGHT.rotated(randf_range(0, TAU)) * randf_range(50,125)
	var r = rock_scene.instantiate()
	r.screensize = screensize
	r.start(pos, vel, size)
	call_deferred("add_child", r)
