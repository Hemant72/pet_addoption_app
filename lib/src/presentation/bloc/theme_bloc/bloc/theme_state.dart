part of 'theme_bloc.dart';

 class ThemeState extends Equatable {
  final bool isLight;

  const ThemeState({required this.isLight});

  @override
  List<Object> get props => [isLight];
}
