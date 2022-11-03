import 'package:bloc/bloc.dart';
import 'package:example/bloc/bloc_observer.dart';
import 'package:example/presentation/app_root.dart';
import 'package:flutter/material.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(AppRoot());
}
