extends Control
onready var btnCoin = $Control/container/Container1/coin
onready var btncloseStore = $Control/container/containe2/btnCerrar

var tween = Tween.new()

func _ready():
	SignalsConnect();
	ControlarCoins()
	btnCoin.text = str(_Datos.data["coins"]).pad_zeros(4)
	add_child(tween)
	tween.interpolate_property(self,"rect_position",Vector2(0,-1170),Vector2(0,0),1,1,1)
	tween.start()
	pass
	
func ControlarCoins()->void:
	if _Datos.data["coins"] >= 10000:
		_Datos.data["coins"] = 9999;
		_Datos.save_data();
func SignalsConnect()->void:
	btncloseStore.connect("pressed",self,"onBtnCloseStore")
	pass
func onBtnCloseStore()->void:
	get_tree().paused = false;
	tween.interpolate_property(self,"rect_position",Vector2(0,0),Vector2(0,-1170),1,1,1)
	tween.start()
	yield(tween,"tween_completed")
	queue_free()
