extends Control

@onready var left_panel = %LeftPanel
@onready var right_panel = %RightPanel

func set_start_text():
	left_panel.get_node("Status").text = "PRESS\nSPACE"
	right_panel.get_node("Status").text = "TO\nSTART"

func clear_start_text():
	left_panel.get_node("Status").text = ""
	right_panel.get_node("Status").text = ""

func update_score(panel, score):
	panel.get_node("Score").text = str(score)

func update_scores(left, right):
	update_score(left_panel, left)
	update_score(right_panel, right)

func set_winner(winner):
	var winner_panel = right_panel if winner == 1 else left_panel
	winner_panel.get_node("Status").text = "WINNER"
	var loser_panel = left_panel if winner == 1 else right_panel
	loser_panel.get_node("Status").text = "PRESS\nR\nTO\nRESET"
