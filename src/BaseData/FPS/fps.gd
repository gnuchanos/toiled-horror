extends CharacterBody3D



@onready var head = $head
@onready var Camera = $head/Camera3D
@onready var body = $body

const  bodyDuck: int = 1
const  bodyCrawley: float = 0.3
const bodyMaxHeight: int = 2
var bodyCurrentHeight: float = 2

var Dukking: bool  = false
var Crawling: bool = false
const  CrawlingOrDuckingSpeed: int = 5

@onready var SettingsWindow = $UI/settings
@onready var HeadRay = $HeadRay

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if GlobalVAR.PlayerCanMove and not GlobalVAR.PlayerLookingConsole and not GlobalVAR.PlayerLookingSettings:
		if event is InputEventMouseMotion:
			rotate_y(deg_to_rad(-event.relative.x * GlobalVAR.MouseSpeed))
			head.rotate_x(deg_to_rad(-event.relative.y * GlobalVAR.MouseSpeed))
			head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		if GlobalVAR.PlayerLookingSettings:
			GlobalVAR.PlayerLookingSettings = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			SettingsWindow.hide()
		else:
			GlobalVAR.PlayerLookingSettings = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			SettingsWindow.show()

	# i hope this is can't be performance problem
	Camera.fov = GlobalVAR.PlayerFOV_Current

	$shader0.visible = GlobalVAR.shader0
	$shader1.visible = GlobalVAR.shader1

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if GlobalVAR.PlayerCanMove and not GlobalVAR.PlayerLookingConsole and not GlobalVAR.PlayerLookingSettings:
		# duck duck mother ducker
		if Input.is_action_pressed("duck") and not HeadRay.is_colliding():
			body.shape.height -= CrawlingOrDuckingSpeed * delta
			head.position.y = 0.7
			Crawling = false
			Dukking  = true
			body.shape.height = clamp(body.shape.height, bodyDuck, bodyMaxHeight)
			GlobalVAR.PlayerCurrentSpeed = 3

		# it's crawl but i give name crowley for fun
		elif Input.is_action_pressed("crowley"):
			body.shape.height -= CrawlingOrDuckingSpeed * delta
			head.position.y = 0.3
			Crawling = true
			Dukking  = false
			body.shape.height = clamp(body.shape.height, bodyCrawley, bodyMaxHeight)
			GlobalVAR.PlayerCurrentSpeed = 1

		else:
			if not HeadRay.is_colliding():
				body.shape.height += CrawlingOrDuckingSpeed * delta
				head.position.y = 1
				Crawling = false
				Dukking  = false
				body.shape.height = clamp(body.shape.height, bodyDuck, bodyMaxHeight)

				# if you running you can't zoom
				if not Input.is_action_just_pressed("rightM"):
					if Input.is_action_pressed("run"):
						GlobalVAR.PlayerCurrentSpeed += 80 * delta
						GlobalVAR.PlayerJump_Height_Current += 100 * delta
						if Input.is_action_pressed('w'):
							GlobalVAR.PlayerFOV_Current  += 80 * delta
					else:
						GlobalVAR.PlayerCurrentSpeed -= 100 * delta
						GlobalVAR.PlayerFOV_Current  -= 100 * delta
						GlobalVAR.PlayerJump_Height_Current -= 100 * delta

					GlobalVAR.PlayerJump_Height_Current = clamp(GlobalVAR.PlayerJump_Height_Current, GlobalVAR.PlayerJump_Height_Min, GlobalVAR.PlayerJump_Height_Max)

				# base running speed min and max
				GlobalVAR.PlayerCurrentSpeed = clamp(GlobalVAR.PlayerCurrentSpeed, GlobalVAR.PlayerMinSpeed, GlobalVAR.PlayerMaxSpeed)

		if Input.is_action_just_pressed("space") and is_on_floor() and GlobalVAR.PlayerCanJump:
			velocity.y = GlobalVAR.PlayerJump_Height_Current

		# Right click for zoom
		if Input.is_action_pressed("rightM") and not Input.is_action_pressed("run"):
			GlobalVAR.PlayerFOV_Current  -= 80 * delta
			GlobalVAR.PlayerFOV_Current  = clamp(GlobalVAR.PlayerFOV_Current, GlobalVAR.PlayerFOV_MIN-10, GlobalVAR.PlayerFOV_MIN)
		else:
			GlobalVAR.PlayerFOV_Current  = clamp(GlobalVAR.PlayerFOV_Current, GlobalVAR.PlayerFOV_MIN, GlobalVAR.PlayerFOV_MIN+20)

		# I do this because if the collision height becomes small, the radius also becomes small.
		body.shape.radius = clamp(body.shape.height, 0.4, 0.4)


		# Player Move (all note for me because i have adhd)
		var input_dir := Input.get_vector('a', 'd', 'w', 's')
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * GlobalVAR.PlayerCurrentSpeed
			velocity.z = direction.z * GlobalVAR.PlayerCurrentSpeed
		else:
			velocity.x = move_toward(velocity.x, 0, GlobalVAR.PlayerCurrentSpeed)
			velocity.z = move_toward(velocity.z, 0, GlobalVAR.PlayerCurrentSpeed)

	move_and_slide()
