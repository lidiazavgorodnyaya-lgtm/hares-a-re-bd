extends Node2D

## Второй вариант напольной ловушки
##
## Активируется один раз, при наступании
## Перезаряжается при покидании игроком зоны атаки

# TODO Узменять урон в зависимости от глубины подземелья
## Урон, наносимый ловушкой
@export var damage: int
## Игрок в зоне атаки
var on_the_sight: bool = false
## Список состояний
enum {IDLE, READY}
## Состояние ловушки (нужно, чтобы срабатывали правильные анимации
var trap_state : int= IDLE
## Список целей, что получат урон, если не уберутся вовремя
var target_list: Array[Node2D] = []

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	match trap_state:
		IDLE:
			pass
		READY:
			# Возвращаем ловушку на место
			if not on_the_sight:
				trap_state = IDLE
				animated_sprite_2d.play("spike_of")

func _on_damage_area_body_entered(body: Node2D) -> void:
	on_the_sight = true
	if body is BaseEntity:
		# Добавляем в список целей
		target_list.append(body)
	animated_sprite_2d.play("spike_on")

func _on_damage_area_body_exited(body: Node2D) -> void:
	if body is BaseEntity:
		# Удаляем из списка целей
		target_list.remove_at(target_list.find(body))
	on_the_sight = false


func _on_animated_sprite_2d_animation_finished() -> void:
	# Идея в том, что если игрок движется достаточно быстро,
	# он может перескочить ловушки раньше,  чем они активируются
	if animated_sprite_2d.animation == "spike_on":
		trap_state = READY
		if on_the_sight:
			damage_inflicted(damage)
	else:
		trap_state = IDLE


## Функция нанесения урона
func damage_inflicted(_damage: float) -> void:
	for body: Node2D in target_list:
		if body.has_signal("take_damage"):
			body.take_damage.emit(damage, Vector2i.ZERO)
	# После нанесения или выдвижения, урона ловушка выключается
	animated_sprite_2d.play("spike_of")
