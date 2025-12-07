extends Node
class_name MySceneLoader


## Загрузочный экран для перехода от одной сцены к другой.
##
## Используется для загрузки тяжелых сцен.
## Не занимается сохранением состояний
## Используется, затем уничтожается

func _ready() -> void:
	if SceneManager.next_scene == "":
		scene_invalid(SceneManager.next_scene)
		return
	else:
		ResourceLoader.load_threaded_request(SceneManager.next_scene)
		if not ResourceLoader.exists(SceneManager.next_scene):
			scene_failed_to_load(SceneManager.next_scene)
			return

func _process(_delta: float) -> void:
	var progress: Array = []
	ResourceLoader.load_threaded_get_status(SceneManager.next_scene, progress)
	if progress[0] == 1: # полностью загружен
		var packed_scene: PackedScene = ResourceLoader.load_threaded_get(SceneManager.next_scene)
		# TODO посылает сигнал о завершении
		get_tree().change_scene_to_packed(packed_scene)

## Если не удалось загрузить сцену
func scene_failed_to_load(scene_path: String) -> void:
	push_error("can't load next scene: '%s'" %[scene_path])
## Если сцена не существует или введены некорректные данные
func scene_invalid(scene_path: String) -> void:
	push_error("scene: '%s' is invalid" %[scene_path])
