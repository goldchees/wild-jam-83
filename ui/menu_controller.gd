extends Control

var paused: bool = false

func _on_focus_changed(control: Control) -> void:
	print(control)

@onready var main_menu: Menu = $Main
@onready var options_menu: Menu = $Options
@onready var credits_menu: Menu = $Credits

var active_menu: Menu = null

func all_menus():
	return [main_menu,options_menu,credits_menu]

func _ready() -> void:
	visible = true
	process_mode = Node.PROCESS_MODE_ALWAYS
	resume_game()

	for menu in all_menus():
		menu.visible = false

		var back_button = menu.get_node_or_null("Back")
		if (back_button):
			back_button.connect("button_down",func(): open(main_menu))

	$Main/Play.connect("button_down",func(): resume_game())
	$Main/Options.connect("button_down",func(): open(options_menu))
	$Main/Credits.connect("button_down",func(): open(credits_menu))

func _input(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if (!paused):
			pause_game()
			_show_menu(main_menu)
			return

		if (active_menu != main_menu):
			open(main_menu)
		else:
			resume_game()

func open_main_menu():
	open(main_menu)

func open(menu: Menu):
	_hide_menu(active_menu)
	_show_menu(menu)

func _hide_menu(menu: Menu):
	if (!active_menu): return
	menu.visible = false

func _show_menu(menu: Menu):
	active_menu = menu
	menu.visible = true
	for child in menu.get_children():
		if (child is Button):
			child.grab_focus()
			break

	var tween = create_tween()
	var pos = menu.position
	menu.position += Vector2(0,64)
	tween.set_parallel(true)
	tween.tween_property(menu, "position",pos, 0.2)
	menu.modulate = Color(1,1,1,0)
	tween.tween_property(menu, "modulate",Color(1,1,1,1), 0.2)

func pause_game():
	get_tree().paused = true
	visible = true
	paused = true

func resume_game():
	get_tree().paused = false
	visible = false
	paused = false
	active_menu = null


func _on_check_button_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), toggled_on)
