extends Area2D

#Signals 

signal pickup
signal hurt

# Variables
@export var speed = 350
var velocity = Vector2.ZERO
var screensize = Vector2(480,720)

func _process(delta):

# Movement Code
	
	velocity = Input.get_vector("left", "right","up","down")
	position += velocity * speed * delta
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	position.normalized()
	
# Animations
	
	if velocity.length() > 0:
		$AnimatedSprite2D.animation = "run"
	else:
		$AnimatedSprite2D.animation = "idle"
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0
		
# Start Function

func start():
	set_process(true)
	position = screensize / 2
	$AnimatedSprite2D.animation = "idle"

# Die function

func die():
	$AnimatedSprite2D.animation = "hurt"
	set_process(false)

# Coins and death
func _on_area_entered(area):
	if area.is_in_group("coins"):
		area.pickup()
		pickup.emit("coin")
		
	if area.is_in_group("powerups"):
		area.pickup()
		pickup.emit("powerup")
		
	if area.is_in_group("cacti_remover"):
		area.pickup()
		pickup.emit("remover")
		
	if area.is_in_group("obstacles"):
		hurt.emit()
		die()
