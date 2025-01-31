import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:pet_addoption_app/core/error/failures.dart';
import 'package:pet_addoption_app/core/utils/usecase.dart';
import 'package:pet_addoption_app/src/domain/repositories/pet_repository.dart';

class AdoptPetParams extends Equatable {
  final String petId;

  const AdoptPetParams({required this.petId});

  @override
  List<Object> get props => [petId];
}

class AdoptPet implements UseCase<void, AdoptPetParams> {
  final PetRepository repository;

  AdoptPet(this.repository);

  @override
  Future<Either<Failure, void>> call(AdoptPetParams params) async {
    return await repository.adoptPet(params.petId);
  }
}
