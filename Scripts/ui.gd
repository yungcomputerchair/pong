extends Control

@onready var left_panel = %LeftPanel
@onready var right_panel = %RightPanel

func update_scores(left, right):
	left_panel.get_node("Label").text = str(left)
	right_panel.get_node("Label").text = str(right)
