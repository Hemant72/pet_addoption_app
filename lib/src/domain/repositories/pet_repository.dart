import 'package:dartz/dartz.dart';
import 'package:pet_addoption_app/core/error/failures.dart';

import '../entities/pet.dart';

abstract class PetRepository {
  Future<Either<Failure, List<Pet>>> getAvailablePets();
  Future<Either<Failure, List<Pet>>> getAdoptedPets();
  Future<Either<Failure, void>> adoptPet(String petId);
}
