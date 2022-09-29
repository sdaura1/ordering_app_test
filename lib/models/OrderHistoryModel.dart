class OrderHistoryModel {

  String amount, createdAt, customerName, deliveryAddress,
      deliveryType, id, mobileNumber;

  OrderHistoryModel({
    required this.amount,
    required this.createdAt,
    required this.customerName,
    required this.deliveryAddress,
    required this.deliveryType,
    required this.id,
    required this.mobileNumber
  });

  OrderHistoryModel.fromJson(Map<dynamic, dynamic> dataSnapShot)
      : amount = dataSnapShot['amount'].toString(),
        createdAt = dataSnapShot['createdAt'].toString(),
        customerName = dataSnapShot['customerName'].toString(),
        deliveryAddress = dataSnapShot['deliveryAddress'].toString(),
        deliveryType = dataSnapShot['deliveryType'].toString(),
        id = dataSnapShot['id'].toString(),
        mobileNumber = dataSnapShot['mobileNumber'].toString();

  Map<String, dynamic> toJson() => {
    'amount' : amount,
    'createdAt' : createdAt,
    'customerName' : customerName,
    'deliveryAddress' : deliveryAddress,
    'deliveryType' : deliveryType,
    'id' : id,
    'mobileNumber' : mobileNumber
  };
}