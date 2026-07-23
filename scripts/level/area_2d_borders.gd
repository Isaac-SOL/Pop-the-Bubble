extends Area2D

func _on_area_shape_entered(_area_rid: RID, area: Area2D, _area_shape_index: int, local_shape_index: int) -> void:
	if area is Bubble:
		var owner_id := shape_find_owner(local_shape_index)
		var border : CollisionShape2D = shape_owner_get_owner(owner_id)
		match border.name:
			"LeftBorder":
				area.velocity.x = abs(area.velocity.x)
			"RightBorder":
				area.velocity.x = -abs(area.velocity.x)
			"TopBorder":
				area.velocity.y = abs(area.velocity.y)
			"BottomBorder":
				area.velocity.y = -abs(area.velocity.y)
