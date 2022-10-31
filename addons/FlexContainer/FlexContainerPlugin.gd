tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("FlexContainer", "Container", preload("flex_container.gd"), preload("res/icon.svg"))
	pass


func _exit_tree():
	remove_custom_type("FlexContainer")
	pass
