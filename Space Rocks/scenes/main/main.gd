extends Node

@export var rock_scene : PackedScene
var level = 0
var score = 0
var playing = false

var screensize = Vector2.ZERO

func _ready():
	screensize = get_viewport().get_visible_rect().size
	for i in 3:
		spawn_rock(3)
		
func spawn_rock(size, pos=null, vel=null):
	if pos == null: 
		$RockPath/RockSpawn.progress = randi()
		pos = $RockPath/RockSpawn.position
	if vel == null:
		vel = Vector2.RIGHT.rotated(randf_range(0, TAU)) * randf_range(50,125)
	var r = rock_scene.instantiate()
	r.screensize = screensize
	r.start(pos, vel, size)
	call_deferred("add_child", r)
	r.exploded.connect(self._on_rock_exploded)
	
func _on_rock_exploded(size, radius, pos, vel):
	score += 1
	$Hud.update_score(score)
	if size <= 1:
		return
	for offset in [-1, 1]:
		var dir = $Player.position.direction_to(pos).orthogonal() * offset
		var newpos = pos + dir * radius
		var newvel = dir * vel.length() * 1.1
		spawn_rock(size - 1, newpos, newvel)
		
func new_game():
	# remove old rocks
	get_tree().call_group("rocks", "queue_free")
	level = 0
	score = 0
	$Hud.update_score(score)
	$Hud.show_message("Get Ready!")
	$Player.reset
	await $Hud/Timer.timeout
	playing = true

func new_level():
	if level > 0:
		score += 15
	$Hud.update_score(score)
	level += 1
	$Hud.show_message("Wave %s" % level)
	for i in level:
		spawn_rock(3)

func _process(delta):
	if not playing:
		return
	if get_tree().get_nodes_in_group("rocks").size() == 0:
		new_level()

func game_over():
	playing = false
	$Hud.game_over()



