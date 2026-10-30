extends Node2D

const WHITE := Color(0.95, 0.94, 0.97)
const MUTED := Color(0.68, 0.65, 0.73)
const GOLD := Color(0.96, 0.83, 0.43)
const FONT := ThemeDB.fallback_font

var scene := "path"
var mode := "dialogue"
var player := Vector2(150, 365)
var dialogue: Array[String] = []
var dialogue_index := 0
var choices: Array[String] = []
var choice_index := 0
var hp := 290
var susie_hp := 340
var enemy_hp := 180
var mercy := 0
var heart := Vector2(480, 390)
var bullets: Array[Dictionary] = []
var attack_clock := 0.0
var attack_duration := 4.5
var message := ""
var message_timer := 0.0
var battle_round := 0

func _ready() -> void:
	get_window().title = "DELTARUNE: SHELTER"
	_start_dialogue([
		"The path to the bunker is quiet.",
		"Susie: So this is the place.",
		"Kris, the air feels colder down here.",
		"Susie hands you a heavy metal bar.",
		"Susie: You ready?"
	])

func _process(delta: float) -> void:
	if mode == "explore":
		var direction := Vector2.ZERO
		if Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_A):
			direction.x -= 1
		if Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_D):
			direction.x += 1
		if Input.is_key_pressed(KEY_UP) or Input.is_key_pressed(KEY_W):
			direction.y -= 1
		if Input.is_key_pressed(KEY_DOWN) or Input.is_key_pressed(KEY_S):
			direction.y += 1
		if direction != Vector2.ZERO:
			player += direction.normalized() * 210.0 * delta
			player.x = clampf(player.x, 40.0, 920.0)
			player.y = clampf(player.y, 210.0, 475.0)
	elif mode == "dodge":
		var direction := Vector2.ZERO
		if Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_A):
			direction.x -= 1
		if Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_D):
			direction.x += 1
		if Input.is_key_pressed(KEY_UP) or Input.is_key_pressed(KEY_W):
			direction.y -= 1
		if Input.is_key_pressed(KEY_DOWN) or Input.is_key_pressed(KEY_S):
			direction.y += 1
		if direction != Vector2.ZERO:
			heart += direction.normalized() * 250.0 * delta
		heart.x = clampf(heart.x, 300.0, 660.0)
		heart.y = clampf(heart.y, 330.0, 475.0)
		attack_clock += delta
		_spawn_bullets(delta)
		_update_bullets(delta)
		if attack_clock >= attack_duration:
			mode = "battle_menu"
			choices = ["FIGHT", "ACT", "ITEM", "SPARE"]
			choice_index = 0
			message = "YOU is watching. What will you do?"
	if message_timer > 0.0:
		message_timer -= delta
	queue_redraw()

func _spawn_bullets(delta: float) -> void:
	if randf() < delta * 3.0:
		bullets.append({"pos": Vector2(randf_range(310.0, 650.0), 325.0), "speed": randf_range(105.0, 180.0)})
	
func _update_bullets(delta: float) -> void:
	for i in range(bullets.size() - 1, -1, -1):
		var bullet: Dictionary = bullets[i]
		var pos: Vector2 = bullet["pos"]
		pos.y += float(bullet["speed"]) * delta
		bullet["pos"] = pos
		if pos.distance_to(heart) < 16.0:
			hp = maxi(0, hp - 8)
			bullets.remove_at(i)
			message = "A light grazes Kris. 8 HP lost."
			if hp <= 0:
				hp = 1
				message = "Kris steadies themself. Keep moving."
		elif pos.y > 500.0:
			bullets.remove_at(i)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		var key := event as InputEventKey
		if key.keycode in [KEY_Z, KEY_ENTER, KEY_SPACE]:
			_confirm()
		elif key.keycode in [KEY_X, KEY_ESCAPE, KEY_BACKSPACE]:
			_back()
		elif mode in ["battle_menu", "act_menu"]:
			if key.keycode in [KEY_UP, KEY_W]:
				choice_index = (choice_index - 1 + choices.size()) % choices.size()
				queue_redraw()
			elif key.keycode in [KEY_DOWN, KEY_S]:
				choice_index = (choice_index + 1) % choices.size()
				queue_redraw()

