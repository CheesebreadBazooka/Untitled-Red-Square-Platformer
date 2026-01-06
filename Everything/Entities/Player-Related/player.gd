extends CharacterBody2D

class_name Player


@export var accel : float = 50.0
@export var speed : float = 300.0
@export var jump_speed : float = -400.0
@export var run_accel : float = 50.0
@export var run_speed : float = 500.0

@export var powerup : String = "none"

@export var book_speed : float = 600.0
@export var book_coolset : float = 1.0
@export var book_area_coolset : float = 0.3

@export var twirl_coolset : float = 0.2
@export var spinrun_coolset : float = 0.3
@export var spinrun_book_coolset : float = 0.3

@export var grav_mult_default : float = 1
@export var jumpbuffer_set : float = 0.15
@export var bookbuffer_set : float = 0.15
@export var spinbuffer_set : float = 0.15

@export var backflip_velset : float = 400

@export var sprite : Sprite2D
@export var anim_tree : AnimationTree
@export var camera : Camera2D

@export var book_area : DamageArea2D
@export var spin_area : DamageArea2D

@export var ghost_power_speed : float = 400
@export var ghost_power_accel : float = 50
@export var ghost_flylimit : float = 3

var direction : float = 0.0
var face_dir : float = 1
var last_face : float = 1
var vertdir : float = 0.0

var last_vel : Vector2 = Vector2.ZERO
var last_last_vel : Vector2 = Vector2.ZERO

var can_double_jump : bool = true
var can_ground_pound : bool = true

var book_cooldown : float = 0.0
var book_area_cooldown : float = 0.0

var twirl_cooldown : float = 0.0
var spinrun_book_cooldown : float = 0.0
var spinning : bool = false
var spinbuffer : float = 0.0
var lastspin : bool = false

var wallclimb_mult : float = 1.0
var horzbounce_take : float = 0.0

var stop_x : bool = false
var stop_y : bool = false
var velalter_reason : String = "none"
var hold_x : float = 0.0
var hold_y : float = 0.0
var stop_cooldown : float = 0.0
var freeze_x : bool = false
var freeze_y : bool = false

var collided : bool = false
var last_collided : bool = false
var last_last_collided : bool = false

var grav_mult : float = grav_mult_default
var grav_altmult : float = 1
var grav_rotate : float = 0.0

var vel_side : Vector2 = Vector2(0, 0)
var lastfloor : bool = false

var jumpbuffer : float = 0.0
var bookbuffer : float = 0.0
var speedbuffer : Vector2 = Vector2.ZERO

var hellyeah : bool = false
var lasthell : bool = false
var just_hell : bool = false

var underwater : bool = false

var locked_cam : bool = false
var camera_lock : Vector2 = Vector2.ZERO

var can_move : bool = true
var can_die : bool = true

var ghost_power_flying : bool = false
var ghost_canfly : bool = false
var lasghofly : bool = false
var ghost_flycount : float = 0.0


func _ready() -> void:
	if get_tree().current_scene.current_level.escape_on:
		for gem in get_parent().get_children():
			if gem is TimeGem:
				self.position = gem.position
				spin_area.damage_while_inside = true
				get_tree().current_scene.escape_lost = false
	else:
		for point in get_parent().get_children():
			if point is SpawnPoint:
				if point.id == SaveAndLoad.contents_to_save["spawn_point_id"]:
					self.position = point.position
	if get_parent().camera_boundaries != Vector4(1, 2, 3, 4):
		camera.limit_left = get_parent().camera_boundaries[0]
		camera.limit_right = get_parent().camera_boundaries[1]
		camera.limit_up = get_parent().camera_boundaries[2]
		camera.limit_down = get_parent().camera_boundaries[3]


