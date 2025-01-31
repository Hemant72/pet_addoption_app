import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_addoption_app/src/domain/entities/pet.dart';
import 'package:pet_addoption_app/src/presentation/bloc/pet_bloc/pet_bloc.dart';
import 'package:pet_addoption_app/src/presentation/bloc/theme_bloc/bloc/theme_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pet Adoption',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6_rounded),
            onPressed: () => context.read<ThemeBloc>().add(ToggleTheme()),
          ),
          IconButton(
            icon: Icon(Icons.history_rounded),
            onPressed: () => Navigator.pushNamed(context, '/history'),
          ),
        ],
      ),
      body: Column(
        children: [
          const SearchBar(),
          Expanded(
            child: BlocBuilder<PetBloc, PetState>(
              builder: (context, state) {
                if (state is PetLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AvailablePetsLoaded) {
                  return NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!state.hasReachedEnd &&
                          scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent) {
                        context
                            .read<PetBloc>()
                            .add(LoadAvailablePets(loadMore: true));
                      }
                      return true;
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.hasReachedEnd
                          ? state.pets.length
                          : state.pets.length + 1,
                      itemBuilder: (context, index) {
                        if (index >= state.pets.length) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Hero(
                            tag: state.pets[index].id,
                            child: _PetListItem(pet: state.pets[index]),
                          ),
                        );
                      },
                    ),
                  );
                } else if (state is PetError) {
                  return Center(child: Text(state.message));
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PetListItem extends StatelessWidget {
  final Pet pet;

  const _PetListItem({required this.pet});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/details',
        arguments: pet,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Image.network(
                pet.imageUrl,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${pet.age} years old',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${pet.price.toStringAsFixed(2)}',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                        ),
                        if (pet.isAdopted)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Adopted',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
