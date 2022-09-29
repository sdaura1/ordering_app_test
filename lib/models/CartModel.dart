class CartModel {

  String id, name, description, imageUrl, status, category,
      createdAt, waitingTime;
  double price, deliveryFee, packageAmount, serviceFee;
  int quantity;

  CartModel({
    required this.id,
    required this.name,
    required this.price,
    required this.deliveryFee,
    required this.packageAmount,
    required this.serviceFee,
    required this.description,
    required this.imageUrl,
    required this.status,
    required this.category,
    required this.createdAt,
    required this.waitingTime,
    required this.quantity
  });

  CartModel.fromJson(Map<dynamic, dynamic> dataSnapShot)
      : id = dataSnapShot['id'].toString(),
        name = dataSnapShot['name'].toString(),
        price = double.parse(dataSnapShot['price'].toString()),
        deliveryFee = double.parse(dataSnapShot['deliveryFee'].toString()),
        packageAmount = double.parse(dataSnapShot['packageAmount'].toString()),
        serviceFee = double.parse(dataSnapShot['serviceFee'].toString()),
        description = dataSnapShot['description'].toString(),
        imageUrl = dataSnapShot['imageUrl'].toString(),
        status = dataSnapShot['status'].toString(),
        category = dataSnapShot['category'].toString(),
        createdAt = dataSnapShot['createdAt'].toString(),
        waitingTime = dataSnapShot['waitingTime'].toString(),
        quantity = int.parse(dataSnapShot['quantity'].toString());

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name' : name,
    'price' : price,
    'deliveryFee' : deliveryFee,
    'packageAmount' : packageAmount,
    'serviceFee' : serviceFee,
    'description' : description,
    'imageUrl' : imageUrl,
    'status' : status,
    'category' : category,
    'createdAt' : createdAt,
    'waitingTime' : waitingTime,
    'quantity' : quantity
  };
}