func _physics_process(delta: float) -> void:
	lastspin = spinning
	last_last_vel = last_vel
	last_vel = velocity
	lasghofly = ghost_canfly

	just_hell = false

	vertdir = Input.get_axis("up", "down")

	if Input.is_action_just_pressed("jump") and can_move:
		jumpbuffer = jumpbuffer_set

	if Input.is_action_just_pressed("attack") and can_move:
		bookbuffer = bookbuffer_set

	if is_on_floor() and !lastfloor:
		spinbuffer = spinbuffer_set
		if !can_ground_pound and spinning:
			if Input.is_action_pressed("attack") and can_move:
				velocity.x = run_speed * face_dir * 6
				last_vel.x = velocity.x
				#print_debug("HELL YEAH!")
				hellyeah = true
				just_hell = true
			if Input.is_action_pressed("jump") and can_move:
				velocity.y = jump_speed * 1.5 if !Input.is_action_pressed("attack") else jump_speed
				wallclimb_mult = 0.8

	##print_debug(str(velocity.x))

	if abs(velocity.x) < 50 or face_dir != last_face:
		hellyeah = false

	if hellyeah:
		book_area.damage_while_inside = true
		book_area_cooldown = 0.1

	##print_debug(str(hellyeah))
	print_debug(str(velocity))

	
	# Add the gravity.
	if is_on_floor():
		ghost_canfly = false
		ghost_flycount = 0.0
		if velalter_reason == "backflip":
			velocity.x = (run_speed + book_speed) * face_dir
			freeze_x = false
			velalter_reason = "none"
			book_area.damage_while_inside = true
			book_area_cooldown = book_area_coolset
			#print_debug(velocity.x)
		can_double_jump = true
		if !can_ground_pound:
			grav_mult = grav_mult_default
			can_ground_pound = true
		if spinbuffer <= 0:
			spinning = false
		wallclimb_mult = 1.0
		if Input.is_action_pressed("down") and can_move:
			self.position.y += 1
	else:
		#if spinning:
			#if Input.is_action_pressed("down"):
				#grav_altmult = 2
			#else:
				#grav_altmult = 1
		velocity += get_gravity().rotated(grav_rotate) * delta * grav_mult * grav_altmult * int(!ghost_power_flying)


	lastfloor = is_on_floor()

	if (velocity.y <= 0) and (vel_side.y == -1):
		if !can_ground_pound:
			velocity.y = jump_speed * -3

	vel_side = side(velocity)
	##print_debug("side(velocity): " + str(vel_side))

	# Handle jump.
	if (jumpbuffer > 0) and can_move:
		if is_on_floor():
			if face_dir != side(velocity.x) and Input.is_action_pressed("run") and abs(velocity.x) > 100:
				velocity.x = backflip_velset * face_dir
				freeze("backflip", true, false)
				#print_debug("Hey Yo Do A Backflip Man")
				velocity.y = jump_speed
				spinning = true
			else:
				velocity.y = jump_speed
				jumpbuffer = 0
		else:
			if is_on_wall():
				face_dir = -face_dir
				velocity.x = run_speed * face_dir if Input.is_action_pressed("run") else speed * face_dir
				if wallclimb_mult > 0.0:
					velocity.y = jump_speed * wallclimb_mult
					wallclimb_mult -= 0.2
			ghost_canfly = true

	if powerup == "ghost":
		if Input.is_action_pressed("jump"):
			if lasghofly:
				if ghost_canfly:
					if Vector2(direction, vertdir).length() != 0:
						if ghost_flycount <= ghost_flylimit:
							ghost_flycount += delta
							ghost_power_flying = true
							velocity += Vector2(direction, vertdir).normalized() * ghost_power_accel
							if velocity.length() > ghost_power_speed:
								velocity *= 0.9
								if velocity.length() < ghost_power_speed:
									velocity = velocity.normalized() * ghost_power_speed
						else:
							ghost_canfly = false
							ghost_power_flying = false
					else:
						ghost_canfly = false
						ghost_power_flying = false
		else:
			ghost_power_flying = false
	
	if bookbuffer > 0 and can_move:
		if powerup == "none" or "ghost":
			neutral_attack_handling()
		if is_on_wall() and (not Input.is_action_pressed("down")) and (not Input.is_action_pressed("up")):
			face_dir = -face_dir
			velocity.x = run_speed * face_dir if Input.is_action_pressed("run") else speed * face_dir
			#print_debug("Wallcilmb Mult: " + str(wallclimb_mult))
			horzbounce_take = 35 * -face_dir
			if wallclimb_mult > 0.0:
				velocity.y = jump_speed * wallclimb_mult * 1.25
				wallclimb_mult -= 0.5
				spinning = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("left", "right")
	var spd = run_speed if Input.is_action_pressed("run") or book_area.damage_while_inside else speed
	if hellyeah and just_hell:
		spd = abs(last_vel.x)
	var acc = run_accel if Input.is_action_pressed("run") else accel

	if hellyeah and velocity.x > spd:
		acc = 0.0

	acc -= abs(horzbounce_take) if side(direction) == side(horzbounce_take) else 0
	##print_debug(str(acc))

	if direction and can_move:
		last_face = face_dir
		face_dir = direction / abs(direction)
		#var accs : float
		#var spd : float
		#if Input.is_action_pressed("run"):
			#accs = run_accel
			#spd = run_speed
		#else:
			#accs = accel
			#spd = speed
		
		if book_area.damage_while_inside and !Input.is_action_pressed("run") and !hellyeah and is_on_floor():
			spd += remap(book_area_coolset - book_area_cooldown, 0.0, book_area_coolset, 0.0, book_speed / 10)

		##print_debug(str(spd))

		velocity.x += acc * direction
		if abs(velocity.x) > spd:
			#print_debug(velocity.x)
			#velocity.x -= acc * direction
			if hellyeah:
				velocity.x *= 0.9
			else:
				velocity.x *= 0.7 if Input.is_action_pressed("run") else 0.4
			#velocity.x *= 0.9 * 0.7 if hellyeah else velocity.x
			var bonus_condition = true
			
			if hellyeah:
				#print_debug("Checking same speed...")
				if last_last_vel.x == last_vel.x:
					bonus_condition = false
			
			if (abs(velocity.x) < spd) and bonus_condition:
				velocity.x = spd * side(velocity.x)
	else:
		if hellyeah:
			velocity.x *= 0.9
		else:
			velocity.x *= 0.7 if Input.is_action_pressed("run") else 0.4
	
	if stop_x and velocity.x != 0.0:
		hold_x = velocity.x
		velocity.x = 0.0
	if stop_y and velocity.y != 0.0:
		hold_y = velocity.y
		velocity.y = 0.0

	if freeze_x and velocity.x != hold_x:
		velocity.x = hold_x
	if freeze_y and velocity.y != hold_y:
		velocity.y = hold_y

	if is_on_ceiling() and velalter_reason == "superbounce":
		freeze("none", 0, 0)

	speedbuffer = last_vel
	last_last_collided = last_collided
	last_collided = collided
	collided =  move_and_slide()
	if collided and !last_collided and !last_last_collided:
		velocity = speedbuffer
		##print_debug(velocity)
		##print_debug(spinning)

	update_animations()
	handle_cooldowns(delta)
	
	if locked_cam:
		camera.global_position = camera_lock

