extends Node2D

@export_category("Movement")
@export var start_position: Vector2i## Starting position in the path
@export var end_position: Vector2i## Ending position in the path
@export var progress: int## Progress in the path
@export var reversePath: bool## If checked; follow path in reverse
@export var step: float##how much to step in the path
@export var pingpong: bool##If checked, it bounses back

var goingforward: bool
var actualprogress: float

func _ready() -> void:
	# Initialize here so @export Inspector values are loaded first
	goingforward = not reversePath
	actualprogress = float(progress)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if goingforward:
		actualprogress += step
	else:
		actualprogress -= step
	if actualprogress >= 100:
		if pingpong: 
			goingforward =! goingforward
		else:
			actualprogress = 0
	if actualprogress < 0:
		if pingpong: 
			goingforward =! goingforward
		else:
			actualprogress = 100
	position = calculate_position(actualprogress,start_position,end_position)

func calculate_position(prog:float=0,start:Vector2i=Vector2i.ZERO,end:Vector2i=Vector2i.ZERO) -> Vector2i:
	## Calculates the position between two points at a certain progress
	var endifstartiszero := end - start
	var pointonline: Vector2i = round(endifstartiszero * (prog / 100))
	var output = pointonline + start
	return output
