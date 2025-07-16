class_name GuardState extends State

const IDLE = "Idle"
const RETURN = "Return"
const FOLLOW = "Follow"
const ATTACK = "Attack"

var guard: Guard


func _ready() -> void:
	await owner.ready
	guard = owner as Guard
	assert(guard != null, "GuardState node needs its parent to be a Guard.")
