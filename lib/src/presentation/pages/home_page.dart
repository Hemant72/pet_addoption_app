import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_addoption_app/src/domain/entities/pet.dart';
import 'package:pet_addoption_app/src/presentation/bloc/pet_bloc/pet_bloc.dart';
import 'package:pet_addoption_app/src/presentation/bloc/theme_bloc/bloc/theme_bloc.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileLayout;
  final Widget webLayout;

  const ResponsiveLayout({
    super.key,
    required this.mobileLayout,
    required this.webLayout,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return mobileLayout;
        }
        return webLayout;
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: _MobileLayout(),
      webLayout: _WebLayout(),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          const SearchBar(),
          Expanded(
            child: _buildPetList(),
          ),
        ],
      ),
    );
  }
}

class _WebLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Row(
        children: [
          Container(
            width: 300,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            child: Column(
              children: [
                const SearchBar(),
              ],
            ),
          ),
          Expanded(
            child: _buildPetGrid(),
          ),
        ],
      ),
    );
  }
}

Widget _buildPetList() {
  return BlocBuilder<PetBloc, PetState>(
    builder: (context, state) {
      if (state is PetLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is AvailablePetsLoaded) {
        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!state.hasReachedEnd &&
                scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
              context.read<PetBloc>().add(LoadAvailablePets(loadMore: true));
            }
            return true;
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount:
                state.hasReachedEnd ? state.pets.length : state.pets.length + 1,
            itemBuilder: (context, index) {
              if (index >= state.pets.length) {
                return const Center(child: CircularProgressIndicator());
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _PetCard(
                  pet: state.pets[index],
                  isGridView: false,
                ),
              );
            },
          ),
        );
      }
      return Container();
    },
  );
}

Widget _buildPetGrid() {
  return BlocBuilder<PetBloc, PetState>(
    builder: (context, state) {
      if (state is PetLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is AvailablePetsLoaded) {
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount:
              state.hasReachedEnd ? state.pets.length : state.pets.length + 1,
          itemBuilder: (context, index) {
            if (index >= state.pets.length) {
              return const Center(child: CircularProgressIndicator());
            }
            return _PetCard(
              pet: state.pets[index],
              isGridView: true,
            );
          },
        );
      }
      return Container();
    },
  );
}

class _PetCard extends StatelessWidget {
  final Pet pet;
  final bool isGridView;

  const _PetCard({
    required this.pet,
    required this.isGridView,
  });

  @override
  Widget build(BuildContext context) {
    if (isGridView) {
      return _buildGridCard(context);
    }
    return _buildListCard(context);
  }

  Widget _buildGridCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _navigateToDetails(context),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.network(
                pet.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
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
                      if (pet.isAdopted) _buildAdoptedBadge(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _navigateToDetails(context),
        borderRadius: BorderRadius.circular(16),
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
                        if (pet.isAdopted) _buildAdoptedBadge(),
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

  Widget _buildAdoptedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'Adopted',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _navigateToDetails(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/details',
      arguments: pet,
    );
  }
}

PreferredSizeWidget _buildAppBar(BuildContext context) {
  return AppBar(
    title: const Text(
      'Pet Adoption',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    actions: [
      IconButton(
        icon: const Icon(Icons.brightness_6_rounded),
        onPressed: () => context.read<ThemeBloc>().add(ToggleTheme()),
      ),
      IconButton(
        icon: const Icon(Icons.history_rounded),
        onPressed: () => Navigator.pushNamed(context, '/history'),
      ),
    ],
  );
}