func _confirm() -> void:
	match mode:
		"dialogue":
			dialogue_index += 1
			if dialogue_index >= dialogue.size():
				mode = "explore"
				message = "Move with WASD or the arrow keys. Press Z near the bunker."
			queue_redraw()
		"explore":
			_interact()
		"battle_menu":
			match choices[choice_index]:
				"FIGHT": _fight()
				"ACT":
					mode = "act_menu"
					choices = ["CHECK", "ASK WHY", "WAIT", "BACK"]
					choice_index = 0
					message = "Choose an action."
				"ITEM":
					message = "You have no items."
				"SPARE":
					if mercy >= 3:
						_victory(true)
					else:
						message = "YOU is not ready to stop."
						_enemy_turn()
		"act_menu":
			match choices[choice_index]:
				"CHECK":
					message = "YOU — ATK ??? DEF ???. A familiar shape with an unfamiliar purpose."
					mode = "battle_menu"
					choices = ["FIGHT", "ACT", "ITEM", "SPARE"]
					choice_index = 0
				"ASK WHY":
					mercy += 1
					message = "Kris asks why the vessel is here. YOU: You already know."
					_enemy_turn()
				"WAIT":
					mercy += 2
					message = "You wait. The room seems to listen. YOU: ...interesting."
					_enemy_turn()
				"BACK":
					mode = "battle_menu"
					choices = ["FIGHT", "ACT", "ITEM", "SPARE"]
					choice_index = 0
	queue_redraw()

func _back() -> void:
	if mode == "act_menu":
		mode = "battle_menu"
		choices = ["FIGHT", "ACT", "ITEM", "SPARE"]
		choice_index = 0
		message = "YOU is watching. What will you do?"
		queue_redraw()

func _interact() -> void:
	if scene == "path":
		if player.distance_to(Vector2(480, 275)) < 210.0:
			scene = "door"
			_start_dialogue([
				"The bunker doors refuse to move.",
				"Susie: Stand back. I got this.",
				"The metal groans. A thin line of darkness appears.",
				"A cold wind slips through the opening.",
				"The dark swallows the path."
			])
			_after_dialogue = "mirror"
		else:
			message = "The bunker is down the path. Keep walking."
	elif scene == "mirror":
		_start_dialogue([
			"The cover reads: ENTRY 1.",
			"The pages are filled with careful handwriting.",
			"Most of the words have been crossed out.",
			"One sentence remains: DO NOT FOLLOW THE SECOND YOU."
		])
		_after_dialogue = "strange"
	elif scene == "strange":
		_begin_battle()

var _after_dialogue := ""

func _start_dialogue(lines: Array[String]) -> void:
	dialogue = lines
	dialogue_index = 0
	mode = "dialogue"
	message = ""
	queue_redraw()

func _finish_dialogue() -> void:
	if _after_dialogue == "mirror":
		_after_dialogue = ""
		scene = "mirror"
		_start_dialogue([
			"...",
			"You open your eyes.",
			"A room stretches in every direction.",
			"Mirrors stand where walls should be.",
			"Every reflection is a little late.",
			"A book rests on a small table. Press Z to read it."
		])
	elif _after_dialogue == "strange":
		_after_dialogue = ""
		scene = "strange"
		_start_dialogue([
			"A familiar voice comes from somewhere behind the glass.",
			"Ralsei: I was hoping you wouldn't have to come here.",
			"Ralsei looks toward the endless reflections.",
			"Ralsei: Something has been waiting for you."
		])
	else:
		mode = "explore"

func _begin_battle() -> void:
	scene = "battle"
	mode = "battle_menu"
	enemy_hp = 180
	hp = 290
	mercy = 0
	choices = ["FIGHT", "ACT", "ITEM", "SPARE"]
	choice_index = 0
	message = "A figure steps out from the dark. YOU: You came all this way."

func _fight() -> void:
	if mercy < 2:
		message = "Your attack rebounds. YOU: You still do not understand."
		_enemy_turn()
		return
	enemy_hp -= 45
	message = "Kris finds an opening. YOU loses 45 HP."
	if enemy_hp <= 0:
		_victory(false)
	else:
		_enemy_turn()

