# BootOverlay.gd
extends Control

@onready var webview = $WebView

func _ready():
	webview.visible = true
	webview.url = "res://boot_sim.html"

# This function will be called from HTML when boot sequence finishes
func boot_finished():
	print("Boot sequence finished!")
	webview.visible = false
	get_tree().change_scene("res://level.tscn")
