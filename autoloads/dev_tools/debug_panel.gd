extends CanvasLayer

@onready var v_box_container: VBoxContainer = $Control/ScrollContainer/VBoxContainer



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_mod_toggle"):
		visible = !visible

## Показывает нужную информацию прямо на экран [br]
## Пример использования [br]
## [code]
## DebugPanel.show_debug_info([], 2)
## [/code]
func show_debug_info(new_data: Array, line: int) -> void:
	var debug_label: RichTextLabel = v_box_container.get_child(line)
	debug_label.text = array_to_string(new_data)


func array_to_string(arr: Array) -> String:
	var s: String = ""
	for i: Variant in arr:
		var temp: String = "{0}"
		s += temp.format([i], "{0}")
	return s
