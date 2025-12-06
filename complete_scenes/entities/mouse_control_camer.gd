class_name MouseControlCamera
extends Camera2D

## Удобная камера
##
## Доступно масштабирование, управлением мышкой и стрелочками на клавиатуре

## Наклонить камеру в сторону мыши
@export var towards_the_mouse: bool = false
## Включить масштабирование колёсиком мыши
@export var mouse_wheel_scale: bool = true
## Перемещание камеры средней кнопкой мыши
@export var mouse_control_moving: bool = true
## Перемещание камеры стрелочками
@export var aarrows_control_moving: bool = true

## Скорость масштабирования при прокрутке
var zoom_speed: float = 0.1
## Максимальное отдаление
var zoom_min: float = 0.05
## Максимальное приближение
var zoom_max: float = 20.0
## Насколько быстро происходит перемещение при зажатой СКМ
var drag_sensitivity: float = 1.0

## Скорость перемещения стрелками
var speed: int = 10

## Для исключения ошибок масштабирования
var camera_zoom: Vector2 = zoom
## Шумовая карта для дрожания
var camera_shake_noise : FastNoiseLite

##
func _ready() -> void:
	camera_shake_noise = FastNoiseLite.new()
	pass


##
func _physics_process(_delta: float)-> void:
	if towards_the_mouse:
		var mouse_pos: Vector2 = get_global_mouse_position()
		offset.x = (mouse_pos.x - global_position.x)/(get_viewport().get_visible_rect().size.x/2.0)*200
		offset.y = (mouse_pos.y - global_position.y)/(get_viewport().get_visible_rect().size.y/2.0)*100

##
func _input(event: InputEvent) -> void:
	if mouse_control_moving:
		# Для управления мышью
		if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
			position -= event.relative * drag_sensitivity / zoom
	if mouse_wheel_scale:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				camera_zoom += Vector2(zoom_speed, zoom_speed)
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				camera_zoom -= Vector2(zoom_speed, zoom_speed)
			zoom = clamp(camera_zoom, Vector2(zoom_min, zoom_min), Vector2(zoom_max, zoom_max))
			camera_zoom = zoom



	### Для управления с клавиатуры
	#if event.is_action_pressed("interact"):
		#camera_shake()
	if aarrows_control_moving:
		if event.is_action_pressed("ui_left"):
			offset.x -= speed
		if event.is_action_pressed("ui_right"):
			offset.x += speed
		if event.is_action_pressed("ui_up"):
			offset.y -= speed
		if event.is_action_pressed("ui_down"):
			offset.y += speed
	if event.is_action_pressed("zoom+"):
		camera_zoom += Vector2(1, 1)
	if event.is_action_pressed("zoom-"):
		camera_zoom -= Vector2(1, 1)
	zoom = clamp(camera_zoom, Vector2(zoom_min, zoom_min), Vector2(zoom_max, zoom_max))
	camera_zoom = zoom



## настраивает параметры смещения камеры при дрожании
func start_camera_shake(intensty: float)-> void:
	var camera_offset: float = camera_shake_noise.get_noise_1d(Time.get_ticks_msec()) * intensty
	offset.x = camera_offset
	offset.y = camera_offset

## вызывает эффект дрожения камеры
func camera_shake()-> void:
	var camera_tween: Tween = get_tree().create_tween()
	camera_tween.tween_method(start_camera_shake, 5.0, 1.0, 0.5)
