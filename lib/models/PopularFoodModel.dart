class PopularFoodModel {

  String id, name, description;
  double price, deliveryFee, packageAmount, serviceFee;

  PopularFoodModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.deliveryFee,
    required this.packageAmount,
    required this.serviceFee
  });

  PopularFoodModel.fromJson(Map<dynamic, dynamic> dataSnapShot)
      : name = dataSnapShot['name'].toString(),
        price = double.parse(dataSnapShot['price'].toString()),
        deliveryFee = double.parse(dataSnapShot['deliveryFee'].toString()),
        packageAmount = double.parse(dataSnapShot['packageAmount'].toString()),
        serviceFee = double.parse(dataSnapShot['serviceFee'].toString()),
        id = dataSnapShot['id'].toString(),
        description = dataSnapShot['description'].toString();

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name' : name,
    'price' : price,
    'deliveryFee' : deliveryFee,
    'packageAmount' : packageAmount,
    'serviceFee' : serviceFee,
    'description' : description
  };

}