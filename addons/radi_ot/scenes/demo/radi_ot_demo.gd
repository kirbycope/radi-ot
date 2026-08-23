extends Node3D

## Demo controller for testing the radi-ot 3D radio addon.

const AUDIO_SPACE_NEEDLE: AudioStream = preload(
	"res://addons/radi_ot/assets/audio/eleven_labs/david/breaking_news_space_needle.mp3"
)
const AUDIO_COASTAL_WIND: AudioStream = preload(
	"res://addons/radi_ot/assets/audio/eleven_labs/david/weather_alert_coastal_wind.mp3"
)

@export var radio_player: RadiOtPlayer3D

@onready var _bulletin_button_1: Button = $UI/VBoxContainer/BulletinBtn1 as Button
@onready var _bulletin_button_2: Button = $UI/VBoxContainer/BulletinBtn2 as Button
@onready var _cancel_bulletin_btn: Button = $UI/VBoxContainer/CancelBulletinBtn as Button
@onready var _camera: Camera3D = $Camera3D as Camera3D


func _ready() -> void:
	if radio_player == null and has_node("RadioMesh/RadiOtPlayer3D"):
		radio_player = get_node("RadioMesh/RadiOtPlayer3D") as RadiOtPlayer3D

	if _bulletin_button_1 != null:
		_bulletin_button_1.pressed.connect(_on_bulletin_1_pressed)
	if _bulletin_button_2 != null:
		_bulletin_button_2.pressed.connect(_on_bulletin_2_pressed)
	if _cancel_bulletin_btn != null:
		_cancel_bulletin_btn.pressed.connect(_on_cancel_bulletin_pressed)


func _process(delta: float) -> void:
	# Subtle slow camera orbit to showcase 3D spatial audio
	if _camera != null:
		var current_y: float = _camera.position.y
		var time: float = Time.get_ticks_msec() / 1000.0 * 0.2
		_camera.position.x = sin(time) * 4.0
		_camera.position.z = cos(time) * 4.0
		_camera.position.y = current_y
		_camera.look_at(Vector3(0.0, 0.5, 0.0))


func _on_bulletin_1_pressed() -> void:
	if radio_player != null:
		radio_player.urgent_bulletin(
			AUDIO_SPACE_NEEDLE,
			"Unidentified phenomena reported over the Space Needle! Citizens are advised to stay indoors."
		)


func _on_bulletin_2_pressed() -> void:
	if radio_player != null:
		radio_player.urgent_bulletin(
			AUDIO_COASTAL_WIND,
			"Severe coastal wind advisory in effect across Puget Sound and SR-99 Alaskan Way."
		)


func _on_cancel_bulletin_pressed() -> void:
	if radio_player != null:
		radio_player.cancel_bulletin()
