extends Control

onready var tw = $Tween


func _on_Play_pressed(): #play
	$Transition.changeScene()
func _on_Back_pressed():
	tw.interpolate_property($Credits, "modulate",Color.white,Color.transparent,1,Tween.TRANS_LINEAR,Tween.EASE_IN)
	tw.interpolate_property($Menu, "modulate",Color.transparent,Color.white,1,Tween.TRANS_LINEAR,Tween.EASE_IN)
	tw.start()
func _on_Credits_pressed():
	tw.interpolate_property($Credits, "modulate",Color.transparent,Color.white,1,Tween.TRANS_LINEAR,Tween.EASE_IN)
	tw.interpolate_property($Menu, "modulate",Color.white,Color.transparent,1,Tween.TRANS_LINEAR,Tween.EASE_IN)
	tw.start()
