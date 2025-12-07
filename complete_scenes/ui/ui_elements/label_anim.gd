@tool
class_name LabelAnim
extends Label

## Анимированная надпись
##
## При получении нового значения показывает анимацию
## добавления или убирания цифр до нужного количества


## Реальное значение
@export var currency_value_intended: float : set = _on_currency_value_intended_set
## Текущее отображаемое значение
var currency_value_current: float : set = _on_currency_value_current_set
## Анимация
var tween: Tween

## Устанавливает значение метки
func _on_currency_value_intended_set(new_value:float) -> void:
	currency_value_intended = new_value
	if tween:
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "currency_value_current", currency_value_intended, 3.0)

## Показывает текущее анимированное значение
func _on_currency_value_current_set(new_value: float) -> void:
	currency_value_current = new_value
	self.text = str(roundf(currency_value_current))