func update_animations():
	var playback = anim_tree["parameters/playback"]
	if face_dir == 1:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
	book_area.position.x = 24.0 * face_dir
	anim_tree["parameters/Move/blend_position"] = direction
	if Input.is_action_pressed("run") and direction:
		playback.travel("Run")
		anim_tree.set("parameters/Run/blend_position", direction)
	else:
		playback.travel("Move")
		anim_tree.set("parameters/Move/blend_position", direction)
	if (book_area_cooldown > book_area_cooldown - 0.25) and (book_area_cooldown - 0.25 > 0):
		playback.travel("book_normal")
	if spinning and !is_on_floor():
		playback.travel("spin")
	if hellyeah and (Input.is_action_pressed("attack") if abs(velocity.x) < (run_speed * 1.5) else true):
		playback.travel("HELL YEAH")
	##print_debug(str(spinning))

func handle_cooldowns(delta):
	book_cooldown -= delta
	twirl_cooldown -= delta
	stop_cooldown -= delta
	book_area_cooldown -= delta
	spinrun_book_cooldown -= delta
	if stop_cooldown < 0.0:
		stop_x = false
		stop_y = false
	if velalter_reason == "unspin" and !Input.is_action_pressed("run"):
		stop_y = false
	if book_area_cooldown < 0.0 and spinrun_book_cooldown < 0.0 and !hellyeah:
		book_area.damage_while_inside = false
	if spinning:
		spin_area.damage_while_inside = true
	else:
		spin_area.damage_while_inside = false
	jumpbuffer -= delta
	spinbuffer -= delta
	bookbuffer -= delta
	var lasthorz = horzbounce_take
	horzbounce_take -= delta * side(horzbounce_take) * 50
	if side(horzbounce_take) != 0 and side(lasthorz) != side(horzbounce_take):
		horzbounce_take = 0
	##print_debug(horzbounce_take)
	#print_debug(Vector2(freeze_x, freeze_y))
	#print_debug(Vector2(stop_x, stop_y))

