import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_addoption_app/src/presentation/bloc/pet_bloc/pet_bloc.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search pets...',
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Theme.of(context).primaryColor,
          ),
          filled: true,
          fillColor: Theme.of(context).cardColor,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.filter_list_rounded,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {},
          ),
        ),
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        cursorColor: Theme.of(context).primaryColor,
        onChanged: (value) {
          context.read<PetBloc>().add(SearchPets(query: value));
        },
      ),
    );
  }
}
