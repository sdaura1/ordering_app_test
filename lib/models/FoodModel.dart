class FoodModel {

  String id, name, description, imageUrl, status, categoryId,
      createdAt, waitingTime;
  double price, deliveryFee, packageAmount, serviceFee;
  bool isDeleted, isActive;

  FoodModel({
    required this.id,
    required this.name,
    required this.price,
    required this.deliveryFee,
    required this.packageAmount,
    required this.serviceFee,
    required this.description,
    required this.imageUrl,
    required this.status,
    required this.createdAt,
    required this.categoryId,
    required this.waitingTime,
    required this.isActive,
    required this.isDeleted
  });

  FoodModel.fromJson(Map<dynamic, dynamic> dataSnapShot)
      : name = dataSnapShot['name'].toString(),
        price = double.parse(dataSnapShot['price'].toString()),
        deliveryFee = double.parse(dataSnapShot['deliveryFee'].toString()),
        packageAmount = double.parse(dataSnapShot['packageAmount'].toString()),
        serviceFee = double.parse(dataSnapShot['serviceFee'].toString()),
        id = dataSnapShot['id'].toString(),
        description = dataSnapShot['description'].toString(),
        imageUrl = dataSnapShot['image'].toString(),
        status = dataSnapShot['status'].toString(),
        createdAt = dataSnapShot['createdAt'].toString(),
        categoryId = dataSnapShot['categoryId'].toString(),
        waitingTime = dataSnapShot['waitingTime'].toString(),
        isActive = dataSnapShot['isActive'] ?? true,
        isDeleted = dataSnapShot['isDeleted'] ?? false;

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
    'createdAt': createdAt,
    'categoryId' : categoryId,
    'waitingTime' : waitingTime,
    'isActive' : isActive,
    'isDeleted' : isDeleted
  };

}