import 'package:get_it/get_it.dart';
import 'package:pet_addoption_app/src/data/datasource/pet_local_datasource.dart';
import 'package:pet_addoption_app/src/data/repositories/pet_repository_impl.dart';
import 'package:pet_addoption_app/src/domain/repositories/pet_repository.dart';
import 'package:pet_addoption_app/src/domain/usecases/adopt_pet.dart';
import 'package:pet_addoption_app/src/domain/usecases/get_adopted_pets.dart';
import 'package:pet_addoption_app/src/domain/usecases/get_available_pets.dart';
import 'package:pet_addoption_app/src/presentation/bloc/pet_bloc/pet_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(
    () => PetBloc(
      getAvailablePets: sl(),
      getAdoptedPets: sl(),
      adoptPet: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAvailablePets(sl()));
  sl.registerLazySingleton(() => GetAdoptedPets(sl()));
  sl.registerLazySingleton(() => AdoptPet(sl()));

  // Repository
  sl.registerLazySingleton<PetRepository>(
    () => PetRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<PetLocalDataSource>(
    () => PetLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
