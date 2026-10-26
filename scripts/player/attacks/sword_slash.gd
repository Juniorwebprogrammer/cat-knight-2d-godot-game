class_name SwordSlash
extends PlayerAttack

@onready var hitbox: Area2D = $Hitbox


func _on_setup() -> void:
	hitbox.set_meta("damage", damage)
	hitbox.monitorable = false


func _on_start() -> void:
	hitbox.scale.x = player.get_facing_direction()


func _set_hit_active(active: bool) -> void:
	hitbox.set_deferred("monitorable", active)
