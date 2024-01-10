extends Area2D

var screensize = Vector2.ZERO

func _on_area_entered(area):
	if area.is_in_group("player"):
		position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
