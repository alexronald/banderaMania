extends Node

class_name PlayBilling, "res://PlayBilling-lib/icon.png"
signal connected;
signal disconnected;
signal connect_error;
signal purchases_updated;
signal purchase_error;
signal sku_details_query_completed;
signal sku_details_query_error;
signal purchase_acknowledged;
signal purchase_acknowledgement_error;
signal purchase_consumed(token,idProducto);
signal purchase_consumption_error;

export var idItemConsumible:Array =["coins_5000","coins_11000","coins_25000"] 
export var iditemNoconsumible:Array=["consumible_item"]
var nameProduct
export var debugConsola:bool = true 
var msg:RichTextLabel = RichTextLabel.new();

var payment = null
var test_item_purchase_token = null
var list_product:Dictionary = {}

func _ready():
	add_child(msg)
	propiedadesMsg()
	if Engine.has_singleton("MyPlugin"):
		payment = Engine.get_singleton("MyPlugin")
		msg.text+="/n __ESTA CONECTADO__";
		if not .is_connected("connected", self, "_on_connected"):
			msg.text+="/n __ESTA CONECTADO__";
			connectSignal()
		# These are all signals supported by the API
		# You can drop some of these based on your needs
		 # Response ID (int), Debug message (string), Purchase token (string)
		payment.startConnection()
		msg.text+="/n __funcion__"+str(payment.getPluginName());
	else:
		print("Android IAP support is not enabled. Make sure you have enabled 'Custom Build' and the GodotGooglePlayBilling plugin in your Android export settings! IAP will not work.")	
	pass 
	
func connectSignal():
	payment.connect("connected", self, "_on_connected") # No params
	payment.connect("disconnected", self, "_on_disconnected") # No params
	payment.connect("connect_error", self, "_on_connect_error") # Response ID (int), Debug message (string)
	payment.connect("purchases_updated", self, "_on_purchases_updated") # Purchases (Dictionary[])
	payment.connect("query_purchases_response", self, "_on_query_purchases_response") # Purchases (Dictionary[])
	payment.connect("purchase_error", self, "_on_purchase_error") # Response ID (int), Debug message (string)
	payment.connect("product_details_query_completed", self, "_on_product_details_query_completed") # SKUs (Dictionary[])        
	payment.connect("product_details_query_error", self, "_on_product_details_query_error") # Response ID (int), Debug message (string), Queried SKUs (string[])
	payment.connect("purchase_acknowledged", self, "_on_purchase_acknowledged") # Purchase token (string)
	payment.connect("purchase_acknowledgement_error", self, "_on_purchase_acknowledgement_error") # Response ID (int), Debug message (string), Purchase token (string)
	payment.connect("purchase_consumed", self, "_on_purchase_consumed") # Purchase token (string)
	payment.connect("purchase_consumption_error", self, "_on_purchase_consumption_error")

#FUNCTION OF PLUGIN
func buy(id_producto):
	if payment != null:
		payment.purchase(idItemConsumible[id_producto])
	pass

func isReady()->bool:
	if payment != null:
		return payment.isReady()
	return false

func getConnectionState()->int:
	if payment != null:
		return payment.getConnectionState()
	return 0
	
func queryPurchases(type:String)->void:
	if payment != null:
		payment.queryPurchases(type)
	
func querySkuDetails(list:Array,type:String)->void:
	if payment != null:
		payment.queryProductDetails(list,type)

func acknowledgePurchase(purchaseToken:String)->void:
	if payment != null:
		payment.acknowledgePurchase(purchaseToken)

func consumePurchase(purchaseToken:String)->void:
	if payment != null:
		payment.consumePurchase(purchaseToken)

func purchase(sku:String)->Dictionary:
	if payment != null:
		return payment.purchase(sku)
	return {}
#
#func updateSubscription(oldToken:String,sku:String,prorationMode:int)->Dictionary:
#	if payment != null:
#		return payment.purchase(sku)
#	return {}
func onMainResume()->void:
	if payment != null:
		payment.onMainResume()

#CONSOLA 
func propiedadesMsg():
	msg.tab_size = 24
	msg.rect_position=Vector2(30,80)
	msg.rect_min_size=Vector2(400,250)
	msg.visible = debugConsola
	pass