func _enemy_turn() -> void:
	mode = "dodge"
	heart = Vector2(480, 400)
	bullets.clear()
	attack_clock = 0.0
	message = "Dodge the incoming light with WASD or arrow keys."

func _victory(spared: bool) -> void:
	mode = "dialogue"
	scene = "strange"
	if spared:
		_start_dialogue([
			"YOU lowers its weapon.",
			"YOU: You chose to listen. That may matter.",
			"Ralsei steps out from behind a reflection.",
			"Ralsei: We should keep moving. This place is changing."
		])
	else:
		_start_dialogue([
			"The figure dissolves into drifting light.",
			"Something remains where it stood.",
			"Ralsei steps out from behind a reflection.",
			"Ralsei: We should keep moving. This place is changing."
		])
	_after_dialogue = "ending"

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, Vector2(960, 540)), Color("#090812"))
	match scene:
		"path", "door":
			_draw_path()
		"mirror":
			_draw_mirror()
		"strange":
			_draw_strange()
		"battle":
			_draw_battle()
	_draw_dialogue_ui()

func _draw_path() -> void:
	draw_rect(Rect2(0, 0, 960, 540), Color("#111b28"))
	draw_rect(Rect2(0, 320, 960, 220), Color("#263b32"))
	for i in range(32):
		draw_rect(Rect2((i * 71) % 960, 330 + (i * 31) % 190, 28, 5), Color("#304a3a"))
	draw_rect(Rect2(390, 100, 180, 230), Color("#34303c"))
	draw_rect(Rect2(407, 115, 146, 215), Color("#090a11"))
	draw_rect(Rect2(423, 130, 114, 200), Color("#17131b"))
	_draw_label("HOMETOWN BUNKER", 480, 75, 16, MUTED, HORIZONTAL_ALIGNMENT_CENTER)
	_draw_character(player, Color("#202b59"), false)
	_draw_character(Vector2(250, 390), Color("#783a91"), true)

func _draw_mirror() -> void:
	draw_rect(Rect2(0, 0, 960, 540), Color("#0b0a15"))
	for i in range(9):
		var mx := 28.0 + i * 110.0
		draw_rect(Rect2(mx, 55, 75, 360), Color("#37344c"))
		draw_rect(Rect2(mx + 7, 62, 61, 346), Color("#a2a0bb"))
		draw_rect(Rect2(mx + 13, 68, 49, 334), Color("#171626"))
		draw_rect(Rect2(mx + 19, 74, 37, 322), Color("#39354f"))
	draw_rect(Rect2(430, 400, 100, 15), Color("#594b4a"))
	draw_rect(Rect2(450, 355, 60, 45), Color("#211e29"))
	_draw_label("ENTRY 1", 480, 345, 16, GOLD, HORIZONTAL_ALIGNMENT_CENTER)
	_draw_character(Vector2(480, 470), Color("#202b59"), false)

func _draw_strange() -> void:
	draw_rect(Rect2(0, 0, 960, 540), Color("#11101b"))
	for i in range(55):
		var px := fposmod(i * 83.0 + Time.get_ticks_msec() * 0.02, 960.0)
		var py := 45.0 + float((i * 47) % 440)
		draw_rect(Rect2(px, py, 3, 3), Color("#6e6a8c"))
	draw_rect(Rect2(120, 390, 720, 7), Color("#51445d"))
	_draw_character(Vector2(340, 390), Color("#202b59"), false)
	_draw_character(Vector2(480, 390), Color("#783a91"), true)
	_draw_character(Vector2(650, 390), Color("#b7b5c7"), false)
	_draw_label("SOMEWHERE BEYOND THE MIRRORS", 480, 70, 16, WHITE, HORIZONTAL_ALIGNMENT_CENTER)

