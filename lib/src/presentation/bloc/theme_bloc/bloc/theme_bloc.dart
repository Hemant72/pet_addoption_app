import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(isLight: true)) {
    on<ToggleTheme>((event, emit) {
      emit(ThemeState(isLight: !state.isLight));
    });
  }
}
