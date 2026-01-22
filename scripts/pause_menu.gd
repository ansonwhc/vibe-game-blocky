extends Control

signal resume_pressed
signal restart_pressed
signal quit_to_menu_pressed

@onready var resume_button: Button = $Panel/VBox/ResumeButton
@onready var restart_button: Button = $Panel/VBox/RestartButton
@onready var quit_button: Button = $Panel/VBox/QuitButton

func _ready() -> void:
	resume_button.pressed.connect(_on_resume_pressed)
	restart_button.pressed.connect(_on_restart_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_resume_pressed() -> void:
	emit_signal("resume_pressed")

func _on_restart_pressed() -> void:
	emit_signal("restart_pressed")

func _on_quit_pressed() -> void:
	emit_signal("quit_to_menu_pressed")
