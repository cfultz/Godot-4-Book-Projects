extends Node

@export var coin_scene : PackedScene
@export var powerup_scene : PackedScene
@export var cactus : PackedScene
@export var playtime = 30

var level = 1
var score = 0
var time_left = 0 
var screensize = Vector2.ZERO
var playing = false

func _process(delta):
	if playing and get_tree().get_nodes_in_group("coins").size() == 0:
		level += 1
		time_left += 5
		spawn_coins()

func _ready():
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide()

func new_game():
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.start()
	$Player.show()
	$GameTimer.start()
	spawn_coins()
	spawn_cacti()

func spawn_coins():
	$LevelSound.play()
	_on_powerup_timer_timeout()
	spawn_cacti()
	for i in level + 4:
		var c = coin_scene.instantiate()
		add_child(c)
		c.screensize = screensize
		c.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))

func _on_game_timer_timeout():
	time_left -= 1
	$HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()

func _on_player_hurt():
	game_over()

func _on_player_pickup(type):
	match type:
		"coin":
			score += 1
			$CoinSound.play()
			$HUD.update_score(score)
		"powerup":
			time_left += 5
			$PowerupSound.play()
			$HUD.update_timer(time_left)

func game_over():
	playing = false
	$GameTimer.stop()
	$EndSound.play()
	get_tree().call_group("coins", "queue_free")
	get_tree().call_group("obstacles", "queue_free")
	get_tree().call_group("powerups", "queue_free")
	$HUD.show_game_over()
	$Player.die()

func _on_hud_start_game():
	new_game()
	$HUD.update_score(score)
	$HUD.update_timer(time_left)

func _on_powerup_timer_timeout():
	var p = powerup_scene.instantiate()
	add_child(p)
	p.screensize = screensize
	p.position = Vector2(randi_range(100, screensize.x), randi_range(100, screensize.y))
	
func spawn_cacti():
	var cacti = cactus.instantiate()
	add_child(cacti)
	cacti.screensize = screensize
	cacti.position = Vector2(randi_range(100, screensize.x), randi_range(100, screensize.y))
