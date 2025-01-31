import 'package:pet_addoption_app/src/domain/entities/pet.dart';

class PetModel extends Pet {
  const PetModel({
    required super.id,
    required super.name,
    required super.age,
    required super.price,
    required super.imageUrl,
    super.isAdopted,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      isAdopted: json['isAdopted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'price': price,
      'imageUrl': imageUrl,
      'isAdopted': isAdopted,
    };
  }
}
