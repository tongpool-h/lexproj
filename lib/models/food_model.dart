import 'dart:convert';

class FoodModel {
  final String id;
  final String category;
  final String nameFood;
  final String price;
  final String detail;
  final String image;
  
  FoodModel({
    required this.id,
    required this.category,
    required this.nameFood,
    required this.price,
    required this.detail,
    required this.image,
  });
  

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'nameFood': nameFood,
      'price': price,
      'detail': detail,
      'image': image,
    };
  }

  factory FoodModel.fromMap(Map<String, dynamic> map) {
    return FoodModel(
      id: map['id'] ?? '',
      category: map['category'] ?? '',
      nameFood: map['nameFood'] ?? '',
      price: map['price'] ?? '',
      detail: map['detail'] ?? '',
      image: map['image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory FoodModel.fromJson(String source) => FoodModel.fromMap(json.decode(source));
}
