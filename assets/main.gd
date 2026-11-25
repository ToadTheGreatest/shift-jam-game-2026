extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$levels.visible = false;
	$playerspawner.visible = false;
	$Camera2D.make_current()
	$CanvasLayer/title.visible = true;

var firstpress = true
var timer = 0
var presses = 0
var waitforpresses = false
var level = 1
var ui = preload("res://ui.tscn")
var started = false
@onready var levels = [
	preload("res://level_1.tscn"),
	preload("res://level_2.tscn"),
	preload("res://level_3.tscn"),
	preload("res://level_4.tscn"),
	preload("res://level_5.tscn"),
	preload("res://level_6.tscn"),
	preload("res://level_7.tscn"),
	preload("res://level_8.tscn"),
	preload("res://level_9.tscn"),
	preload("res://level_10.tscn"),
	preload("res://level_11.tscn"),
	preload("res://level_12.tscn"),
	preload("res://lastlevel.tscn")
]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if waitforpresses:
		if Input.is_action_just_pressed("shift"):
			if presses == 0:
				presses += 1
				timer = 100
			elif timer > 0:
				presses += 1
				timer = 100
		if timer > 0: timer -= 1
		if presses == 5:
			waitforpresses = false;
			$CanvasLayer/title/playbutton.text = "PLAY GAME"
			var choice = await ask_yes_no("Do you want to enable sticky keys?")
			print(choice)
			if choice:
				start()
			firstpress = true;
			presses = 0;
			timer = 0;
	if started:
		$CanvasLayer/ui/keys.text = "+".join($playerspawner/player.onlykeys)

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


func start() -> void:
	$levels.visible = true;
	$playerspawner.visible = true;
	$playerspawner/player.position = Vector2.ZERO;
	var uilayer = ui.instantiate()
	$CanvasLayer.add_child(uilayer)
	$CanvasLayer/title.visible = false;
	$CanvasLayer/ui/Button.visible = true;
	$CanvasLayer/ui/Button.disabled = false;
	loadlevel(1)
	started = true

func _on_playbutton_button_down() -> void:
	if firstpress:
		firstpress = false
		$CanvasLayer/title/playbutton.text = "Press SHIFT 5 Times To Play"
		waitforpresses = true

func nextlevel():
	level += 1
	loadlevel(level)

func resetlevel():
	loadlevel(level)

func loadlevel(levelnum):
	$playerspawner/player.position = Vector2.ZERO
	$playerspawner/player.keysPressed = []
	$playerspawner/player.shifttimer = -1
	$playerspawner/player.shiftModeKey = ""
	var newlevel = levels[levelnum - 1].instantiate()
	if $levels.get_child_count() > 0:
		$levels.get_child(0).queue_free()
	$levels.add_child(newlevel)
