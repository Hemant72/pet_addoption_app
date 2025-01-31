import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_addoption_app/src/domain/entities/pet.dart';
import 'package:pet_addoption_app/src/presentation/bloc/pet_bloc/pet_bloc.dart';
import 'package:pet_addoption_app/src/presentation/bloc/theme_bloc/bloc/theme_bloc.dart';
import 'package:pet_addoption_app/src/presentation/pages/details_page.dart';
import 'package:pet_addoption_app/src/presentation/pages/history_page.dart';
import 'package:pet_addoption_app/src/presentation/pages/home_page.dart';

import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<PetBloc>()
            ..add(LoadAvailablePets())
        
        ),
        BlocProvider(
          create: (_) => ThemeBloc(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Pet Adoption',
            debugShowCheckedModeBanner: false,
            theme: state.isLight
                ? ThemeData(
                    primarySwatch: Colors.blue,
                    brightness: Brightness.light,
                  )
                : ThemeData(
                    primarySwatch: Colors.blue,
                    brightness: Brightness.dark,
                  ),
            initialRoute: '/',
            routes: {
              '/': (context) => HomePage(),
              '/history': (context) => HistoryPage(),
              '/details': (context) => DetailsPage(
                    pet: ModalRoute.of(context)!.settings.arguments as Pet,
                  ),
            },
          );
        },
      ),
    );
  }
}
