extends Sprite


export var scroll_amount: float

var root_position: float


func _ready():
	root_position = position.x


func _physics_process(delta):
	position.x = root_position - Global.player.global_position.x * scroll_amount
