part of 'pet_bloc.dart';

sealed class PetState extends Equatable {
  const PetState();

  @override
  List<Object> get props => [];
}

final class PetInitial extends PetState {}

final class PetLoading extends PetState {}

final class AvailablePetsLoaded extends PetState {
  final List<Pet> pets;
  final String? searchQuery;
  final bool hasReachedEnd;
  final int currentPage;

  const AvailablePetsLoaded({
    required this.pets,
    this.searchQuery,
    this.hasReachedEnd = false,
    this.currentPage = 0,
  });

  @override
  List<Object> get props =>
      [pets, searchQuery ?? '', hasReachedEnd, currentPage];
}

final class AdoptedPetsLoaded extends PetState {
  final List<Pet> pets;

  const AdoptedPetsLoaded({required this.pets});

  @override
  List<Object> get props => [pets];
}

final class PetError extends PetState {
  final String message;

  const PetError({required this.message});

  @override
  List<Object> get props => [message];
}
