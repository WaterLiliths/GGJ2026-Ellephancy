extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.fade_in.connect(fade_in)
	Global.fade_out_revivir.connect(fade_out_revivir)


func fade_in():
	play("fade_in")

func fade_out_revivir():
	play("fade_out_revivir")
