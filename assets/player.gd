extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -400.0
const keysTime = 100
var keysPressed = []
var shifttimer = -1
const shiftModeCooldown = 1
var shiftModeKey = ""
var onlykeys

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("shift"):
		velocity = Vector2.ZERO
		if shifttimer == -1:
			if Input.is_action_pressed("up"):
				if shiftModeKey == "":
					shiftModeKey = "up"
				if shiftModeKey == "up":
					velocity.y -= SPEED
			else:
				if shiftModeKey == "up":
					shifttimer = 0
			if Input.is_action_pressed("down"):
				if shiftModeKey == "":
					shiftModeKey = "down"
				if shiftModeKey == "down":
					velocity.y += SPEED
			else:
				if shiftModeKey == "down":
					shifttimer = 0
			if Input.is_action_pressed("left"):
				if shiftModeKey == "":
					shiftModeKey = "left"
				if shiftModeKey == "left":
					velocity.x -= SPEED
			else:
				if shiftModeKey == "left":
					shifttimer = 0
			if Input.is_action_pressed("right"):
				if shiftModeKey == "":
					shiftModeKey = "right"
				if shiftModeKey == "right":
					velocity.x += SPEED
			else:
				if shiftModeKey == "right":
					shifttimer = 0
	else:
		if Input.is_action_just_pressed("reset"):
			$/root/main.resetlevel()
		if Input.is_action_just_pressed("up"):
			keysPressed.append({
				"action": "up",
				"time": keysTime
			})
		if Input.is_action_just_pressed("down"):
			keysPressed.append({
				"action": "down",
				"time": keysTime
			})
		if Input.is_action_just_pressed("right"):
			keysPressed.append({
				"action": "right",
				"time": keysTime
			})
		if Input.is_action_just_pressed("left"):
			keysPressed.append({
				"action": "left",
				"time": keysTime
			})
		onlykeys = []
		var index = 0
		var indexes_to_pop = []
		for key in keysPressed:
			if !onlykeys.has(key.action):
				onlykeys.append(key.action)
			keysPressed[index].time -= 1
			if keysPressed[index].time == 0:
				indexes_to_pop.append(index)
			index += 1
		indexes_to_pop.sort()
		indexes_to_pop.reverse()
		for i in indexes_to_pop:
			keysPressed.pop_at(i)
		velocity = Vector2.ZERO
		
		for ok in onlykeys:
			if ok == "up":
				velocity.y -= SPEED# * delta
			if ok == "down":
				velocity.y += SPEED# * delta
			if ok == "left":
				velocity.x -= SPEED# * delta
			if ok == "right":
				velocity.x += SPEED# * delta
	move_and_slide()

func _on_area_2d_area_entered(area: Area2D) -> void:
	print(area.editor_description)
	if area.name == "end_level":
		$/root/main.nextlevel()
	if area.editor_description == "spike":
		$/root/main.resetlevel()
