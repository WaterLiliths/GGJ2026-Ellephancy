extends Node

var _seen: Dictionary = {}

func try_show(id: String, imagenes: Array[Texture2D], textos: Array[String]) -> void:
	if _seen.get(id, false):
		return
	_seen[id] = true
	Global.popup(imagenes, textos)
