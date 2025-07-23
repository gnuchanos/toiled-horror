extends Node3D

@onready var FaceRay = $FPS/head/FaceRay

@onready var fpsLabel = $ui/fps

@onready var door1 = $rightDoors/rightDoor1/door/AnimationPlayer
@onready var door6 = $leftDoors/leftDoor1/door/AnimationPlayer
var door1Open = false

@onready var door2 = $rightDoors/rightDoor2/door/AnimationPlayer
@onready var door7 = $leftDoors/leftDoor2/door/AnimationPlayer
var door2Open = false

@onready var door3 = $rightDoors/rightDoor3/door/AnimationPlayer
@onready var door8 = $leftDoors/leftDoor3/door/AnimationPlayer
var door3Open = false

@onready var door4 = $rightDoors/rightDoor4/door/AnimationPlayer
@onready var door9 = $leftDoors/leftDoor4/door/AnimationPlayer
var door4Open = false

@onready var door5 = $rightDoors/rightDoor5/door/AnimationPlayer
@onready var door10 = $leftDoors/leftDoor5/door/AnimationPlayer
var door5Open = false

@onready var firstdoor = $firstDoor/firstdoor/firstdoorAnim
@onready var seconddoor = $secondDoor/secondDoor/secondDoorAnim
var firstdoorOpen = false

@onready var lights = [
	$light/OmniLight3D,
	$light/OmniLight3D2,
	$light/OmniLight3D3,
	$light/OmniLight3D4,
	$light/OmniLight3D5,
	$light/OmniLight3D6,
]

var lightMaterial = load("res://GameData/3D/toiled/em.tres")
var LightOpen = true

#lightMaterial.emission_enabled = false

func lightOnOff():
	for i in lights:
		i.visible = LightOpen
	lightMaterial.emission_enabled = LightOpen

func _ready() -> void:
	lightOnOff()


func _process(delta: float) -> void:
	fpsLabel.text = "  FPS: " + str(Engine.get_frames_per_second())


	if Input.is_action_just_pressed('e'):
		if FaceRay.is_colliding():
			var hit = FaceRay.get_collider()
			if hit.name == "leftDoor1":
				print("hello")
				if door1Open:
					door1.play_backwards("open")
					door6.play_backwards("open")
					door1Open = false
				else:
					door1.play("open")
					door6.play("open")
					door1Open = true

			elif hit.name == "leftDoor2":
				if door2Open:
					door2.play_backwards("open")
					door7.play_backwards("open")
					door2Open = false
				else:
					door2.play("open")
					door7.play("open")
					door2Open = true

			elif hit.name == "leftDoor3":
				if door3Open:
					door3.play_backwards("open")
					door8.play_backwards("open")
					door3Open = false
				else:
					door3.play("open")
					door8.play("open")
					door3Open = true

			elif hit.name == "leftDoor4":
				if door4Open:
					door4.play_backwards("open")
					door9.play_backwards("open")
					door4Open = false
				else:
					door4.play("open")
					door9.play("open")
					door4Open = true

			elif hit.name == "leftDoor5":
				if door5Open:
					door5.play_backwards("open")
					door10.play_backwards("open")
					door5Open = false
				else:
					door5.play("open")
					door10.play("open")
					door5Open = true

			elif hit.name == "firstdoor":
				if firstdoorOpen:
					firstdoor.play_backwards("firstDoor")
					seconddoor.play_backwards("secondDoor")
					firstdoorOpen = false
				else:
					firstdoor.play("firstDoor")
					seconddoor.play("secondDoor")
					firstdoorOpen = true
