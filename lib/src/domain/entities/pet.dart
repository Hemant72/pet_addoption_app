import 'package:equatable/equatable.dart';

class Pet extends Equatable {
  final String id;
  final String name;
  final int age;
  final double price;
  final String imageUrl;
  final bool isAdopted;

  const Pet({
    required this.id,
    required this.name,
    required this.age,
    required this.price,
    required this.imageUrl,
    this.isAdopted = false,
  });

  Pet copyWith({
    String? id,
    String? name,
    String? species,
    int? age,
    double? price,
    String? imageUrl,
    bool? isAdopted,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isAdopted: isAdopted ?? this.isAdopted,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, age, price, imageUrl, isAdopted];
}
