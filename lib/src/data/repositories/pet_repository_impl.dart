import 'package:dartz/dartz.dart';
import 'package:pet_addoption_app/core/error/exception.dart';
import 'package:pet_addoption_app/core/error/failures.dart';
import 'package:pet_addoption_app/src/data/datasource/pet_local_datasource.dart';
import 'package:pet_addoption_app/src/domain/entities/pet.dart';
import 'package:pet_addoption_app/src/domain/repositories/pet_repository.dart';

class PetRepositoryImpl implements PetRepository {
  final PetLocalDataSource localDataSource;

  PetRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Pet>>> getAvailablePets() async {
    try {
      final pets = await localDataSource.getAvailablePets();
      return Right(pets);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Pet>>> getAdoptedPets() async {
    try {
      final pets = await localDataSource.getAdoptedPets();
      return Right(pets);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> adoptPet(String petId) async {
    try {
      await localDataSource.adoptPet(petId);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
