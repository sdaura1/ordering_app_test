class CategoryModel {

  String name, id, createdAt, updatedAt, waitingTime;
  double deliveryFee, packageAmount, serviceFee;

  CategoryModel({
    required this.name,
    required this.createdAt,
    required this.id,
    required this.deliveryFee,
    required this.packageAmount,
    required this.serviceFee,
    required this.updatedAt,
    required this.waitingTime,
  });

  CategoryModel.fromJson(Map<dynamic, dynamic> dataSnapShot)
      : name = dataSnapShot['name'].toString(),
        createdAt = dataSnapShot['createdAt'].toString(),
        id = dataSnapShot['id'].toString(),
        deliveryFee = double.parse(dataSnapShot['deliveryFee'].toString()),
        packageAmount = double.parse(dataSnapShot['packageAmount'].toString()),
        serviceFee = double.parse(dataSnapShot['serviceFee'].toString()),
        updatedAt = dataSnapShot['updatedAt'].toString(),
        waitingTime = dataSnapShot['waitingTime'].toString();

  Map<String, dynamic> toJson() => {
    'name' : name,
    'createdAt' : createdAt,
    'id' : id,
    'deliveryFee' : deliveryFee,
    'packageAmount' : packageAmount,
    'serviceFee' : serviceFee,
    'updatedAt' : updatedAt,
    'waitingTime' : waitingTime,
  };
}