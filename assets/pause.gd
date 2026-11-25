extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$pause.visible = false
	$Button.visible = false
	$Button.disabled = true
	$pause/tipsmenu.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_button_down() -> void:
	$pause.visible = true
	$Button.disabled = true


func _on_return_button_down() -> void:
	$pause.visible = false
	$Button.disabled = false


func _on_tab_bar_tab_changed(tab: int) -> void:
	if tab == 0:
		$pause/tipsmenu/tips.show()
		$pause/tipsmenu/controls.hide()
	if tab == 1:
		$pause/tipsmenu/tips.hide()
		$pause/tipsmenu/controls.show()


func _on_tips_button_down() -> void:
	$pause/tipsmenu.show()
	$pause/tipsmenu/tips.show()
	$pause/tipsmenu/controls.hide()


func _on_close_button_down() -> void:
	$pause/tipsmenu.hide()


func ask_yes_no(question: String) -> bool:
	var dialog = ConfirmationDialog.new()
	dialog.title = "Confirm"
	dialog.dialog_text = question
	dialog.ok_button_text = "Yes"
	dialog.cancel_button_text = "No"
	
	add_child(dialog)
	dialog.popup_centered()
	
	var choice := [false]
	dialog.confirmed.connect(func(): choice[0] = true)
	
	# Wait for the dialog to close, then wait 1 frame so `confirmed` finishes firing
	await dialog.visibility_changed
	await get_tree().process_frame
	
	dialog.queue_free()
	return choice[0]


func _on_quit_button_down() -> void:
	if await ask_yes_no("Are you sure you want to quit? You will lose ALL your progress!! (also then you escape our grasp and you wont play forever)"):
		get_tree().quit()
