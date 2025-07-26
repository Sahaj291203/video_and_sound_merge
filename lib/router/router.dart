import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_task/cubit/sound_cubit/sound_cubit.dart';
import 'package:interview_task/model/sound_model.dart';
import 'package:interview_task/view/home_view.dart';
import 'package:interview_task/view/sound_list_view.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static const String home = "home";
  static const String soundList = "soundList";

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return _homeViewNavigation(settings);
      case soundList:
        return _soundListViewNavigation(settings);
      default:
        throw Exception("Route We not found");
    }
  }

  static _homeViewNavigation(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) =>
          BlocProvider(create: (context) => SoundCubit(), child: HomeView()),
    );
  }

  static _soundListViewNavigation(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) =>
          SoundListView(data: (settings.arguments) as SoundData),
    );
  }
}