#FUNCIOTION ADICIONAL

func buscarProducto(nameProduct:String):
	if payment != null:
		payment.queryPurchases("inapp")
		if nameProduct in list_product:
			msg.text += ("\n PENDIENTE PARA CONSUMIR " + str(list_product))

func _on_connected():
	if payment != null:
		emit_signal("connected");
		payment.queryProductDetails(["consumible_item","coins_25000","coins_5000","coins_11000"], "inapp") # "subs" for subscriptions
		#payment.querySkuDetails(["my_subs_item"], "subs") # "subs" for subscriptions
		#var re = payment.queryPurchases("inapp")
		#var subs = payment.purchase("subs")
		msg.text += ("\n READY -> " +str(payment.isReady()))
		msg.text += ("\n ESTADO CONEXION -> " +str(payment.getConnectionState()))
		#msg.text += ("\n compras " + str(re))
		#$msg.text += ("\n subscripcion " + str(subs))
	
func _on_disconnected()->void:
	emit_signal("disconnected")
	msg.text+=("DESCONECTADO")
	
func _on_connect_error(response_id:int)->void:
	emit_signal("connect_error")
	msg.text+=("_on_connected_error "+str(response_id))

func _on_product_details_query_completed(sku_details):
	emit_signal("sku_details_query_completed")
	msg.text += ("\n _on_sku_details_query_completed")
	for available_sku in sku_details:
		print(available_sku)
		msg.text += ("\n _Detalle"+str(available_sku))

func _on_product_details_query_error(response_id,debug_message,queried_SKUs)->void:
	emit_signal("sku_details_query_error")
	msg.text += ("\n _on_sku_details_query_error"+str(response_id)+str(debug_message)+str(queried_SKUs))

func _on_purchases_updated(purchases):
	for purchase in purchases:
		if purchase.purchase_state == 1: # 1 means "purchased", see https://developer.android.com/reference/com/android/billingclient/api/Purchase.PurchaseState#constants_1
			# enable_premium(purchase.sku) # unlock paid content, add coins, save token on server, etc. (you have to implement enable_premium yourself)
			if not purchase.is_acknowledged:
				#payment.acknowledgePurchase(purchase.purchase_token) # call if non-consumable product
				if purchase.products:
					if purchase.products.size() > 0:
						if purchase.products[0] in idItemConsumible:
							nameProduct= str(purchase.products[0])
							payment.consumePurchase(purchase.purchase_token) 
						else:
							payment.acknowledgedPurchase(purchase.purchase_token)
	emit_signal("purchases_updated")
	
func _on_query_purchases_response(resultQuery):
	msg.text += ("\n _on_query_purchases_response " + str(resultQuery.status))
	for purchase in resultQuery.purchases:
		msg.text += ("\n ___PURCHASE " + str(purchase))
		list_product[purchase.products[0]] = {"purchese_token":purchase.purchase_token};
		if purchase.products[0] in idItemConsumible:
			payment.consumePurchase(purchase.purchase_token)
	msg.text += ("\n ___LISTA " + str(list_product))

func _on_purchase_consumed(token)->void:
	msg.text += ("\n _on_purchase_consumed "+token)
	emit_signal("purchase_consumed",token,nameProduct)
	
func _on_purchase_consumption_error(response_id,debug_message)->void:
	emit_signal("purchase_consumption_error")
	msg.text += ("\n _on_purchase_consumption_error "+str(response_id)+str(debug_message))

func _on_purchase_acknowledged(token)->void:
	emit_signal("purchase_acknowledged")
	msg.text += ("\n _on_purchase_acknowledged "+token)
	
func _on_purchase_acknowledgement_error(response_id,debug_message)->void:
	emit_signal("purchase_acknowledgement_error")
	msg.text += ("\n_on_purchase_acknowledgement_error "+str(response_id)+str(debug_message))
	
func _on_purchase_error(response_id,debug_message)->void:
	emit_signal("purchase_error")
	msg.text += ("\n_on_purchase_error "+str(response_id)+str(debug_message))
