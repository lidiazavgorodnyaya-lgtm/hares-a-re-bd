@tool
extends TextureRect

@export_tool_button(
	"Установить точку поворота по центру", "Callable"
	) var a: Callable = set_pivot_to_center

@export_range(-1.,1,1) var rotation_direction: int
@export_exp_easing("inout") var rotation_speed: float = 1

func _ready() -> void:
	set_pivot_to_center()


func _physics_process(delta: float) -> void:
	rotation = (rotation - rotation_direction * delta * rotation_speed)
	if rotation_degrees > 360.:
		rotation = 0.
		rotation_degrees = 0.
	if rotation_degrees < -360.:
		rotation = 360.
		rotation_degrees = 360.

## Устанавливает точку поворота ровно по центру текстуры
func set_pivot_to_center() -> void:
	pivot_offset = size * 0.5
