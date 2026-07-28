extends CanvasLayer

@export var score_scene: PackedScene

signal start_game
signal bird_color_change(index)
signal pipe_color_change(index)
signal time_change
var score_queue = []
var score = 0
var toggle = false

func show_game_over_message():
	$Gameover.show()
	$MessageTimer.start()
	
func show_get_ready_message():
	$GetReady.show()
	$GetReadyTimer.start()

func show_game_over():
	show_game_over_message()
	await $MessageTimer.timeout
	await get_tree().create_timer(1).timeout
	$StartButton.show()
	$FlappyBird.show()
	$Instructions.show()
	# Birds
	$BlueBird.show()
	$RedBird.show()
	$YellowBird.show()
	# Pipes
	$GreenPipe.show()
	$RedPipe.show()
	# Once everything is shown, re-enable process
	set_process(!is_processing())

func initialize_score():
	score = 0
	for c in score_queue:
		c.queue_free()
	score_queue = []
	
	var score_pic_ones = score_scene.instantiate()
	score_pic_ones.setup()
	score_pic_ones.position = $Score.position
	score_queue.append(score_pic_ones)
	add_child(score_pic_ones)
	
	var score_pic_tens = score_scene.instantiate()
	score_pic_tens.setup()
	score_pic_tens.position = $Score.position
	score_pic_tens.position.x -= 25
	score_queue.append(score_pic_tens)
	add_child(score_pic_tens)
	
	var score_pic_hundreds = score_scene.instantiate()
	score_pic_hundreds.setup()
	score_pic_hundreds.position = $Score.position
	score_pic_hundreds.position.x -= 50
	score_queue.append(score_pic_hundreds)
	add_child(score_pic_hundreds)
	
	$ScoreLabel.text = str(score)

func update_score():
	if toggle:
		score += 1
		score_queue[0].update_value(score % 10)
		score_queue[1].update_value(score/10 % 10)
		score_queue[2].update_value(score/100 % 10)
		$ScoreLabel.text = str(score)
		toggle = false
	else: 
		toggle = true

@onready var start_button = $StartButton
func _process(_delta):
	if Input.is_action_pressed("jump"):
		start_button.emit_signal("pressed")

func _on_start_button_pressed():
	set_process(!is_processing()) # Disable the process method
	$StartButton.hide()
	$FlappyBird.hide()
	$Instructions.hide()
	# Birds
	$BlueBird.hide()
	$RedBird.hide()
	$YellowBird.hide()
	# Pipes
	$GreenPipe.hide()
	$RedPipe.hide()
	show_get_ready_message()
	start_game.emit()

func _on_message_timer_timeout():
	$Gameover.hide()
	
func _on_get_ready_timer_timeout():
	$GetReady.hide()

func _on_blue_bird_pressed():
	bird_color_change.emit(0)
	
func _on_red_bird_pressed():
	bird_color_change.emit(1)

func _on_yellow_bird_pressed():
	bird_color_change.emit(2)

func _on_green_pipe_pressed():
	pipe_color_change.emit(0)

func _on_red_pipe_pressed():
	pipe_color_change.emit(1)

func _on_day_night_toggle_pressed():
	time_change.emit()
