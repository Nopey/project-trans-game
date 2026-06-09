extends Sprite3D
class_name EnemyEye

@export var frames: Array[Texture]

@onready var laser: Sprite3D = $Laser

var attack_direction: DIRECTION
var attack_distance: float = 4
var timer: SceneTreeTimer
var can_be_defended: bool
var has_been_defended: bool

enum FRAME {
	IDLE,
	PREPARE,
	OUCH,
	ATTACK,
}

enum DIRECTION {
	W,
	QW,
	AW,
	EA, # it's in the game
	A,
	QA,
	AS,
	ES,
	S,
	QS,
	DS,
	ED,
	D,
	QD,
	DW,
	EW,
}

const INPUTS: Array[String] = [
	"move_up",    # W, 1
	"move_left",  # A, 2
	"move_down",  # S, 4
	"move_right", # D, 8
	"move_ccw",   # Q, 10
	"move_cw",    # E, 20
]
const CORRECT_INPUTS: Array[int] = [
	0x01, # W
	0x11, # QW
	0x03, # AW
	0x22, # EA
	0x02, # A
	0x12, # QA
	0x06, # AS
	0x24, # ES
	0x04, # S
	0x14, # QS
	0x0C, # DS
	0x28, # ED
	0x08, # D
	0x18, # QD
	0x09, # DW
	0x21, # EW
]
# directions that enemies don't spawn and Naomi can't defend
# to reenable 16-direction attacks instead of just 12, remove the WASD from inside.
const FAKE_DIRS: Array = [-1, DIRECTION.W, DIRECTION.A, DIRECTION.S, DIRECTION.D]
# const FAKE_DIRS: Array = [-1]

func _ready() -> void:
	# "start_idle"
	while attack_direction in FAKE_DIRS:
		attack_direction = randi_range(0, 15) as DIRECTION
	var angle = -PI/2 -(attack_direction as int) * TAU / 16.0
	laser.global_rotation.y = -angle + PI / 2
	var attack_dir_2d: Vector2 = Vector2.from_angle(angle)
	global_position += attack_distance * Vector3(attack_dir_2d.x, 0, attack_dir_2d.y)
	var duration: float = randf_range(0.4, 0.8)
	laser.hide()
	texture = frames[FRAME.IDLE]
	timer = get_tree().create_timer(duration)
	timer.timeout.connect(start_prepare)

func start_prepare() -> void:
	can_be_defended = true
	texture = frames[FRAME.PREPARE]
	timer = get_tree().create_timer(1.5)
	timer.timeout.connect(start_attack)

func start_ouch() -> void:
	if has_been_defended:
		return
	has_been_defended = true
	texture = frames[FRAME.OUCH]
	laser.hide()
	timer = get_tree().create_timer(0.5)
	timer.timeout.connect(queue_free)

func start_attack() -> void:
	if has_been_defended:
		return
	texture = frames[FRAME.ATTACK]
	laser.show()

static func get_held_inputs() -> int:
	var held_inputs = 0
	for i in INPUTS.size():
		if Input.is_action_pressed(INPUTS[i]):
			held_inputs |= 1 << i
	return held_inputs

func _process(_delta: float) -> void:
	if can_be_defended and CORRECT_INPUTS[attack_direction] == get_held_inputs():
		start_ouch()
