extends Node
class_name AdsControl
var recopensa=false

func adsControl():
	print("ADS CONTROL")
	pass

func cargarMostraVideoAds():
	recopensa = true
	if _AdMob.is_rewarded_video_loaded():
		_AdMob.show_rewarded_video()
	else:
		_AdMob.load_rewarded_video()
		_AdMob.show_rewarded_video()
	pass 

func recompensaVideoAds()->String:
	var newCoin=_Datos.data["coins"]
	if recopensa :
		_Datos.data["coins"] = _Datos.data["coins"]+60
		_Datos.save_data()
		newCoin = str(_Datos.data["coins"]).pad_zeros(4)
		_AdMob.load_rewarded_video();
		recopensa = false
	return newCoin
	pass

func cargarMostraInterstitialAds():
	recopensa = true
	if _AdMob.is_interstitial_loaded():
		_AdMob.show_interstitial()
	else:
		_AdMob.load_interstitial()
		_AdMob.show_interstitial()
	pass 
