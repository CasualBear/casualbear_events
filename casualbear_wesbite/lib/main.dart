import 'package:casualbear_website/network/services/api_service.dart';
import 'package:casualbear_website/screens/cubit/generic_cubit.dart';
import 'package:casualbear_website/screens/repository/generic_repository.dart';
import 'package:casualbear_website/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:html' as html;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final String hash = html.window.location.hash;
    String eventId = Uri.parse(hash).fragment.split('=')[1];
    return MultiBlocProvider(
      providers: [
        BlocProvider<GenericCubit>(
          create: (context) => GenericCubit(GenericRepository(ApiService.shared)),
        ),
      ],
      child: MaterialApp(
          debugShowMaterialGrid: false,
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: const Color(0xff13335d),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: MainScreen(eventId: eventId)),
    );
  }
}

class MainScreen extends StatefulWidget {
  final String eventId;
  const MainScreen({super.key, required this.eventId});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: WelcomeScreen(eventId: widget.eventId));
  }
}
