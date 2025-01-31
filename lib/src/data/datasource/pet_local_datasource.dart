import 'dart:convert';

import 'package:pet_addoption_app/core/constants/sample_data.dart';
import 'package:pet_addoption_app/core/error/exception.dart';
import 'package:pet_addoption_app/src/data/model/pet_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PetLocalDataSource {
  Future<List<PetModel>> getAvailablePets();
  Future<List<PetModel>> getAdoptedPets();
  Future<void> adoptPet(String petId);
  Future<void> cachePets(List<PetModel> pets);
}

class PetLocalDataSourceImpl implements PetLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const CACHED_PETS_KEY = 'CACHED_PETS';

  PetLocalDataSourceImpl({required this.sharedPreferences}) {
    if (sharedPreferences.getString(CACHED_PETS_KEY) == null) {
      final List<Map<String, dynamic>> samplePetsJson = SamplePets.pets;
      sharedPreferences.setString(CACHED_PETS_KEY, json.encode(samplePetsJson));
    }
  }

  @override
  Future<List<PetModel>> getAvailablePets() async {
    final jsonString = sharedPreferences.getString(CACHED_PETS_KEY);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((json) => PetModel.fromJson(json))
          .where((pet) => !pet.isAdopted)
          .toList();
    } else {
      throw CacheException();
    }
  }

  @override
  Future<List<PetModel>> getAdoptedPets() async {
    final jsonString = sharedPreferences.getString(CACHED_PETS_KEY);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((json) => PetModel.fromJson(json))
          .where((pet) => pet.isAdopted)
          .toList();
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> adoptPet(String petId) async {
    final jsonString = sharedPreferences.getString(CACHED_PETS_KEY);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      final List<PetModel> pets =
          jsonList.map((json) => PetModel.fromJson(json)).toList();

      final updatedPets = pets.map((pet) {
        if (pet.id == petId) {
          return PetModel(
            id: pet.id,
            name: pet.name,
            age: pet.age,
            price: pet.price,
            imageUrl: pet.imageUrl,
            isAdopted: true,
          );
        }
        return pet;
      }).toList();

      await cachePets(updatedPets);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cachePets(List<PetModel> pets) async {
    final List<Map<String, dynamic>> jsonList =
        pets.map((pet) => pet.toJson()).toList();
    await sharedPreferences.setString(CACHED_PETS_KEY, json.encode(jsonList));
  }
}
