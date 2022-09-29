class OrderItemModel {

  String foodId;
  int quantity;

  OrderItemModel({
    required this.foodId,
    required this.quantity,
  });

  OrderItemModel.fromJson(Map<dynamic, dynamic> dataSnapShot)
      : foodId = dataSnapShot['foodId'].toString(),
        quantity = int.parse(dataSnapShot['quantity'].toString());

  Map<String, dynamic> toJson() => {
    'foodId' : foodId,
    'quantity' : quantity
  };
}