func neutral_attack_handling():
	bookbuffer = 0
	if is_on_floor():
		if Input.is_action_pressed("up"):
			velocity = Vector2(velocity.x / 2, jump_speed * 1.5)
			can_double_jump = false
			spinning = true
		elif Input.is_action_pressed("down"):
			velocity = Vector2(0, -jump_speed)
			#grav_mult = grav_mult_default * 4
			#can_ground_pound = false
			spinning = true
		else:
			velocity.x += book_speed * face_dir
			book_area.damage_while_inside = true
			book_area_cooldown = book_area_coolset
	else:
		if Input.is_action_pressed("up") and can_double_jump:
			velocity = Vector2(velocity.x / 2, jump_speed)
			can_double_jump = false
			spinning = true
		elif Input.is_action_pressed("down") and can_ground_pound:
			velocity = Vector2(0, jump_speed)
			#grav_mult = grav_mult_default * 4
			can_ground_pound = false
			spinning = true
		else:
			if spinning:
				velocity = Vector2(book_speed * face_dir, jump_speed * 0.05)
				spinning = false
				book_area.damage_while_inside = true
				spinrun_book_cooldown = spinrun_book_coolset
				if Input.is_action_pressed("run"):
					freeze()
					stop_y = true
					stop_cooldown = spinrun_coolset
					velalter_reason = "unspin"
			else:
				if twirl_cooldown < 0:
					velocity.y = jump_speed * 0.05
					velocity.x = book_speed * face_dir
					twirl_cooldown = twirl_coolset
					book_area.damage_while_inside = true
					book_area_cooldown = book_area_coolset

func side(value):
	if (value is int) or (value is float):
		if value == 0:
			return 0
		else:
			return value / abs(value)
	elif (value is Vector2):
		return Vector2(value.x / abs(value.x) if value.x != 0 else 0, value.y / abs(value.y) if value.y != 0 else 0)
	else:
		print_debug("Couldn't get side of " + str(value))

func spin_hit():
	if Input.is_action_pressed("jump") or Input.is_action_pressed("up"):
		velocity.y = jump_speed
	elif Input.is_action_pressed("down"):
		velocity.y -= jump_speed * 0.5
		spinning = true
	else:
		if velocity.y > jump_speed * 0.5:
			velocity.y = jump_speed * 0.5

func freeze(reason : String = "none", x : bool = false, y : bool = false):
	if x:
		hold_x = velocity.x
		freeze_x = true
	else:
		freeze_x = false
	if y:
		hold_y = velocity.y
		freeze_y = true
	else:
		freeze_y = false
	velalter_reason = reason

#func stop(reason : String = "none", time : float = 0.0, x : bool = false, y : bool = false):
	#if x:
		#hold_x = velocity.x
		#freeze_x = true
	#else:
		#freeze_x = false
	#if y:
		#hold_y = velocity.y
		#freeze_y = true
	#else:
		#freeze_y = false
	#if x or y:
		#velalter_reason = reason

func lock_camera(lock : bool = true, at : Vector2 = Vector2.ZERO):
	if lock:
		camera.global_position = at
		camera_lock = camera.global_position
		locked_cam = true
	else:
		locked_cam = false
		camera.position = Vector2.ZERO
