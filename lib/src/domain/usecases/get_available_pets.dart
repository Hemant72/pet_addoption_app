import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:pet_addoption_app/core/error/failures.dart';
import 'package:pet_addoption_app/core/utils/usecase.dart';
import 'package:pet_addoption_app/src/domain/entities/pet.dart';
import 'package:pet_addoption_app/src/domain/repositories/pet_repository.dart';

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}

class GetAvailablePets implements UseCase<List<Pet>, NoParams> {
  final PetRepository repository;

  GetAvailablePets(this.repository);

  @override
  Future<Either<Failure, List<Pet>>> call(NoParams params) async {
    return await repository.getAvailablePets();
  }
}
