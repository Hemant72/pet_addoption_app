part of 'pet_bloc.dart';

sealed class PetEvent extends Equatable {
  const PetEvent();

  @override
  List<Object> get props => [];
}

final class LoadAvailablePets extends PetEvent {
  final bool loadMore;

  const LoadAvailablePets({this.loadMore = false});

  @override
  List<Object> get props => [loadMore];
}

final class LoadAdoptedPets extends PetEvent {}

final class SearchPets extends PetEvent {
  final String query;

  const SearchPets({required this.query});

  @override
  List<Object> get props => [query];
}

final class AdoptPetEvent extends PetEvent {
  final String petId;

  const AdoptPetEvent({required this.petId});

  @override
  List<Object> get props => [petId];
}
