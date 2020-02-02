extends Node2D

var nextScene : PackedScene
onready var animator : AnimationPlayer = $AnimationPlayer
export var selectedLevel : int = 0
export var LevelPaths :PoolStringArray = []

func changeScene() -> void:
	nextScene = load(LevelPaths[selectedLevel])
	if nextScene != null:
		animator.play("transition")
		yield(animator,"animation_finished")
		get_tree().change_scene_to(nextScene)
