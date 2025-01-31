import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_addoption_app/src/domain/entities/pet.dart';
import 'package:pet_addoption_app/src/domain/usecases/adopt_pet.dart';
import 'package:pet_addoption_app/src/domain/usecases/get_adopted_pets.dart';
import 'package:pet_addoption_app/src/domain/usecases/get_available_pets.dart';

part 'pet_event.dart';
part 'pet_state.dart';

class PetBloc extends Bloc<PetEvent, PetState> {
  static const int PETS_PER_PAGE = 6;

  final GetAvailablePets getAvailablePets;
  final GetAdoptedPets getAdoptedPets;
  final AdoptPet adoptPet;

  List<Pet> _allPets = [];
  List<Pet> _filteredPets = [];

  PetBloc({
    required this.getAvailablePets,
    required this.getAdoptedPets,
    required this.adoptPet,
  }) : super(PetInitial()) {
    on<LoadAvailablePets>(_onLoadAvailablePets);
    on<LoadAdoptedPets>(_onLoadAdoptedPets);
    on<AdoptPetEvent>(_onAdoptPet);
    on<SearchPets>(_onSearchPets);
  }

  Future<void> _onLoadAvailablePets(
    LoadAvailablePets event,
    Emitter<PetState> emit,
  ) async {
    if (!event.loadMore) {
      emit(PetLoading());
    }

    final result = await getAvailablePets(NoParams());

    result.fold(
      (failure) => emit(PetError(message: 'Failed to load pets')),
      (pets) {
        _allPets = pets;
        _filteredPets = pets;

        final currentState = state;
        final currentPage =
            event.loadMore && currentState is AvailablePetsLoaded
                ? currentState.currentPage + 1
                : 0;

        final paginatedPets = _getPaginatedPets(_filteredPets, currentPage);

        emit(AvailablePetsLoaded(
          pets: paginatedPets,
          hasReachedEnd: paginatedPets.length >= _filteredPets.length,
          currentPage: currentPage,
        ));
      },
    );
  }

  List<Pet> _getPaginatedPets(List<Pet> pets, int page) {
    final startIndex = 0;
    final endIndex = math.min((page + 1) * PETS_PER_PAGE, pets.length);
    return pets.sublist(startIndex, endIndex);
  }

  Future<void> _onLoadAdoptedPets(
    LoadAdoptedPets event,
    Emitter<PetState> emit,
  ) async {
    emit(PetLoading());
    final result = await getAdoptedPets(NoParams());

    result.fold(
      (failure) => emit(PetError(message: 'Failed to load adopted pets')),
      (pets) => emit(AdoptedPetsLoaded(pets: pets)),
    );
  }

  Future<void> _onAdoptPet(
    AdoptPetEvent event,
    Emitter<PetState> emit,
  ) async {
    emit(PetLoading());
    final result = await adoptPet(AdoptPetParams(petId: event.petId));

    result.fold(
      (failure) => emit(PetError(message: 'Failed to adopt pet')),
      (_) {
        add(LoadAvailablePets());
        add(LoadAdoptedPets());
      },
    );
  }

  Future<void> _onSearchPets(
    SearchPets event,
    Emitter<PetState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(AvailablePetsLoaded(pets: _allPets));
      return;
    }

    final filteredPets = _allPets
        .where(
            (pet) => pet.name.toLowerCase().contains(event.query.toLowerCase()))
        .toList();

    emit(AvailablePetsLoaded(
      pets: filteredPets,
      searchQuery: event.query,
    ));
  }
}
