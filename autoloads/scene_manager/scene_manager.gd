extends Node

## Управляет переключением сцен
##
## Для управления загрузкой различных сцен. И выбора, показывать ли загрузочный экран или нет


## загрузочный экран
var __loading_screen: PackedScene = preload("uid://bijcjwcldnokn")

var next_scene: String = ""

## Текущая сцена, в которой происходят события,
## нужна, чтобы понимат, куда помещаются предметы
var current_world: Node


## Смена сцены, вместо того, чтобы сразу загружать следующую сцену, загружаем экран загрузки
func change_scene(__new_scene: String) -> int:
	# Если мы в этой же сцене, то никуда не идём
	if __new_scene == get_tree().current_scene.scene_file_path:
		push_warning('you already in this scene')
		return -1
	else:
		next_scene = __new_scene
		get_tree().change_scene_to_packed(__loading_screen)
		return 0



func scene_failed_to_load(scene_path: String) -> void:
	push_error("can't load next scene: '%s'" %[scene_path])
## Если сцена не существует или введены некорректные данные
func scene_invalid(scene_path: String) -> void:
	push_error("scene: '%s' is invalid" %[scene_path])
## Если сцена загрузилась нормально
func scene_finished_loading(_scene_path: String) -> void:
	pass
