extends CanvasLayer
"""
	Hud Singleton Scene Script
"""

func _ready() -> void:
	hide()


func show() -> void:
	for i in get_children():
		if i is Control:
			i.visible = true


func hide() -> void:
	for i in get_children():
		if i is Control:
			i.visible = false