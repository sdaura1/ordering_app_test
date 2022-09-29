class OrderHistoryItemModel {

  String categoryId, categoryName, createdAt, description,
      id, name, orderItemId, orderStatus, image;
  double price;
  int quantity;

  OrderHistoryItemModel({
    required this.categoryId,
    required this.categoryName,
    required this.createdAt,
    required this.description,
    required this.id,
    required this.name,
    required this.orderItemId,
    required this.orderStatus,
    required this.price,
    required this.quantity,
    required this.image,
  });

  OrderHistoryItemModel.fromJson(Map<dynamic, dynamic> dataSnapShot)
      : categoryId = dataSnapShot['categoryId'].toString(),
        categoryName = dataSnapShot['categoryName'].toString(),
        createdAt = dataSnapShot['createdAt'].toString(),
        description = dataSnapShot['description'].toString(),
        id = dataSnapShot['id'].toString(),
        name = dataSnapShot['name'].toString(),
        orderItemId = dataSnapShot['orderItemId'].toString(),
        orderStatus = dataSnapShot['orderStatus'].toString(),
        price = double.parse(dataSnapShot['price'].toString()),
        quantity = int.parse(dataSnapShot['quantity'].toString()),
        image = dataSnapShot['image'].toString();

  Map<String, dynamic> toJson() => {
    'categoryId' : categoryId,
    'categoryName' : categoryName,
    'createdAt' : createdAt,
    'description' : description,
    'id' : id,
    'name' : name,
    'orderItemId' : orderItemId,
    'orderStatus' : orderStatus,
    'price' : price,
    'quantity' : quantity,
    'imageUrl' : image
  };
}