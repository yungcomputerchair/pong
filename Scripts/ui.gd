extends Control

@onready var left_panel = %LeftPanel
@onready var right_panel = %RightPanel

func update_panel(panel, score):
	panel.get_node("Score").text = str(score)
	var status = panel.get_node("Status")
	if score >= 10:
		status.text = "WINNER"
	else:
		status.text = ""

func update_scores(left, right):
	update_panel(left_panel, left)
	update_panel(right_panel, right)
