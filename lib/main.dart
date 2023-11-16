import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transactions/app.dart';

import 'app_bloc_observer.dart';

void main() {
  Bloc.observer = const AppBlocObserver();
  runApp(const App());
}