func _draw_battle() -> void:
	draw_rect(Rect2(0, 0, 960, 540), Color("#080811"))
	_draw_label("A QUIET ROOM WITH NO EXIT", 480, 45, 16, MUTED, HORIZONTAL_ALIGNMENT_CENTER)
	draw_rect(Rect2(440, 115, 80, 105), Color("#050507"))
	draw_rect(Rect2(452, 95, 56, 45), Color("#050507"))
	draw_rect(Rect2(455, 130, 12, 6), WHITE)
	draw_rect(Rect2(493, 130, 12, 6), WHITE)
	draw_rect(Rect2(465, 190, 30, 55), Color("#050507"))
	_draw_label("YOU", 480, 265, 20, WHITE, HORIZONTAL_ALIGNMENT_CENTER)
	_draw_label("HP %d / 180" % enemy_hp, 480, 292, 14, GOLD, HORIZONTAL_ALIGNMENT_CENTER)
	draw_rect(Rect2(270, 315, 420, 170), Color("#09090e"), false, 4)
	draw_rect(Rect2(heart - Vector2(6, 6), Vector2(12, 12)), GOLD)
	for bullet in bullets:
		draw_rect(Rect2(bullet["pos"], Vector2(10, 10)), WHITE)
	_draw_label("KRIS %d HP" % hp, 30, 520, 15, WHITE)
	_draw_label("SUSIE %d HP" % susie_hp, 930, 520, 15, WHITE, HORIZONTAL_ALIGNMENT_RIGHT)

func _draw_character(pos: Vector2, coat: Color, susie: bool) -> void:
	draw_rect(Rect2(pos + Vector2(-12, -35), Vector2(24, 28)), coat)
	draw_rect(Rect2(pos + Vector2(-11, -49), Vector2(22, 17)), Color("#d9c9b6"))
	draw_rect(Rect2(pos + Vector2(-10, -22), Vector2(20, 13)), Color("#8d3b9d") if susie else Color("#244b8a"))
	draw_rect(Rect2(pos + Vector2(-10, -5), Vector2(7, 7)), Color("#17131d"))
	draw_rect(Rect2(pos + Vector2(3, -5), Vector2(7, 7)), Color("#17131d"))

func _draw_label(value: String, x: float, y: float, size: int, color: Color, align: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT) -> void:
	var width := 900.0
	var start_x := x
	if align == HORIZONTAL_ALIGNMENT_CENTER:
		start_x = x - width / 2.0
	elif align == HORIZONTAL_ALIGNMENT_RIGHT:
		start_x = x - width
	draw_string(FONT, Vector2(start_x, y), value, HORIZONTAL_ALIGNMENT_LEFT, width, size, color)

func _draw_dialogue_ui() -> void:
	if mode == "battle":
		return
	if mode == "dialogue":
		draw_rect(Rect2(18, 420, 924, 104), Color("#050508"))
		draw_rect(Rect2(18, 420, 924, 104), WHITE, false, 3)
		if dialogue_index < dialogue.size():
			_draw_label(dialogue[dialogue_index], 42, 462, 18, WHITE)
		_draw_label("Z / ENTER  CONTINUE", 915, 505, 12, GOLD, HORIZONTAL_ALIGNMENT_RIGHT)
	elif mode in ["battle_menu", "act_menu"]:
		draw_rect(Rect2(18, 420, 924, 104), Color("#050508"))
		draw_rect(Rect2(18, 420, 924, 104), WHITE, false, 3)
		_draw_label(message, 40, 447, 15, WHITE)
		for i in range(choices.size()):
			var color := GOLD if i == choice_index else WHITE
			_draw_label(("▶ " if i == choice_index else "  ") + choices[i], 50 + i * 215, 490, 16, color)
	elif mode == "dodge":
		draw_rect(Rect2(18, 420, 924, 104), Color("#050508"))
		draw_rect(Rect2(18, 420, 924, 104), WHITE, false, 3)
		_draw_label(message, 40, 455, 16, WHITE)
		_draw_label("DODGE  WASD / ARROWS", 40, 495, 13, GOLD)
	elif mode == "explore":
		draw_rect(Rect2(18, 420, 924, 104), Color("#050508"))
		draw_rect(Rect2(18, 420, 924, 104), WHITE, false, 3)
		_draw_label(message if message != "" else "Explore the room. Press Z to interact.", 40, 462, 16, WHITE)
	elif mode == "ending":
		draw_rect(Rect2(18, 420, 924, 104), Color("#050508"))
		draw_rect(Rect2(18, 420, 924, 104), WHITE, false, 3)
		_draw_label("END OF CURRENT DEMO  ·  THANK YOU FOR PLAYING", 480, 475, 18, GOLD, HORIZONTAL_ALIGNMENT_CENTER)
