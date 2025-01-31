import 'package:dartz/dartz.dart';
import 'package:pet_addoption_app/core/error/failures.dart';
import 'package:pet_addoption_app/core/utils/usecase.dart';
import 'package:pet_addoption_app/src/domain/entities/pet.dart';
import 'package:pet_addoption_app/src/domain/repositories/pet_repository.dart';
import 'package:pet_addoption_app/src/domain/usecases/get_available_pets.dart';

class GetAdoptedPets implements UseCase<List<Pet>, NoParams> {
  final PetRepository repository;

  GetAdoptedPets(this.repository);

  @override
  Future<Either<Failure, List<Pet>>> call(NoParams params) async {
    return await repository.getAdoptedPets();
  }
}
