extends Node

class_name PlayBilling, "res://PlayBilling-lib/icon.png"

# "private" properties
var payment = null
func _ready():
	if Engine.has_singleton("GodotGooglePlayBilling"):
		payment = Engine.get_singleton("GodotGooglePlayBilling")
		# These are all signals supported by the API
		# You can drop some of these based on your needs
		payment.connect("connected", self, "_on_connected") # No params
		payment.connect("disconnected", self, "_on_disconnected") # No params
		payment.connect("connect_error", self, "_on_connect_error") # Response ID (int), Debug message (string)
		payment.connect("purchases_updated", self, "_on_purchases_updated") # Purchases (Dictionary[])
		payment.connect("purchase_error", self, "_on_purchase_error") # Response ID (int), Debug message (string)
		payment.connect("sku_details_query_completed", self, "_on_sku_details_query_completed") # SKUs (Dictionary[])        
		payment.connect("sku_details_query_error", self, "_on_sku_details_query_error") # Response ID (int), Debug message (string), Queried SKUs (string[])
		payment.connect("purchase_acknowledged", self, "_on_purchase_acknowledged") # Purchase token (string)
		payment.connect("purchase_acknowledgement_error", self, "_on_purchase_acknowledgement_error") # Response ID (int), Debug message (string), Purchase token (string)
		payment.connect("purchase_consumed", self, "_on_purchase_consumed") # Purchase token (string)
		payment.connect("purchase_consumption_error", self, "_on_purchase_consumption_error") # Response ID (int), Debug message (string), Purchase token (string)
		payment.startConnection()
	else:
		print("Android IAP support is not enabled. Make sure you have enabled 'Custom Build' and the GodotGooglePlayBilling plugin in your Android export settings! IAP will not work.")	
	pass 

func _on_connected():
#	payment.querySkuDetails(["my_iap_item"], "inapp") # "subs" for subscriptions
#	payment.querySkuDetails(["my_subs_item"], "subs") # "subs" for subscriptions
#	payment.purchase("inapp")
#	payment.purchase("subs")
	print("connected")
	
func _on_disconnected()->void:
	print("disconnected")
	
func _on_connect_error(response_id:int)->void:
	print("_on_connected_error "+str(response_id))

func _on_sku_details_query_completed(sku_details):
	print("_on_sku_details_query_completed")
	for available_sku in sku_details:
		print(available_sku)

func _on_sku_details_query_error(response_id,debug_message,queried_SKUs)->void:
	print("_on_sku_details_query_error"+str(response_id)+str(debug_message)+str(queried_SKUs))
	
func _on_purchases_updated(purchases):
	print("_on_purchases_updated")
	for purchase in purchases:
		if purchase.purchase_state == 1: # 1 means "purchased", see https://developer.android.com/reference/com/android/billingclient/api/Purchase.PurchaseState#constants_1
			# enable_premium(purchase.sku) # unlock paid content, add coins, save token on server, etc. (you have to implement enable_premium yourself)
			if not purchase.is_acknowledged:
				#payment.acknowledgePurchase(purchase.purchase_token) # call if non-consumable product
				if purchase.products:
					if purchase.products.size() > 0:
						if purchase.products[0] == "my_iap_item":
							payment.consumePurchase(purchase.purchase_token) 
						else:
							payment.acknowledgedPurchase(purchase.purchase_token)

func _on_purchase_consumed(token)->void:
	print("_on_purchase_consumed "+token)
	
func _on_purchase_consumption_error(response_id,debug_message)->void:
	print("_on_purchase_consumption_error "+str(response_id)+str(debug_message))

func _on_purchase_acknowledged(token)->void:
	print("_on_purchase_acknowledged "+token)
	
func _on_purchase_acknowledgement_error(response_id,debug_message)->void:
	print("_on_purchase_acknowledgement_error "+str(response_id)+str(debug_message))
	
func _on_purchase_error(response_id,debug_message)->void:
	print("_on_purchase_error "+str(response_id)+str(debug_message))
